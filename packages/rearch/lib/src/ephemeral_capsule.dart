part of '../rearch.dart';

/// The observable state of an ephemeral capsule.
@experimental
sealed class Ephemeral<T> {
  /// Creates an ephemeral state.
  const Ephemeral();

  /// The lifecycle generation represented by this state.
  ///
  /// For active states, this is the active instance generation. For inactive
  /// states, this is the generation the next launch will use.
  int get life;

  /// Whether this state is active.
  bool get active;

  /// The active value, or null when this state is inactive.
  T? get nullableValue => switch (this) {
    EphemeralInactive() => null,
    EphemeralActive(:final value) => value,
  };
}

/// Indicates that an ephemeral capsule is not currently active.
@experimental
@immutable
final class EphemeralInactive<T> extends Ephemeral<T> {
  /// Creates an inactive ephemeral state.
  const EphemeralInactive(this.life);

  @override
  final int life;

  @override
  int get hashCode => life.hashCode;

  @override
  bool operator ==(Object other) =>
      other is EphemeralInactive<T> && other.life == life;

  @override
  bool get active => false;

  @override
  String toString() => 'EphemeralInactive(life: $life)';
}

/// Indicates that an ephemeral capsule is currently active with [value].
@experimental
@immutable
final class EphemeralActive<T> extends Ephemeral<T> {
  /// Creates an active ephemeral state with [value].
  const EphemeralActive(this.value, this.life);

  /// The current value returned by the active ephemeral capsule.
  final T value;

  @override
  final int life;

  @override
  int get hashCode => Object.hash(value, life);

  @override
  bool operator ==(Object other) =>
      other is EphemeralActive<T> && other.value == value && other.life == life;

  @override
  bool get active => true;

  @override
  String toString() => 'EphemeralActive(value: $value, life: $life)';
}

/// The handle supplied to ephemeral capsules.
@experimental
abstract interface class EphemeralCapsuleHandle implements CapsuleHandle {
  /// The launch generation for this ephemeral capsule instance.
  ///
  /// This starts at zero for each parameter and increments every time a launch
  /// starts, even if that instance disposes during its initial build.
  int get life;

  /// Disposes the current ephemeral capsule.
  ///
  /// If called while the ephemeral capsule is building, disposal is completed
  /// synchronously as soon as that build exits.
  void dispose();
}

/// Coordinates a parameterized set of ephemeral capsule instances.
@experimental
final class EphemeralOrchestrator<Param, Return> {
  /// Creates an ephemeral orchestrator.
  EphemeralOrchestrator(SideEffectApi api, this._builder)
    : _owner = _asCapsuleManager(api);

  final Return Function(EphemeralCapsuleHandle, Param) _builder;
  final _CapsuleManager _owner;
  final _entries = <Param, _EphemeralEntry<Param, Return>>{};

  /// Reads the current state for [param], optionally launching it.
  ///
  /// [launch] receives the next launch generation for [param], starting at
  /// zero. Returning true launches the ephemeral instance when it is inactive;
  /// returning false keeps it inactive.
  Ephemeral<Return> read(Param param, bool Function(int life) launch) {
    return _read(param, launch);
  }

  Ephemeral<Return> _read(Param param, bool Function(int life) launch) {
    final entry = _entryOf(param);
    if (entry.manager != null) return entry.state;
    if (!launch(entry.lives)) return entry.state;

    final manager = _EphemeralManager<Param, Return>(this, param, entry.lives);
    entry
      ..lives += 1
      ..manager = manager;

    try {
      manager.buildSelf();
    } catch (_) {
      manager.dispose();
      rethrow;
    }

    return entry.state;
  }

  _EphemeralEntry<Param, Return> _entryOf(Param param) {
    return _entries.putIfAbsent(param, _EphemeralEntry<Param, Return>.new);
  }

  void _markActive(
    Param param,
    _EphemeralManager<Param, Return> manager,
    Return value,
  ) {
    final entry = _entryOf(param);
    final newState = EphemeralActive(value, manager.life);
    if (identical(entry.manager, manager) && entry.state == newState) return;

    entry
      ..manager = manager
      ..state = newState;
    _owner.container._notifyNodeChanged(_owner);
  }

