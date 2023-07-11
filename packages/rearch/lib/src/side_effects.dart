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
    return register((api) {
      late T state;
      if (init != null) state = init();
      return (() => state, (T newState) => state = newState);
    });
  }

  /// Side effect that provides a way for capsules to contain some state,
  /// where the initial state is computationally expensive.
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  (T, void Function(T)) lazyState<T>(T Function() init) {
    // We use register directly to keep the same setter function
    // across rebuilds, which actually can help skip certain rebuilds
    final (getter, setter) = register((api) {
      var state = init();

      T getter() => state;
      void setter(T newState) {
        state = newState;
        api.rebuild();
      }

      return (getter, setter);
    });
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

  // TODO(GregoryConrad): other side effects
}

/// Checks to see whether [newDeps] has changed from [oldDeps]
/// using a deep-ish equality check (compares `==` amongst [List] children).
bool _didDepsListChange(List<Object?> newDeps, List<Object?>? oldDeps) {
  return oldDeps == null ||
      newDeps.length != oldDeps.length ||
      Iterable<int>.generate(newDeps.length)
          .any((i) => newDeps[i] != oldDeps[i]);
}
