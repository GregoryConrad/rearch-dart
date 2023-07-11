part of '../widgets.dart';

/// {@template rearch.capsuleConsumer}
/// A [Widget] that has access to a [WidgetHandle],
/// and can consequently consume [Capsule]s and [SideEffect]s.
/// {@endtemplate}
abstract class CapsuleConsumer extends Widget {
  /// {@macro rearch.capsuleConsumer}
  const CapsuleConsumer({super.key});

  @override
  Element createElement() => _RearchElement(this);

  /// Builds the [Widget] using the supplied [context] and [use].
  @protected
  Widget build(BuildContext context, WidgetHandle use);
}

class _RearchElement extends ComponentElement {
  _RearchElement(CapsuleConsumer super.widget);

  final deactivateListeners = <SideEffectApiCallback>{};
  final disposeListeners = <SideEffectApiCallback>{};
  final sideEffectData = <Object?>[];
  final listenerHandles = <ListenerHandle>[];

  void clearHandles() {
    for (final handle in listenerHandles) {
      handle.dispose();
    }
    listenerHandles.clear();
  }

  @override
  Widget build() {
    clearHandles(); // listeners will be repopulated via _WidgetHandleImpl
    final container = CapsuleContainerProvider.containerOf(this);
    final consumer = super.widget as CapsuleConsumer;
    return consumer.build(
      this,
      _WidgetHandleImpl(
        _WidgetSideEffectApiImpl(this),
        container,
      ),
    );
  }

  @override
  void deactivate() {
    for (final listener in deactivateListeners) {
      listener();
    }
    clearHandles();

    super.deactivate();
  }

  @override
  void unmount() {
    for (final listener in disposeListeners) {
      listener();
    }
    clearHandles();

    // Clean up after any side effects to avoid possible leaks
    deactivateListeners.clear();
    disposeListeners.clear();

    super.unmount();
  }
}

/// This is needed so that [WidgetSideEffectApi.rebuild] doesn't conflict with
/// [Element.rebuild].
class _WidgetSideEffectApiImpl implements WidgetSideEffectApi {
  const _WidgetSideEffectApiImpl(this.manager);
  final _RearchElement manager;

  @override
  void rebuild() => manager.markNeedsBuild();

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
}

class _WidgetHandleImpl implements WidgetHandle {
  _WidgetHandleImpl(this.api, this.container);

  final _WidgetSideEffectApiImpl api;
  final CapsuleContainer container;
  int sideEffectDataIndex = 0;

  @override
  T call<T>(Capsule<T> capsule) {
    // Add capsule as dependency
    var hasCalledBefore = false;
    final handle = container.listen((use) {
      use(capsule); // mark capsule as a dependency

      // If this isn't the immediate call after registering, rebuild
      if (hasCalledBefore) {
        api.rebuild();
      }
      hasCalledBefore = true;
    });
    api.manager.listenerHandles.add(handle);

    return container.read(capsule);
  }

  @override
  T register<T>(WidgetSideEffect<T> sideEffect) {
    if (sideEffectDataIndex == api.manager.sideEffectData.length) {
      api.manager.sideEffectData.add(sideEffect(api));
    }
    return api.manager.sideEffectData[sideEffectDataIndex++] as T;
  }
}
