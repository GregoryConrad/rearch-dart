/// A collection of ReArch experiments in case you like exploring the unknown.
///
/// Nothing here is officially supported;
/// items may come and go or experience breaking changes on any new release.
/// Further, items here may be untested so use at your own risk!
@experimental
library experimental;

import 'package:meta/meta.dart';
import 'package:rearch/rearch.dart';

extension _UseConvenience on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
}

/// A collection of experimental side effects to
/// complement the [BuiltinSideEffects].
extension ExperimentalSideEffects on SideEffectRegistrar {
  /// Returns a raw value wrapper; i.e., a getter and setter for some value.
  /// *The setter will not trigger rebuilds*.
  /// The initial state will be set to the result of running [init],
  /// if it was provided. Otherwise, you must manually set it
  /// via the setter before ever calling the getter.
  // NOTE: experimental because I am not sold on the API and use cases
  // for non-internal usage.
  (T Function(), void Function(T)) rawValueWrapper<T>([T Function()? init]) {
    return use.callonce(() {
      late T state;
      if (init != null) state = init();
      return (() => state, (T newState) => state = newState);
    });
  }

  /// A mechanism to persist changes made to some provided state.
  /// Unlike [persist], [hydrate] allows you to pass in the state to persist,
  /// if there is one, to enable easier composition with other side effects.
  ///
  /// Defines a way to interact with a storage provider of your choice
  /// through the [read] and [write] parameters.
  /// - If [newData] is [Some], then [newData] will be persisted and
  /// overwrite any existing persisted data.
  /// - If [newData] is [None], then no changes will be made to the currently
  /// persisted value (for when you don't have state to persist yet).
  ///
  /// [read] is only called once; it is assumed that if [write] is successful,
  /// then calling [read] again would reflect the new state that we already
  /// have access to. Thus, calling [read] again is skipped as an optimization.
  // NOTE: experimental because I am not sold on the Option<T> parameter.
  AsyncValue<T> hydrate<T>(
    Option<T> newData, {
    required Future<T> Function() read,
    required Future<void> Function(T) write,
  }) {
    final readFuture = use.callonce(read);
    final readState = use.future(readFuture);
    final (getPrevData, setPrevData) =
        use.rawValueWrapper<Option<T>>(None<T>.new);
    final (getWriteFuture, setWriteFuture) =
        use.rawValueWrapper<Future<T>?>(() => null);

    if (newData case Some(value: final data)) {
      final dataChanged =
          getPrevData().map((prevData) => data != prevData).unwrapOr(true);
      if (dataChanged) {
        setPrevData(Some(data));
        setWriteFuture(() async {
          await write(data);
          return data;
        }());
      }
    }

    final writeState = use.nullableFuture(getWriteFuture());
    return (writeState ?? readState).fillInPreviousData(readState.data);
  }
}