  void _markInactive(Param param, _EphemeralManager<Param, Return> manager) {
    final entry = _entryOf(param);
    if (!identical(entry.manager, manager)) return;

    entry.manager = null;
    final newState = EphemeralInactive<Return>(entry.lives);
    if (entry.state == newState) return;

    entry.state = newState;
    _owner.container._notifyNodeChanged(_owner);
  }

  static _CapsuleManager _asCapsuleManager(SideEffectApi api) {
    if (api case final _CapsuleManager manager) return manager;

    throw ArgumentError.value(
      api,
      'api',
      'EphemeralOrchestrator must be created from a capsule side effect.',
    );
  }
}

final class _EphemeralEntry<Param, Return> {
  int lives = 0;
  late Ephemeral<Return> state = EphemeralInactive<Return>(lives);
  _EphemeralManager<Param, Return>? manager;
}

final class _EphemeralManager<Param, Return> extends _BuildManager {
  _EphemeralManager(this.orchestrator, this.param, this.life) {
    container._ephemeralManagers.add(this);
  }

  final EphemeralOrchestrator<Param, Return> orchestrator;
  final Param param;
  final int life;

  @override
  CapsuleContainer get container => orchestrator._owner.container;

  Return? value;
  bool hasBuilt = false;
  bool isDisposed = false;
  bool _isBuilding = false;
  bool _disposeRequested = false;
  @override
  final List<Object?> sideEffectData = <Object?>[];
  final toDispose = <SideEffectApiCallback>{};

  @override
  bool buildSelf() {
    if (isDisposed) return false;

    final parentBuildingManager = container._currBuildingManager;
    container._currBuildingManager = this;
    container._buildDepth++;
    _isBuilding = true;
    try {
      clearDependencies();

      final newValue = orchestrator._builder(
        _EphemeralCapsuleHandleImpl(this),
        param,
      );
      if (_disposeRequested) return false;

      final didChange = !hasBuilt || newValue != value;
      value = newValue;
      hasBuilt = true;
      if (didChange) {
        orchestrator._markActive(param, this, newValue);
      }
      return didChange;
    } finally {
      _isBuilding = false;
      container._buildDepth--;
      container._currBuildingManager = parentBuildingManager;
      if (_disposeRequested && !isDisposed) {
        _disposeNow();
      }
      container._flushChangedNodeNotifications();
    }
  }

  @override
  bool get isIdempotent => false;

  @override
  // The real cleanup path is _disposeNow, which calls super.dispose(). When
  // disposal is requested during build, cleanup must wait until build exits.
  // ignore: must_call_super
  void dispose() {
    if (isDisposed || _disposeRequested) return;

    _disposeRequested = true;
    if (_isBuilding) return;

    _disposeNow();
  }

  void _disposeNow() {
    if (isDisposed) return;
    isDisposed = true;

    container._ephemeralManagers.remove(this);
    super.dispose();
    for (final callback in toDispose.toList()) {
      callback();
    }
    toDispose.clear();
    sideEffectData.clear();
    orchestrator._markInactive(param, this);
  }

  @override
  R read<R>(Capsule<R> otherCapsule) {
    final otherManager = container._managerOf(otherCapsule);
    addDependency(otherManager);
    return otherManager.data as R;
  }

  @override
  void rebuild([
    void Function(void Function() cancelRebuild)? sideEffectMutation,
  ]) {
    if (isDisposed) return;

    if (container._currBuildingManager != null) {
      assert(
        container._currBuildingManager == this,
        'You are not allowed to trigger rebuilds within an ongoing build of a '
        'different capsule or ephemeral capsule!',
      );

      sideEffectMutation?.call(() {});
      return;
    }

    container.runTransaction(() {
      container._sideEffectMutationsToCallInTxn!.add(() {
        if (isDisposed) return null;

        var isCanceled = false;
        sideEffectMutation?.call(() => isCanceled = true);
        return isCanceled || isDisposed ? null : this;
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

final class _EphemeralCapsuleHandleImpl extends _CapsuleHandleImpl
    implements EphemeralCapsuleHandle {
  _EphemeralCapsuleHandleImpl(this.ephemeralManager) : super(ephemeralManager);

  final _EphemeralManager<dynamic, dynamic> ephemeralManager;

  @override
  int get life => ephemeralManager.life;

  @override
  void dispose() => ephemeralManager.dispose();
}
