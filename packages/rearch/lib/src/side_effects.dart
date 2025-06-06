import 'dart:async';

import 'package:rearch/rearch.dart';

extension _UseConvenience on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
}

/// A collection of builtin side effects.
extension BuiltinSideEffects on SideEffectRegistrar {
  /// Declares the associated capsule as a non-idempotent listener.
  void asListener() => use.register((_) {});

  /// Convenience side effect that gives a copy of the [SideEffectApi].
  SideEffectApi api() => use.register((api) => api);

  /// Convenience side effect that gives a copy of [SideEffectApi.rebuild].
  void Function([
    void Function(void Function() cancelRebuild)? sideEffectMutation,
  ]) rebuilder() => use.api().rebuild;

  /// Convenience side effect that gives a copy of
  /// [SideEffectApi.runTransaction].
  void Function(void Function()) transactionRunner() =>
      use.api().runTransaction;

  /// Side effect that calls the supplied [callback] once, on the first build.
  T callonce<T>(T Function() callback) => use.register((_) => callback());

  /// Keeps track of some data that can be stateful.
  /// You may set the value of returned [ValueWrapper] both:
  /// 1. Outside of the build, like a normal call to `setState`
  /// 2. Inside of the build, to use its value inside build
  ///
  /// This is a more powerful alternative to [state].
  ValueWrapper<T> data<T>(T initial) => use.lazyData(() => initial);

  /// Keeps track of some data that can be stateful.
  /// You may set the value of returned [ValueWrapper] both:
  /// 1. Outside of the build, like a normal call to `setState`
  /// 2. Inside of the build, to use its value inside build
  ///
  /// This is a more powerful alternative to [lazyState].
  ValueWrapper<T> lazyData<T>(T Function() init) {
    // Create a place to store the data, which should be lazily initialized
    final dataWrapper = use.callonce(() => _LazyMutable(init));

    // Create a getter on first build, but allow it to be changed
    final getterWrapper = use.callonce(() {
      return _Mutable(() => dataWrapper.value);
    });

    // Keep the same setter between builds to prevent unnecessary rebuilds
    final setter = use.register((api) {
      return (T newState) {
        api.rebuild((_) => dataWrapper.value = newState);
      };
    });

    // If the data has changed, then we need to recreate the getter
    // NOTE: https://github.com/GregoryConrad/rearch-dart/issues/277
    final lastSeenDataWrapper = use.callonce(() {
      // NOTE: We want to compare against something that definitely isn't equal
      // the first time the state has been mutated.
      // Thus, we use a private const object (const _Nothing()),
      // since that is guaranteed to be equal to nothing else.
      return _Mutable<Object?>(const _Nothing());
    });
    final hasDataChanged = dataWrapper.hasBeenMutated &&
        dataWrapper.value != lastSeenDataWrapper.value;
    if (hasDataChanged) {
      getterWrapper.value = () => dataWrapper.value;
      lastSeenDataWrapper.value = dataWrapper.value;
    }

    return (getterWrapper.value, setter);
  }

  /// Side effect that provides a way for capsules to contain some state,
  /// where the initial state is computationally expensive.
  /// Further, instead of returning the state directly, this instead returns
  /// a getter that is safe to capture in closures.
  ///
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  ///
  /// # NOTE
  /// New applications are recommended to use [lazyData] instead.
  @Deprecated('Use `use.lazyData` instead')
  ValueWrapper<T> lazyStateGetterSetter<T>(T Function() init) =>
      use.lazyData(init);

  /// Side effect that provides a way for capsules to contain some state.
  /// Further, instead of returning the state directly, this instead returns
  /// a getter that is safe to capture in closures.
  ///
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  ///
  /// # NOTE
  /// New applications are recommended to use [data] instead.
  @Deprecated('Use `use.data` instead')
  ValueWrapper<T> stateGetterSetter<T>(T initial) => use.data(initial);

  /// Side effect that provides a way for capsules to contain some state,
  /// where the initial state is computationally expensive.
  ///
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  ///
  /// # NOTE
  /// While [lazyState] will continue to work just fine,
  /// it is recommended that newer applications also take a look at [lazyData].
  (T, void Function(T)) lazyState<T>(T Function() init) {
    final (getter, setter) = use.lazyData(init);
    return (getter(), setter);
  }

  /// Side effect that provides a way for capsules to contain some state.
  ///
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  ///
  /// # NOTE
  /// While [state] will continue to work just fine,
  /// it is recommended that newer applications also take a look at [data].
  (T, void Function(T)) state<T>(T initial) => use.lazyState(() => initial);

