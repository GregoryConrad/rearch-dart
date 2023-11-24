import 'package:meta/meta.dart';
import 'package:rearch/src/node.dart';
import 'package:rearch/src/side_effects.dart';

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
typedef CapsuleListener = void Function(CapsuleHandle);

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

  /// Reads the current data of the supplied [Capsule],
  /// initializing it if needed.
  T read<T>(Capsule<T> capsule) => _managerOf(capsule).data;

  /// *Temporarily* listens to changes in a given set of [Capsule]s.
  ///
  /// Calls the supplied [listener] immediately,
  /// and then after any capsules it's listening to change.
  /// You *must* call the returned dispose [Function]
  /// when you no longer need the listener in order to prevent leaks.
  ///
  /// If you want to listen to capsule(s) *not temporarily*, instead just make
  /// a non-idempotent capsule and [read] it once to initialize it.
  /// (See the documentation for more on this topic.)
  @UseResult('Listener will leak in the container if it is not disposed')
  void Function() listen(CapsuleListener listener) {
    // Create a temporary *non-idempotent* capsule so that it doesn't get
    // idempotent garbage collected
    void capsule(CapsuleHandle use) {
      use.asListener();
      listener(use);
    }

    // Put the temporary capsule into the container so it gets data updates
    final manager = _managerOf(capsule);

    return manager.dispose;
  }

  /// Runs the supplied [callback] the next time [capsule] is
  /// updated *or* disposed.
  ///
  /// You can also prematurely remove the callback from the container
  /// via the returned [void Function()] (which does not invoke [callback]).
  /// It also will free [capsule] from the container if possible
  /// (i.e., if it is idempotent and has no dependents) when invoked.
  ///
  /// # WARNING!
  /// It is highly recommended not to use this method as I reserve the right
  /// to breakingly change or remove it at will in any new release.
  @experimental
  void Function() onNextUpdate<T>(
    Capsule<T> capsule,
    void Function() callback,
  ) {
    // This uses the fact that if we add an idempotent capsule, it will be
    // automatically disposed whenever the supplied capsule is updated/disposed
    // via the idempotent gc.
    void tempCapsule(CapsuleReader use) => use<T>(capsule);
    final tempManager = _managerOf(tempCapsule);
    tempManager.toDispose.add(callback);

    return () {
      tempManager.toDispose.remove(callback);
      tempManager.dispose();

      // Eagerly garbage collect capsule if possible to prevent possible leaks
      // when inline capsules are used.
      // We could also employ a more sophisticated GC strategy
      // by searching the graph and finding other disposable nodes,
      // but this should cover 99% of cases effectively with no extra cost.
      final capManager = _capsules[capsule];
      if (capManager != null &&
          capManager.isIdempotent &&
          capManager.hasNoDependents) {
        capManager.dispose();
      }
    };
  }

  @override
  void dispose() {
    // We need toList() to copy the list in order to
    // prevent container modification during iteration
    // (dispose() removes the manager from the container).
    for (final manager in _capsules.values.toList()) {
      manager.dispose();
    }
  }
}

/// Provides the [map] convenience method on [Capsule]s.
extension CapsuleMapper<T> on Capsule<T> {
  /// Maps this [Capsule] (of type [T]) into
  /// a new idempotent [Capsule] (of type [R])
  /// by applying the given [mapper].
  ///
  /// This is similar to `.select()` in some other libraries.
  Capsule<R> map<R>(R Function(T) mapper) {
    return (CapsuleReader use) => mapper(use(this));
  }
}
