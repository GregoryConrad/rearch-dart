import 'package:rearch/rearch.dart';

/// A collection of builtin side effects.
extension BuiltinSideEffects on SideEffectRegistrar {
  /// Convenience side effect that gives a copy of the [SideEffectApi].
  SideEffectApi api() => register((api) => api);

  /// Convenience side effect that gives a copy of [SideEffectApi.rebuild].
  void Function() rebuilder() => api().rebuild;

  /// Side effect that calls the supplied [callback] once, on the first build.
  T callonce<T>(T Function() callback) => register((_) => callback());

  /// Side effect that provides a way for capsules to contain some state,
  /// where the initial state is computationally expensive.
  /// Similar to the `useState` hook from React;
  /// see https://react.dev/reference/react/useState
  (T, void Function(T)) lazyState<T>(T Function() init) {
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

  // TODO(GregoryConrad): other side effects
}
