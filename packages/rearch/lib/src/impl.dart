part of '../rearch.dart';

typedef _UntypedCapsule = Capsule<Object?>;
typedef _UntypedCapsuleManager = _CapsuleManager<Object?>;

class _CapsuleManager<T> extends DataflowGraphNode
    implements SideEffectApi, Disposable {
  _CapsuleManager(this.container, this.capsule) {
    buildSelf();
  }

  final CapsuleContainer container;
  final Capsule<T> capsule;

  late T data;
  bool hasBuilt = false;
  final sideEffectData = <Object?>[];
  final toDispose = <SideEffectApiCallback>{};

  R read<R>(Capsule<R> otherCapsule) {
    if (otherCapsule == capsule) {
      if (hasBuilt) {
        return data as R;
      } else {
        throw StateError(
          'A capsule cannot read its own data in its first build '
          "(as its data won't exist yet)! "
          'Consider using the isFirstBuild() side effect to avoid reading '
          "a capsule's data in its first build.",
        );
      }
    }

    final otherManager = container._managerOf(otherCapsule);
    addDependency(otherManager);
    return otherManager.data;
  }

  @override
  bool buildSelf() {
    // Clear dependency relationships as they will be repopulated via `read`
    clearDependencies();

    // Build the capsule's new data
    final newData = capsule(_CapsuleHandleImpl(this));
    final didChange = !hasBuilt || newData != data;
    data = newData;
    hasBuilt = true;
    return didChange;
  }

  @override
  bool get isSuperPure => sideEffectData.isEmpty;

  @override
  void dispose() {
    super.dispose();
    container._capsules.remove(capsule);
    for (final callback in toDispose) {
      callback();
    }
  }

  @override
  void rebuild() => buildSelfAndDependents();

  @override
  void registerDispose(SideEffectApiCallback callback) =>
      toDispose.add(callback);

  @override
  void unregisterDispose(SideEffectApiCallback callback) =>
      toDispose.remove(callback);
}

class _CapsuleHandleImpl implements CapsuleHandle {
  _CapsuleHandleImpl(this.manager);

  final _UntypedCapsuleManager manager;

  int sideEffectDataIndex = 0;

  @override
  T call<T>(Capsule<T> capsule) => manager.read(capsule);

  @override
  T register<T>(SideEffect<T> sideEffect) {
    if (sideEffectDataIndex == manager.sideEffectData.length) {
      manager.sideEffectData.add(sideEffect(manager));
    }
    return manager.sideEffectData[sideEffectDataIndex++] as T;
  }
}
