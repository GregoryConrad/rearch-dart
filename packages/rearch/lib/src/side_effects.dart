import 'dart:async';

import 'package:rearch/rearch.dart';

/// A collection of builtin side effects.
extension BuiltinSideEffects on SideEffectRegistrar {
  /// Convenience side effect that gives a copy of the [SideEffectApi].
  SideEffectApi api() => register((api) => api);

  /// Convenience side effect that gives a copy of [SideEffectApi.rebuild].
  void Function() rebuilder() => api().rebuild;

  /// Side effect that calls the supplied [callback] once, on the first build.
  T callonce<T>(T Function() callback) => register((_) => callback());

  /// Returns a raw value wrapper; i.e., a getter and setter for some value.
  /// *The setter will not trigger rebuilds*.
  /// The initial state will be set to the result of running [init],
  /// if it was provided. Otherwise, you must manually set it
  /// via the setter before ever calling the getter.
  (T Function(), void Function(T)) rawValueWrapper<T>([T Function()? init]) {
    return callonce(() {
      late T state;
      if (init != null) state = init();
      return (() => state, (T newState) => state = newState);
    });
  }

  /// Side effect that provides a way for capsules to contain some state,
  /// where the initial state is computationally expensive.
  /// Further, instead of returning the state directly, this instead returns
  /// a getter that is safe to capture in closures.
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  (T Function(), void Function(T)) lazyStateGetterSetter<T>(T Function() init) {
    // We use register directly to keep the same setter function
    // across rebuilds, which actually can help skip certain rebuilds
    return register((api) {
      var state = init();

      T getter() => state;
      void setter(T newState) {
        state = newState;
        api.rebuild();
      }

      return (getter, setter);
    });
  }

  /// Side effect that provides a way for capsules to contain some state.
  /// Further, instead of returning the state directly, this instead returns
  /// a getter that is safe to capture in closures.
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  (T Function(), void Function(T)) stateGetterSetter<T>(T initial) =>
      lazyStateGetterSetter(() => initial);

  /// Side effect that provides a way for capsules to contain some state,
  /// where the initial state is computationally expensive.
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  (T, void Function(T)) lazyState<T>(T Function() init) {
    final (getter, setter) = lazyStateGetterSetter(init);
    return (getter(), setter);
  }

  /// Side effect that provides a way for capsules to contain some state.
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  (T, void Function(T)) state<T>(T initial) => lazyState(() => initial);

  /// Side effect that provides a way for capsules to hold onto some value
  /// between builds, where the initial value is computationally expensive.
  /// Similar to the `useRef` hook from React;
  /// see https://react.dev/reference/react/useRef
  T lazyValue<T>(T Function() init) => callonce(init);

  /// Side effect that provides a way for capsules to hold onto some value
  /// between builds.
  /// Similar to the `useRef` hook from React;
  /// see https://react.dev/reference/react/useRef
  T value<T>(T initial) => lazyValue(() => initial);

  /// Returns the previous value passed into [previous],
  /// or `null` on first build.
  T? previous<T>(T current) {
    final (getter, setter) = rawValueWrapper<T?>(() => null);
    final prev = getter();
    setter(current);
    return prev;
  }

  /// Equivalent to the `useMemo` hook from React.
  /// See https://react.dev/reference/react/useMemo
  T memo<T>(T Function() memo, [List<Object?> dependencies = const []]) {
    final oldDependencies = previous(dependencies);
    final (getData, setData) = rawValueWrapper<T>();
    if (_didDepsListChange(dependencies, oldDependencies)) {
      setData(memo());
    }
    return getData();
  }

  /// Equivalent to the `useEffect` hook from React.
  /// See https://react.dev/reference/react/useEffect
  void effect(
    void Function()? Function() effect, [
    List<Object?>? dependencies,
  ]) {
    final oldDependencies = previous(dependencies);
    final (getDispose, setDispose) =
        rawValueWrapper<void Function()?>(() => null);
    register((api) => api.registerDispose(() => getDispose()?.call()));

    if (dependencies == null ||
        _didDepsListChange(dependencies, oldDependencies)) {
      getDispose()?.call();
      setDispose(effect());
    }
  }

  /// A simple implementation of the reducer pattern as a side effect.
  ///
  /// The React docs do a great job of explaining the reducer pattern more.
  /// See https://react.dev/reference/react/useReducer
  (State, void Function(Action)) reducer<State, Action>(
    Reducer<State, Action> reducer,
    State initialState,
  ) {
    final (currState, setState) = state(initialState);
    return (
      currState,
      (action) => setState(reducer(currState, action)),
    );
  }