  /// Side effect that provides a way for capsules to hold onto some value
  /// between builds, where the initial value is computationally expensive.
  ///
  /// Similar to the `useRef` hook from React;
  /// see https://react.dev/reference/react/useRef
  T lazyValue<T>(T Function() init) => use.callonce(init);

  /// Side effect that provides a way for capsules to hold onto some value
  /// between builds.
  ///
  /// Similar to the `useRef` hook from React;
  /// see https://react.dev/reference/react/useRef
  T value<T>(T initial) => use.lazyValue(() => initial);

  /// Returns the previous value passed into [previous],
  /// or `null` on first build.
  T? previous<T>(T current) {
    final (getter, setter) = use.data<T?>(null);
    final prev = getter();
    setter(current);
    return prev;
  }

  /// Returns true on the first build and false on subsequent builds.
  ///
  /// Useful for a capsule wishing to read its own current data,
  /// as capsules cannot read their own data on their first build
  /// (as it won't exist yet).
  bool isFirstBuild() => use.previous(false) ?? true;

  /// Equivalent to the `useMemo` hook from React.
  /// See https://react.dev/reference/react/useMemo
  T memo<T>(T Function() memo, [List<Object?> dependencies = const []]) {
    final oldDependencies = use.previous(dependencies);
    final (getData, setData) = use.lazyData<T>(
      () => throw StateError('Should be manually set before get'),
    );
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
    final oldDependencies = use.previous(dependencies);
    final (getDispose, setDispose) = use.data<void Function()?>(null);
    use.register((api) => api.registerDispose(() => getDispose()?.call()));

    if (dependencies == null ||
        _didDepsListChange(dependencies, oldDependencies)) {
      getDispose()?.call();
      setDispose(effect());
    }
  }

  /// A shortcut over [memo] and [effect] to handle disposable objects.
  /// Specifically, this:
  /// 1. Creates some value via [init]
  /// 2. Automatically recreates that value whenever [dependencies] change
  /// 3. Automatically dispose all outdated values via [dispose]
  ///
  /// Not specify dependencies will only create the value once.
  T disposable<T>(
    T Function() init,
    void Function(T) dispose, [
    List<Object?> dependencies = const [],
  ]) {
    final value = use.memo(init, dependencies);
    use.effect(() => () => dispose(value), [value]);
    return value;
  }

  /// A simple implementation of the reducer pattern as a side effect.
  ///
  /// The React docs do a great job of explaining the reducer pattern more.
  /// See https://react.dev/reference/react/useReducer
  (State, void Function(Action)) reducer<State, Action>(
    Reducer<State, Action> reducer,
    State initialState,
  ) {
    final (currState, setState) = use.state(initialState);
    return (
      currState,
      (action) => setState(reducer(currState, action)),
    );
  }

