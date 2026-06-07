/// A collection of ReArch experiments in case you like exploring the unknown.
///
/// Nothing here is officially supported;
/// items may come and go or experience breaking changes on any new release.
/// Further, items here may be untested so use at your own risk!
@experimental
library;

import 'package:meta/meta.dart';
import 'package:rearch/rearch.dart';
import 'package:rearch/src/node.dart';

extension _UseConvenience on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
}

/// A collection of experimental side effects to
/// complement the [BuiltinSideEffects].
extension ExperimentalSideEffects on SideEffectRegistrar {
  /// Allows you to more easily construct _dynamic_ capsules.
  ///
  /// Dynamic capsules are in contrast to _static_ capsules,
  /// which you can think of as just regular capsules
  /// ("static" because there is only ever one
  /// instantiation per [CapsuleContainer]).
  ///
  /// Dynamic capsules allow you to create a parameterized capsule;
  /// i.e., a capsule that also takes in some argument when built.
  /// To pass in more than one argument, use a record as the argument.
  ///
  /// # Warning
  /// > Dynamic capsule arguments must correctly implement [hashCode] and [==].
  ///
  /// Internally, this side effect is essentially just a [Map] wrapper.
  ///
  /// # Warning
  /// > Dynamic capsules are often not what you need.
  ///
  /// Typically, you should use factories and/or scoped state instead.
  ///
  /// The valid uses for dynamic capsules are:
  /// - Incremental computation
  /// - Dynamic programming/recursive capsules
  /// - Exceptionally odd one-offs (often better solved via a refactor)
  ///
  /// If what you are trying to do doesn't fit into one of the above categories,
  /// do _not_ use [dynamic]. Instead, write your code in a different way.
  DynamicOrchestrator<Param, Return> dynamic<Param, Return>(
    Return Function(
      CapsuleHandle,
      Param,
      // Manual disposal is restricted:
      // - It is only allowed when there are no dependents.
      // - It is not allowed during any ongoing capsule build.
      void Function() disposeSelf,
    )
    dyn,
    void Function(Param) onDispose,
  ) {
    return use.lazyValue(
      () => DynamicOrchestrator._(dyn, onDispose: onDispose),
    );
  }
}

/// Orchestrates a set of dynamic capsules.
/// See [ExperimentalSideEffects.dynamic] for more.
///
/// There is currently no publicly available API on this class;
/// instead, use [DynamicCapsuleAccess] to read a dynamic capsule.
final class DynamicOrchestrator<Param, Return> {
  DynamicOrchestrator._(this._dyn, {void Function(Param)? onDispose})
    : _onDispose = onDispose;
  final Return Function(
    CapsuleHandle,
    Param,
    void Function() disposeSelf,
  )
  _dyn;
  final void Function(Param)? _onDispose;
  final Map<Param, Capsule<Return>> _capsules = {};
  final Map<Param, DataflowGraphNode> _nodes = {};
  final Set<Param> _didCallOnDispose = {};

  Capsule<Return> _get(Param param) {
    return _capsules.putIfAbsent(param, () {
      return (CapsuleHandle handle) {
        final api = handle.api();
        final node = api as DataflowGraphNode;

        handle.callonce(() {
          _didCallOnDispose.remove(param);
          _nodes[param] = node;
          api.registerDispose(() => _finalizeDisposed(param));
        });

        void disposeSelf() {
          if (!dispose(param)) {
            throw DynamicCapsuleDisposeBlockedError(param);
          }
        }

        return _dyn(handle, param, disposeSelf);
      };
    });
  }

  /// Attempts to manually dispose the dynamic capsule at [param].
  ///
  /// Returns true when disposal succeeds (or the capsule was already absent),
  /// and false when disposal is blocked by existing dependents.
  bool dispose(Param param) {
    final capsule = _capsules[param];
    if (capsule == null) return true;

    final node = _nodes[param];
    if (node != null) {
      final didDispose = node.disposeIfNoDependents();
      if (!didDispose) return false;
    }

    _finalizeDisposed(param);
    return true;
  }