  /// Consumes a [Future] and watches the given [future].
  ///
  /// Implemented by calling [Future.asStream] and forwarding calls
  /// onto [stream].
  ///
  /// If the given future changes, then the current [StreamSubscription]
  /// will be disposed and recreated for the new future.
  /// Thus, it is important that the future instance only changes when needed.
  /// It is incorrect to create a future in the same build as the [future],
  /// unless you use something like [memo] to limit changes.
  /// Or, if possible, it is even better to wrap the future in an entirely
  /// new capsule (although this is not always possible).
  AsyncValue<T> future<T>(Future<T> future) {
    final asStream = memo(future.asStream, [future]);
    return stream(asStream);
  }

  /// Consumes a [Stream] and watches the given stream.
  ///
  /// If the given stream changes between build calls, then the current
  /// [StreamSubscription] will be disposed and recreated for the new stream.
  /// Thus, it is important that the stream instance only changes when needed.
  /// It is incorrect to create a stream in the same build as the [stream],
  /// unless you use something like [memo] to limit changes.
  /// Or, if possible, it is even better to wrap the stream in an entirely
  /// new capsule (although this is not always possible).
  AsyncValue<T> stream<T>(Stream<T> stream) {
    final rebuild = rebuilder();
    final (getValue, setValue) = rawValueWrapper<AsyncValue<T>>(
      () => AsyncLoading<T>(None<T>()),
    );

    final (getSubscription, setSubscription) =
        rawValueWrapper<StreamSubscription<T>?>(() => null);
    effect(() => getSubscription()?.cancel, [getSubscription()]);

    final oldStream = previous(stream);
    final needToInitializeState = stream != oldStream;

    if (needToInitializeState) {
      setValue(AsyncLoading(getValue().data));
      setSubscription(
        stream.listen(
          (data) {
            setValue(AsyncData(data));
            rebuild();
          },
          onError: (Object error, StackTrace trace) {
            setValue(AsyncError(error, trace, getValue().data));
            rebuild();
          },
          cancelOnError: false,
        ),
      );
    }

    return getValue();
  }

  /// A mechanism to persist changes made in state.
  /// See the docs for usage information.
  ///
  /// Defines the way to interact with a storage provider of your choice
  /// through the [read] and [write] parameters.
  ///
  /// [read] is only called once; it is assumed that if [write] is successful,
  /// then calling [read] again would reflect the new state that we already
  /// have access to. Thus, calling [read] again is skipped as an optimization.
  (AsyncValue<T>, void Function(T)) persist<T>({
    required Future<T> Function() read,
    required Future<void> Function(T) write,
  }) {
    final readFuture = callonce(read);
    final readState = future(readFuture);
    final (state: writeState, :mutate, clear: _) = mutation<T>();

    final state = (writeState ?? readState).fillInPreviousData(readState.data);

    void persist(T data) {
      mutate(() async {
        await write(data);
        return data;
      }());
    }

    return (state, persist);
  }

  /// Allows you to trigger and watch [Future]s
  /// (called mutations, since they often mutate some state)
  /// from within the build function.
  /// See the documentation for more.
  ///
  /// Note: `mutate()` and `clear()` *should not* be called directly from
  /// within build, but rather from within some callback.
  Mutation<T> mutation<T>() {
    final rebuild = rebuilder();
    final (getValue, setValue) = rawValueWrapper<AsyncValue<T>?>(() => null);

    // We convert to a stream here because we can cancel a stream subscription;
    // there is no builtin way to cancel a future.
    final (future, setFuture) = state<Future<T>?>(null);
    final asStream = memo(() => future?.asStream(), [future]);

    effect(
      () {
        setValue(
          asStream == null ? null : AsyncLoading(getValue()?.data ?? None<T>()),
        );

        final subscription = asStream?.listen(
          (data) {
            setValue(AsyncData(data));
            rebuild();
          },
          onError: (Object error, StackTrace trace) {
            setValue(
              AsyncError(error, trace, getValue()?.data ?? None<T>()),
            );
            rebuild();
          },
        );

        return () => subscription?.cancel();
      },
      [asStream],
    );

    return (
      state: getValue(),
      mutate: setFuture,
      clear: () => setFuture(null),
    );
  }
}

/// Checks to see whether [newDeps] has changed from [oldDeps]
/// using a deep-ish equality check (compares `==` amongst [List] children).
bool _didDepsListChange(List<Object?> newDeps, List<Object?>? oldDeps) {
  return oldDeps == null ||
      newDeps.length != oldDeps.length ||
      Iterable<int>.generate(newDeps.length)
          .any((i) => newDeps[i] != oldDeps[i]);
}

/// A reducer [Function] that consumes some [State] and [Action] and returns
/// a new, transformed [State].
typedef Reducer<State, Action> = State Function(State, Action);

/// Represents a mutation, with:
/// - `state`, the current [AsyncValue]? state of the mutation
/// (will be null when the mutation is inactive/cleared)
/// - `mutate`, a [Function] that triggers the mutation
/// - `clear`, a [Function] that stops and clears the mutation
typedef Mutation<T> = ({
  AsyncValue<T>? state,
  void Function(Future<T> mutater) mutate,
  void Function() clear,
});
