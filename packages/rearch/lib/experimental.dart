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
  DynamicCapsule<Param, Return> dynamic<Param, Return>(
    Return Function(CapsuleHandle, Param) dyn,
  ) {
    return use.lazyValue(() => _DynamicCapsuleImpl(dyn));
  }
}

final class _DynamicCapsuleImpl<Param, Return>
    implements DynamicCapsule<Param, Return> {
  _DynamicCapsuleImpl(this.dyn);
  final Return Function(CapsuleHandle, Param) dyn;
  final Map<Param, Capsule<Return>> capsules = {};

  @override
  Capsule<Return> _get(param) {
    // TODO(GregoryConrad): remove capsule from map on capsule disposal?
    // That would require a way to register a disposal that keeps idempotence.
    return capsules.putIfAbsent(param, () {
      return (CapsuleHandle handle) {
        return dyn(handle, param);
      };
    });
  }
}

/// Represents a dynamic capsule.
/// See [ExperimentalSideEffects.dynamic] for more.
///
/// There is currently no publicly available API on this interface;
/// instead, use [DynamicCapsuleAccess] to read the dynamic capsule.
// ignore: one_member_abstracts
abstract interface class DynamicCapsule<Param, Return> {
  Capsule<Return> _get(Param param);
}

/// Allows you to read dynamic capsules.
///
/// Example:
/// ```dart
/// use(myDynamicCapsule[123]);
/// ```
extension DynamicCapsuleAccess<Param, Return>
    on Capsule<DynamicCapsule<Param, Return>> {
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

/// Shorthand for a fully formed dynamic capsule.
/// See [ExperimentalSideEffects.dynamic] for more.
///
/// Basic usage:
/// ```dart
/// final myDynamicCapsule = dynamicCapsule((use, Foo foo) {
///   return use(barCapsule).useFoo(foo);
/// });
/// ```
///
/// # Warning
/// Due to limitations in Dart's type system,
/// if you wish to use the created capsule recursively,
/// you will need to explicitly write the return type like so:
/// ```dart
/// final Capsule<DynamicCapsule<int, BigInt>> fibonacciCapsule =
///     dynamicCapsule((use, int n) {
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
Capsule<DynamicCapsule<Param, Return>> dynamicCapsule<Param, Return>(
  Return Function(CapsuleHandle, Param) dyn,
) {
  return (CapsuleHandle use) => use.dynamic(dyn);
}

/// Shorthand for a fully formed capsule.
///
/// Basic usage:
/// ```dart
/// final countPlusOneCapsule = capsule((use) {
///   return use(countCapsule) + 1;
/// });
/// ```
///
/// # Warning
/// Although [capsule] is convenient,
/// source code created with it loses explicitly written type information.
/// For that reason, it is strongly recommended to use [capsule] as such:
/// ```dart
/// final Capsule<int> countPlusOneCapsule = capsule((use) {
///   return use(countCapsule) + 1;
/// });
/// ```
Capsule<T> capsule<T>(Capsule<T> cap) => cap;