  void _finalizeDisposed(Param param) {
    _evictParam(param);
    if (_didCallOnDispose.contains(param)) return;
    _didCallOnDispose.add(param);
    _onDispose?.call(param);
  }

  void _evictParam(Param param) {
    _capsules.remove(param);
    _nodes.remove(param);
  }
}

/// Thrown when a dynamic capsule manual disposal is blocked by dependents.
final class DynamicCapsuleDisposeBlockedError<Param> extends Error {
  /// Creates a blocked-disposal error for [param].
  DynamicCapsuleDisposeBlockedError(this.param);

  /// The dynamic capsule parameter that failed to dispose.
  final Param param;

  @override
  String toString() {
    return 'DynamicCapsuleDisposeBlockedError: cannot manually dispose '
        'dynamic capsule with param $param while it still has dependents';
  }
}

/// Shorthand for dynamic capsules,
/// which are [Capsule]s whose data are [DynamicOrchestrator]s.
typedef DynamicCapsule<Param, Return> =
    Capsule<DynamicOrchestrator<Param, Return>>;

/// Allows you to read dynamic capsules.
///
/// Example:
/// ```dart
/// use(myDynamicCapsule[123]);
/// ```
extension DynamicCapsuleAccess<Param, Return> on DynamicCapsule<Param, Return> {
  /// Allows you to read dynamic capsules.
  ///
  /// Example:
  /// ```dart
  /// use(myDynamicCapsule[123]);
  /// ```
  Capsule<Return> operator [](Param p) {
    return (CapsuleReader use) => use(use(this)._get(p));
  }
}

/// This is public so that you may define your own extensions on [capsule].
typedef CapsuleCreationConvenience = Capsule<T> Function<T>(Capsule<T>);

/// Provides [dynamic].
extension DynamicCapsuleCreationConvenience on CapsuleCreationConvenience {
  /// Shorthand for a fully formed dynamic capsule.
  /// See [ExperimentalSideEffects.dynamic] for more.
  ///
  /// Basic usage:
  /// ```dart
  /// final myDynamicCapsule = capsule.dynamic((use, Foo foo) {
  ///   return use(barCapsule).useFoo(foo);
  /// });
  /// ```
  ///
  /// # Warning
  /// Due to limitations in Dart's type system,
  /// if you wish to use the created capsule recursively,
  /// you will need to explicitly write the return type like so:
  /// ```dart
  /// final DynamicCapsule<int, BigInt> fibonacciCapsule =
  ///     capsule.dynamic((use, int n) {
  ///   return switch (n) {
  ///     _ when n < 0 => throw ArgumentError.value(n),
  ///     0 => BigInt.zero,
  ///     1 => BigInt.one,
  ///     _ => use(fibonacciCapsule[n - 1]) + use(fibonacciCapsule[n - 2]),
  ///   };
  /// });
  /// ```
  /// NOTE: I'd recommend specifying the return type under all situations
  /// regardless, as it'll increase code reability.
  DynamicCapsule<Param, Return> dynamic<Param, Return>(
    Return Function(
      CapsuleHandle,
      Param,
      void Function() disposeSelf,
    )
    dyn,
    void Function(Param) onDispose,
  ) {
    return (CapsuleHandle use) => use.dynamic(dyn, onDispose);
  }
}

/// Provides [updateWith].
extension ValueWrapperUpdateWith<T> on ValueWrapper<T> {
  /// Updates the current [ValueWrapperProperty.value]
  /// with the result of calling [mutater] on it.
  ///
  /// This can make it easier to update states using their `copyWith` methods:
  /// ```dart
  /// final myDataManager = capsule((use) => use.data(MyData()));
  /// // ...
  /// use(myDataManager).updateWith((data) => data.copyWith(foo: bar));
  /// ```
  /// NOTE: this is experimental because I think a future macro that generates a
  /// dedicated `updateWith` for each type of `ValueWrapper<T>` could be nice.
  void updateWith(T Function(T) mutater) => value = mutater(value);
}