  /// Provides a way to keep track of some state while also providing
  /// "undo" and "redo" operations. This side effect is analogous to the
  /// replay bloc library, if you have heard of it.
  ///
  /// The returned state defaults to null and is accompanied by a function
  /// that sets the current state.
  /// The returned `undo` and `redo` [Function]s will both be null if
  /// there are no states available to undo and redo, respectively.
  (
    T?,
    void Function(T), {
    void Function()? undo,
    void Function()? redo,
  }) replay<T>() {
    final undoStack = use.value(<T>[]);
    final redoStack = use.value(<T>[]);
    final rebuild = use.rebuilder();

    return (
      undoStack.lastOrNull,
      (newState) => rebuild((cancelRebuild) {
            if (undoStack.isNotEmpty && newState == undoStack.last) {
              cancelRebuild();
              return;
            }

            redoStack.clear();
            undoStack.add(newState);
          }),
      undo: undoStack.isEmpty
          ? null
          : () => rebuild((_) => redoStack.add(undoStack.removeLast())),
      redo: redoStack.isEmpty
          ? null
          : () => rebuild((_) => undoStack.add(redoStack.removeLast())),
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
  AsyncValue<T> future<T>(Future<T> future) => use.nullableFuture(future)!;

  /// Consumes a [Stream] and watches the given [stream].
  ///
  /// If the given stream changes between build calls, then the current
  /// [StreamSubscription] will be disposed and recreated for the new stream.
  /// Thus, it is important that the stream instance only changes when needed.
  /// It is incorrect to create a stream in the same build as the [stream],
  /// unless you use something like [memo] to limit changes.
  /// Or, if possible, it is even better to wrap the stream in an entirely
  /// new capsule (although this is not always possible).
  AsyncValue<T> stream<T>(Stream<T> stream) => use.nullableStream(stream)!;

  /// Consumes a nullable [Future] and watches the given [future].
  ///
  /// Implemented by calling [Future.asStream] and forwarding calls
  /// onto [nullableStream].
  ///
  /// If the given future changes, then the current [StreamSubscription]
  /// will be disposed and recreated for the new future.
  /// Thus, it is important that the future instance only changes when needed.
  /// It is incorrect to create a future in the same build as the [future],
  /// unless you use something like [memo] to limit changes.
  /// Or, if possible, it is even better to wrap the future in an entirely
  /// new capsule (although this is not always possible).
  ///
  /// This side effect also caches the data from the latest non-null [future],
  /// passing it into [AsyncLoading.previousData] when the future switches and
  /// [AsyncError.previousData] when a new future throws an exception.
  /// To remove this cached data from the returned [AsyncValue],
  /// you may call [AsyncValueConvenience.withoutPreviousData].
  AsyncValue<T>? nullableFuture<T>(Future<T>? future) {
    // NOTE: we convert to a stream here to reuse our cancellation code.
    final asNullableStream = use.memo(() => future?.asStream(), [future]);
    return use.nullableStream(asNullableStream);
  }

  /// Consumes a nullable [Stream] and watches the given [stream].
  ///
  /// If the given stream changes between build calls, then the current
  /// [StreamSubscription] will be disposed and recreated for the new stream.
  /// Thus, it is important that the stream instance only changes when needed.
  /// It is incorrect to create a stream in the same build as the [stream],
  /// unless you use something like [memo] to limit changes.
  /// Or, if possible, it is even better to wrap the stream in an entirely
  /// new capsule (although this is not always possible).
  ///
  /// This side effect also caches the data from the latest non-null [stream],
  /// passing it into [AsyncLoading.previousData] when the stream switches and
  /// [AsyncError.previousData] when a new stream emits an exception.
  /// To remove this cached data from the returned [AsyncValue],
  /// you may call [AsyncValueConvenience.withoutPreviousData].
  AsyncValue<T>? nullableStream<T>(Stream<T>? stream) {
    final (getValue, setValue) = use.data<AsyncValue<T>>(
      AsyncLoading<T>(None<T>()),
    );

    use.effect(
      () {
        setValue(AsyncLoading(getValue().data));

        final subscription = stream?.listen(
          (data) => setValue(AsyncData(data)),
          onError: (Object error, StackTrace trace) =>
              setValue(AsyncError(error, trace, getValue().data)),
          cancelOnError: false,
        );
        return () => subscription?.cancel();
      },
      [stream],
    );

    return stream == null ? null : getValue();
  }

  /// A mechanism to persist changes made in state that manages its own state.
  /// See the docs for usage information.
  ///
  /// Defines a way to interact with a storage provider of your choice
  /// through the [read] and [write] parameters.
  ///
  /// [read] is only called once; it is assumed that if [write] is successful,
  /// then calling [read] again would reflect the new state that we already
  /// have access to. Thus, calling [read] again is skipped as an optimization.
  ///
  /// See also: [hydrate], which will compose more nicely with side effects
  /// that manage their own state by simply persisting their state.
  /// [persist] acts like a [state] assembled with [hydrate].
  (AsyncValue<T>, void Function(T)) persist<T>({
    required Future<T> Function() read,
    required Future<void> Function(T) write,
  }) {
    final readFuture = use.callonce(read);
    final readState = use.future(readFuture);
    final (state: writeState, :mutate, clear: _) = use.mutation<T>();

    final state = (writeState ?? readState).fillInPreviousData(readState.data);

    void persist(T data) {
      mutate(() async {
        await write(data);
        return data;
      }());
    }

    return (state, persist);
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
  AsyncValue<T> hydrate<T>(
    T? newData, {
    required Future<T> Function() read,
    required Future<void> Function(T) write,
  }) {
    final readFuture = use.callonce(read);
    final readState = use.future(readFuture);
    final (getPrevData, setPrevData) = use.data<T?>(null);
    final (getWriteFuture, setWriteFuture) = use.data<Future<T>?>(null);

    if (newData != null && newData != getPrevData()) {
      setPrevData(newData);
      setWriteFuture(() async {
        await write(newData);
        return newData;
      }());
    }

    final writeState = use.nullableFuture(getWriteFuture());
    return (writeState ?? readState).fillInPreviousData(readState.data);
  }

  /// Allows you to trigger and watch [Future]s
  /// (called mutations, since they often mutate some state)
  /// from within the build function.
  /// See the documentation for more.
  ///
  /// Note: `mutate()` and `clear()` *should not* be called directly from
  /// within build, but rather from within some callback.
  Mutation<T> mutation<T>() {
    final (getValue, setValue) = use.data<AsyncValue<T>?>(null);

    // NOTE: we convert to a stream here because we can cancel
    // a stream subscription; there is no builtin way to cancel a future.
    final (future, setFuture) = use.state<Future<T>?>(null);
    final asStream = use.memo(() => future?.asStream(), [future]);

    use.effect(
      () {
        setValue(
          asStream == null ? null : AsyncLoading(getValue()?.data ?? None<T>()),
        );

        final subscription = asStream?.listen(
          (data) => setValue(AsyncData(data)),
          onError: (Object error, StackTrace trace) => setValue(
            AsyncError(error, trace, getValue()?.data ?? None<T>()),
          ),
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

  /// A side effect that allows you to watch a future that can be refreshed
  /// by invoking the supplied callback
  /// (which will also give you an updated copy of that future).
  ///
  /// You supply a [futureFactory], which is a function that must
  /// return a new instance of a future to be watched.
  ///
  /// See also [invalidatableFuture], which enables lazy future invalidation.
  ///
  /// Internally creates the future to watch on the first build
  /// and then again whenever the returned callback is invoked.
  (AsyncValue<T>, Future<T> Function()) refreshableFuture<T>(
    Future<T> Function() futureFactory,
  ) {
    final future = use.lazyData(futureFactory);
    final futureState = use.future(future.value);
    return (futureState, () => future.value = futureFactory());
  }

  /// A side effect that allows you to watch a future lazily
  /// (by invoking the first callback)
  /// that can be invalidated lazily (by invoking the second callback).
  ///
  /// You supply a [futureFactory], which is a function that must
  /// return a new instance of a future to be watched.
  ///
  /// See also [refreshableFuture], which eagerly refreshes futures.
  ///
  /// Note: this returns an `AsyncValue<T> Function()` because returning a
  /// function enables this side effect to determine whether or not there is any
  /// demand for the future itself, enabling it to be evaluated lazily.
  (AsyncValue<T> Function(), void Function()) invalidatableFuture<T>(
    Future<T> Function() futureFactory,
  ) {
    final runTxn = use.transactionRunner();
    final (getAsyncState, setAsyncState) =
        use.data<AsyncValue<T>>(AsyncLoading<T>(None<T>()));
    final (getFutureCancel, setFutureCancel) = use.data<void Function()?>(null);
    use.register((api) => api.registerDispose(() => getFutureCancel()?.call()));

    return (
      () {
        if (getFutureCancel() == null) {
          setAsyncState(AsyncLoading<T>(getAsyncState().data));
          final subscription = futureFactory().asStream().listen(
                (data) => setAsyncState(AsyncData(data)),
                onError: (Object error, StackTrace trace) => setAsyncState(
                  AsyncError(error, trace, getAsyncState().data),
                ),
              );
          setFutureCancel(subscription.cancel);
        }

        return getAsyncState();
      },
      () {
        runTxn(() {
          getFutureCancel()?.call();
          setFutureCancel(null);
        });
      },
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

/// Purpose-driven mutable lazy wrapper
final class _LazyMutable<T> {
  _LazyMutable(this._init);

  final T Function() _init;
  late T _value = _init();

  bool hasBeenMutated = false;

  T get value => _value;
  set value(T newValue) {
    _value = newValue;
    hasBeenMutated = true;
  }
}

/// A poor man's interior mutability wrapper
final class _Mutable<T> {
  _Mutable(this.value);
  T value;
}

/// Used to make a `const _Nothing()`, which is equal to nothing else.
final class _Nothing {
  const _Nothing();
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

/// A wrapper around some value that is accessed via a getter + setter.
typedef ValueWrapper<T> = (T Function(), void Function(T));

/// Adds a [value] getter + setter on a [ValueWrapper].
extension ValueWrapperProperty<T> on ValueWrapper<T> {
  /// Gets the underlying value using the [ValueWrapper]'s getter.
  T get value => $1();

  /// Sets the underlying value to [newValue] using the [ValueWrapper]'s setter.
  set value(T newValue) => $2(newValue);
}
