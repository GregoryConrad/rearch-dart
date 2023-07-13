import 'package:meta/meta.dart';
import 'package:rearch/src/node.dart';

export 'src/side_effects.dart';
export 'src/types.dart';

part 'src/impl.dart';

/// Represents a disposable object.
// ignore: one_member_abstracts
abstract interface class Disposable {
  /// Disposes any resources associated with this object.
  void dispose();
}

/// A blueprint for creating some data, given a [CapsuleHandle].
/// See the documentation for more.
typedef Capsule<T> = T Function(CapsuleHandle);

/// Capsule listeners are a mechanism to *temporarily* listen to changes
/// to a set of [Capsule]s.
/// See [CapsuleContainer.listen].
typedef CapsuleListener = void Function(CapsuleReader);

/// Provides a mechanism to read the current state of [Capsule]s.
// ignore: one_member_abstracts
abstract interface class CapsuleReader {
  /// Reads the data of the supplied [Capsule].
  T call<T>(Capsule<T> capsule);
}

/// Provides a mechanism ([register]) to register side effects.
// ignore: one_member_abstracts
abstract interface class SideEffectRegistrar {
  /// Registers the given side effect.
  T register<T>(SideEffect<T> sideEffect);
}

/// The handle given to a [Capsule] to build its data.
/// See [CapsuleReader] and [SideEffectRegistrar].
abstract interface class CapsuleHandle
    implements CapsuleReader, SideEffectRegistrar {}

/// Defines what a [SideEffect] should look like (a [Function]
/// that consumes a [SideEffectApi] and returns something).
/// See the documentation for more.
typedef SideEffect<T> = T Function(SideEffectApi);

/// A `void Function()` callback.
typedef SideEffectApiCallback = void Function();

/// The api given to [SideEffect]s to create their state.
abstract interface class SideEffectApi {
  /// Triggers a rebuild in the supplied capsule.
  void rebuild();

  /// Registers the given [SideEffectApiCallback]
  /// to be called on capsule disposal.
  void registerDispose(SideEffectApiCallback callback);

  /// Unregisters the given [SideEffectApiCallback]
  /// from being called on capsule disposal.
  void unregisterDispose(SideEffectApiCallback callback);
}

/// Contains the data of [Capsule]s.
/// See the documentation for more.
class CapsuleContainer implements Disposable {
  final _capsules = <_UntypedCapsule, _UntypedCapsuleManager>{};

  _CapsuleManager<T> _managerOf<T>(Capsule<T> capsule) {
    return _capsules.putIfAbsent(
      capsule,
      () => _CapsuleManager<T>(this, capsule),
    ) as _CapsuleManager<T>;
  }

  /// Reads the current data of the supplied [Capsule].
  T read<T>(Capsule<T> capsule) => _managerOf(capsule).data;

  /// *Temporarily* listens to changes in a given set of [Capsule]s.
  /// If you want to listen to capsule(s) *not temporarily*,
  /// instead just make an impure capsule and [read] it once to initialize it.
  /// `listen` calls the supplied listener immediately,
  /// and then after any capsules its listening to change.
  @UseResult('ListenerHandle will leak its listener if it is not disposed')
  ListenerHandle listen(CapsuleListener listener) {
    // Create a temporary *impure* capsule so that it doesn't get super-pure
    // garbage collected
    void capsule(CapsuleHandle use) {
      use.register((_) {});
      listener(use);
    }

    // Put the temporary capsule into the container so it gets data updates
    read(capsule);

    return ListenerHandle._(this, capsule);
  }

  @override
  void dispose() {
    // We need toList() to prevent container modification during iteration
    for (final manager in _capsules.values.toList()) {
      manager.dispose();
    }
  }
}

/// A handle onto the lifecycle of a listener from [CapsuleContainer.listen].
/// You *must* [dispose] the [ListenerHandle]
/// when you no longer need the listener in order to prevent leaks.
class ListenerHandle implements Disposable {
  ListenerHandle._(this._container, this._capsule);

  final CapsuleContainer _container;
  final _UntypedCapsule _capsule;

  @override
  void dispose() => _container._capsules[_capsule]?.dispose();
}
