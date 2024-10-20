part of '../rearch.dart';

typedef _UntypedCapsule = Capsule<Object?>;

class _CapsuleManager extends DataflowGraphNode
    implements SideEffectApi, Disposable {
  _CapsuleManager(this.container, this.capsule) {
    buildSelf();
  }

  final CapsuleContainer container;
  final _UntypedCapsule capsule;

  late Object? data;
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
    return otherManager.data as R;
  }

  @override
  bool buildSelf() {
    final parentBuildingManager = container._currBuildingManager;
    container._currBuildingManager = this;
    try {
      // Clear dependency relationships as they will be repopulated via `read`
      clearDependencies();

      // Build the capsule's new data
      final newData = capsule(_CapsuleHandleImpl(this));
      final didChange = !hasBuilt || newData != data;
      data = newData;
      hasBuilt = true;
      return didChange;
    } finally {
      container._currBuildingManager = parentBuildingManager;
    }
  }

  @override
  bool get isIdempotent => sideEffectData.isEmpty;

  @override
  void dispose() {
    super.dispose();
    container._capsules.remove(capsule);
    for (final callback in toDispose) {
      callback();
    }
  }

  @override
  void rebuild([
    void Function(void Function() cancelRebuild)? sideEffectMutation,
  ]) {
    if (container._currBuildingManager != null) {
      assert(
        container._currBuildingManager == this,
        'You are not allowed to run side effect transactions/trigger rebuilds '
        'within an ongoing build of a different capsule! '
        'This likely happened because you made a call to setState() or similar '
        'while a different capsule was building, or in a container listener. '
        'See here for more: '
        'https://rearch.gsconrad.com/core/effects#transactions',
      );

      // Call the mutation with a no-op cancelRebuild
      // (since we are already in the midst of building ourselves).
      sideEffectMutation?.call(() {});
      return;
    }

    container.runTransaction(() {
      container._sideEffectMutationsToCallInTxn!.add(() {
        var isCanceled = false;
        sideEffectMutation?.call(() => isCanceled = true);
        return isCanceled ? null : this;
      });
    });
  }

  @override
  void registerDispose(SideEffectApiCallback callback) =>
      toDispose.add(callback);

  @override
  void unregisterDispose(SideEffectApiCallback callback) =>
      toDispose.remove(callback);

  @override
  void runTransaction(void Function() sideEffectTransaction) =>
      container.runTransaction(sideEffectTransaction);
}

class _CapsuleHandleImpl implements CapsuleHandle {
  _CapsuleHandleImpl(this.manager);

  final _CapsuleManager manager;

  int sideEffectDataIndex = 0;

  @override
  T call<T>(Capsule<T> capsule) {
    assert(
      manager.container._currBuildingManager == manager,
      'You may only "use(someCapsule)" during a capsule\'s build!\n'
      'You are getting this error because:\n'
      '1. Your capsule returns a function that calls "use(someCapsule)" in it\n'
      '2. Your capsule calls "use(someCapsule)" after an "await"',
    );

    return manager.read(capsule);
  }

  @override
  T register<T>(SideEffect<T> sideEffect) {
    assert(
      manager.container._currBuildingManager == manager,
      "You may only register side effects during a capsule's build!\n"
      'You are getting this error because:\n'
      '1. Your capsule returns a function that calls "use.fooBar()" in it\n'
      '2. Your capsule calls "use.fooBar()" after an "await"',
    );

    if (sideEffectDataIndex == manager.sideEffectData.length) {
      manager.sideEffectData.add(sideEffect(manager));
    }
    return manager.sideEffectData[sideEffectDataIndex++] as T;
  }
}
