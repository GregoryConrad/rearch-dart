part of '../widgets.dart';

/// {@template rearch.rearchBuilder}
/// A [Builder]-style [Widget] whose [builder] has access to a [WidgetHandle]
/// and can consequently consume [Capsule]s and [SideEffect]s.
/// {@endtemplate}
class RearchBuilder extends RearchConsumer {
  /// {@macro rearch.rearchBuilder}
  const RearchBuilder({
    required this.builder,
    super.key,
  });

  /// Builds the child [Widget] with the supplied [BuildContext] and
  /// [WidgetHandle].
  final Widget Function(BuildContext, WidgetHandle) builder;

  @override
  Widget build(BuildContext context, WidgetHandle use) => builder(context, use);
}

/// {@template rearch.rearchConsumer}
/// A [Widget] that has access to a [WidgetHandle]
/// and can consequently consume [Capsule]s and [SideEffect]s.
/// {@endtemplate}
abstract class RearchConsumer extends Widget {
  /// {@macro rearch.rearchConsumer}
  const RearchConsumer({super.key});

  @override
  Element createElement() => _RearchElement(this);

  /// Builds the [Widget] using the supplied [context] and [use].
  @protected
  Widget build(BuildContext context, WidgetHandle use);
}

class _RearchElement extends ComponentElement {
  _RearchElement(RearchConsumer super.widget);

  final deactivateListeners = <SideEffectApiCallback>{};
  final disposeListeners = <SideEffectApiCallback>{};
  final sideEffectData = <Object?>[];

  /// Represents a [Map] of capsules to void [Function]s that
  /// remove the dependency of this [Element] on those capsules.
  final capsuleToRemoveDependency = <Capsule<Object?>, void Function()>{};

  /// Represents the [Set] of `use`d capsules in the ongoing build.
  Set<Capsule<Object?>>? capsulesUsedInCurrBuild;

  /// Clears out the [Capsule] dependencies of this [_RearchElement].
  void clearDependencies() {
    for (final dispose in capsuleToRemoveDependency.values) {
      dispose();
    }
    capsuleToRemoveDependency.clear();
  }

  @override
  Widget build() {
    capsulesUsedInCurrBuild = {};
    final container = CapsuleContainerProvider.containerOf(this);
    try {
      final consumer = super.widget as RearchConsumer;
      return consumer.build(
        this,
        _WidgetHandleImpl(
          _WidgetSideEffectApiProxyImpl(this),
          container,
        ),
      );
    } finally {
      // We need to do some dependency management here to ensure that we
      // get all the capsule updates we need, but nothing more.

      // First, ensure we depend upon every capsule used in the current build.
      for (final capsule in capsulesUsedInCurrBuild!) {
        capsuleToRemoveDependency.putIfAbsent(
          capsule,
          () => container.onNextUpdate(capsule, () {
            markNeedsBuild();
            capsuleToRemoveDependency.remove(capsule);
          }),
        );
      }

      // Next, remove any no-longer used dependencies.
      capsuleToRemoveDependency.keys
          .toSet()
          .difference(capsulesUsedInCurrBuild!)
          .forEach((capsule) {
        // NOTE: this will call the dispose() returned from onNextUpdate
        capsuleToRemoveDependency.remove(capsule)!.call();
      });

      // Finally, let's reset everything for the next build.
      capsulesUsedInCurrBuild = null;
    }
  }

  // NOTE: for some reason, Flutter doesn't rebuild an Element automatically
  // when its Widget changes; thus, we need to override this method.
  // See https://github.com/GregoryConrad/rearch-dart/issues/163
  @override
  void update(RearchConsumer newWidget) {
    super.update(newWidget);
    rebuild(force: true);
  }

  @override
  void deactivate() {
    for (final listener in deactivateListeners) {
      listener();
    }
    clearDependencies();

    super.deactivate();
  }

  @override
  void unmount() {
    for (final listener in disposeListeners) {
      listener();
    }

    // Clean up after any side effects to avoid possible leaks
    deactivateListeners.clear();
    disposeListeners.clear();

    super.unmount();
  }
}

/// This is needed so that [WidgetSideEffectApi.rebuild] doesn't conflict with
/// [Element.rebuild].
class _WidgetSideEffectApiProxyImpl implements WidgetSideEffectApi {
  const _WidgetSideEffectApiProxyImpl(this.manager);
  final _RearchElement manager;

  @override
  void rebuild([
    void Function(void Function() cancelRebuild)? sideEffectMutation,
  ]) {
    if (sideEffectMutation != null) {
      var isCanceled = false;
      sideEffectMutation(() => isCanceled = true);
      if (isCanceled) return;
    }

    if (manager.mounted) manager.markNeedsBuild();
  }

  @override
  BuildContext get context => manager;

  @override
  void addDeactivateListener(SideEffectApiCallback callback) =>
      manager.deactivateListeners.add(callback);

  @override
  void removeDeactivateListener(SideEffectApiCallback callback) =>
      manager.deactivateListeners.remove(callback);

  @override
  void registerDispose(SideEffectApiCallback callback) =>
      manager.disposeListeners.add(callback);

  @override
  void unregisterDispose(SideEffectApiCallback callback) =>
      manager.disposeListeners.remove(callback);

  /// [rebuild] just marks the corresponding widget as dirty,
  /// so all affected widgets will be built together on the next frame for free.
  /// Thus, all we need to do is update all the capsules in a single txn
  /// before the widgets are built again.
  /// This works out somewhat nicely, as we can easily intermingle
  /// widget and capsule side effects within a single transaction.
  @override
  void runTransaction(void Function() sideEffectTransaction) =>
      CapsuleContainerProvider.containerOf(manager)
          .runTransaction(sideEffectTransaction);
}

class _WidgetHandleImpl implements WidgetHandle {
  _WidgetHandleImpl(this.api, this.container);

  final _WidgetSideEffectApiProxyImpl api;
  final CapsuleContainer container;
  int sideEffectDataIndex = 0;

  @override
  T call<T>(Capsule<T> capsule) {
    api.manager.capsulesUsedInCurrBuild?.add(capsule);
    final isCurrentlyBuilding = api.manager.capsulesUsedInCurrBuild != null;
    if (!isCurrentlyBuilding) {
      log(
        'You attempted to use() a capsule outside of the widget build!\n'
        'While this is currently allowed to support things such as:\n'
        '  onPressed: () => use(myManager).value = newState,\n'
        'You should *not* be relying upon this behavior, as:\n'
        '  1. I reserve the right to change this behavior in the future\n'
        '  2. Rebuilds will *not* be triggered when the capsule changes\n'
        'To fix this, simply add a line near the start of your build function '
        'that preemptively use()-s the capsule and stores that result. '
        'This warning can also be triggered if you have a Builder-style widget '
        'that uses the WidgetHandle of one of its ancestors; '
        'the same fix applies in that situation.',
        level: 900, // NOTE: this is Level.WARNING from package:logging
        stackTrace: StackTrace.current,
      );
    }

    return container.read(capsule);
  }

  @override
  T register<T>(WidgetSideEffect<T> sideEffect) {
    assert(
      api.manager.debugDoingBuild,
      "You may only register side effects during a RearchConsumers's build! "
      'You are likely getting this error because you are calling '
      '"use.fooBar()" in a function callback.',
    );

    if (sideEffectDataIndex == api.manager.sideEffectData.length) {
      api.manager.sideEffectData.add(sideEffect(api));
    }
    return api.manager.sideEffectData[sideEffectDataIndex++] as T;
  }
}
