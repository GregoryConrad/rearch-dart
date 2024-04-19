part of '../components.dart';

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

  /// Represents a [Set] of functions that remove a dependency on a [Capsule].
  final dependencyDisposers = <void Function()>{};

  /// Clears out the [Capsule] dependencies of this [_RearchElement].
  void clearDependencies() {
    for (final dispose in dependencyDisposers) {
      dispose();
    }
    dependencyDisposers.clear();
  }

  @override
  Widget build() {
    // Clears the old dependencies (which will be repopulated via WidgetHandle)
    clearDependencies();

    final container = CapsuleContainerProvider.containerOf(this);
    final consumer = super.widget as RearchConsumer;
    return consumer.build(
      this,
      _WidgetHandleImpl(
        _WidgetSideEffectApiProxyImpl(this),
        container,
      ),
    );
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

    manager.markNeedsBuild();
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
    final dispose = container.onNextUpdate(capsule, api.rebuild);
    api.manager.dependencyDisposers.add(dispose);
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
