part of '../widgets.dart';

///.
abstract class RearchComponent extends Component2 {
  // bool _needsBuild = false;

  ///.
  String get debugName;

  ///.
  void debug(String msg) => print('<$debugName> -- $msg');

  ///.
  final willUnmountListeners = <SideEffectApiCallback>{};

  ///.
  final sideEffectData = <Object?>[];

  /// Represents a [Set] of functions that remove a dependency on a [Capsule].
  final dependencyDisposers = <void Function()>{};

  /// Clears out the [Capsule] dependencies of this [RearchComponent].
  void clearDependencies() {
    for (final dispose in dependencyDisposers) {
      dispose();
    }
    dependencyDisposers.clear();
  }

  @override
  void componentWillUnmount() {
    for (final listener in willUnmountListeners) {
      listener();
    }

    clearDependencies();

    // Clean up after any side effects to avoid possible leaks
    willUnmountListeners.clear();

    super.componentWillUnmount();
  }

  @override
  ReactNode render() {
    debug('render()');

    // Clear dirty flag.
    // _clearNeedsBuild();

    // Clears the old dependencies (which will be repopulated via WidgetHandle)
    clearDependencies();

    return build(
      _ComponentHandleImpl(
        _ComponentSideEffectApiProxyImpl(this),
        topLevelCapsuleContainer,
      ),
    );
  }

  ///.
  ReactNode build(ComponentHandle use);

  /// Set dirty flag and schedule update on next event loop.
  // void markNeedsBuild() {
  //   if (_needsBuild) {
  //     return;
  //   }

  //   _needsBuild = true;

  //   Future.microtask(forceUpdate);
  // }

  // void _clearNeedsBuild() {
  //   if (!_needsBuild) {
  //     return;
  //   }

  //   _needsBuild = false;
  // }
}

/// This is needed so that [ComponentSideEffectApi.rebuild] doesn't conflict
/// with [Component2.forceUpdate].
class _ComponentSideEffectApiProxyImpl implements ComponentSideEffectApi {
  const _ComponentSideEffectApiProxyImpl(this.component);
  final RearchComponent component;

  @override
  void rebuild([
    void Function(void Function() cancelRebuild)? sideEffectMutation,
  ]) {
    if (sideEffectMutation != null) {
      var isCanceled = false;
      sideEffectMutation(() => isCanceled = true);
      if (isCanceled) return;
    }

    // component.markNeedsBuild();
    component
      ..debug('forceUpdate()')
      ..forceUpdate();
  }

  @override
  void registerDispose(SideEffectApiCallback callback) =>
      component.willUnmountListeners.add(callback);

  @override
  void unregisterDispose(SideEffectApiCallback callback) =>
      component.willUnmountListeners.remove(callback);

  /// [rebuild] just marks the corresponding widget as dirty,
  /// so all affected widgets will be built together on the next frame for free.
  /// Thus, all we need to do is update all the capsules in a single txn
  /// before the widgets are built again.
  /// This works out somewhat nicely, as we can easily intermingle
  /// widget and capsule side effects within a single transaction.
  @override
  void runTransaction(void Function() sideEffectTransaction) =>
      topLevelCapsuleContainer.runTransaction(sideEffectTransaction);
}

class _ComponentHandleImpl implements ComponentHandle {
  _ComponentHandleImpl(this.api, this.container);

  final _ComponentSideEffectApiProxyImpl api;
  final CapsuleContainer container;
  int sideEffectDataIndex = 0;

  @override
  T call<T>(Capsule<T> capsule) {
    final dispose = container.onNextUpdate(capsule, api.rebuild);
    api.component.dependencyDisposers.add(dispose);
    return container.read(capsule);
  }

  @override
  T register<T>(ComponentSideEffect<T> sideEffect) {
    /// Not available on Dart React.
    // assert(
    //   api.manager.debugDoingBuild,
    //   "You may only register side effects during a RearchConsumers's build! "
    //   'You are likely getting this error because you are calling '
    //   '"use.fooBar()" in a function callback.',
    // );

    if (sideEffectDataIndex == api.component.sideEffectData.length) {
      api.component.sideEffectData.add(sideEffect(api));
    }
    return api.component.sideEffectData[sideEffectDataIndex++] as T;
  }
}
