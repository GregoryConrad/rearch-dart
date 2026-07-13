/// Experimental ephemeral capsules for ReArch.
///
/// Nothing here is officially supported;
/// items may come and go or experience breaking changes on any new release.
/// Further, items here may be untested so use at your own risk!
@experimental
library;

import 'package:meta/meta.dart';
import 'package:rearch/rearch.dart';

extension _UseConvenience on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
}

/// Builds the value for an ephemeral capsule instance.
typedef EphemeralBuilder<Param, Return> =
    Return Function(EphemeralCapsuleHandle use, Param param);

/// A parameterized ephemeral capsule.
typedef EphemeralCapsule<Param, Return> =
    Capsule<EphemeralOrchestrator<Param, Return>>;

/// A launch predicate for [EphemeralCapsuleReader.readEphemeral].
typedef EphemeralLaunchPredicate = bool Function(int life);

/// Provides ephemeral capsule orchestration as a side effect.
extension EphemeralSideEffects on SideEffectRegistrar {
  /// Allows you to construct parameterized ephemeral capsules.
  ///
  /// Ephemeral capsules are launched explicitly via
  /// [EphemeralCapsuleReader.readEphemeral]. Reading their state never launches
  /// them unless the supplied launch predicate returns true.
  EphemeralOrchestrator<Param, Return> ephemeral<Param, Return>(
    EphemeralBuilder<Param, Return> builder,
  ) {
    return use.register((api) => EphemeralOrchestrator(api, builder));
  }
}

/// This is public so that you may define your own extensions on [capsule].
typedef CapsuleCreationConvenience = Capsule<T> Function<T>(Capsule<T>);

/// Provides [ephemeral].
extension EphemeralCapsuleCreationConvenience on CapsuleCreationConvenience {
  /// Shorthand for a fully formed ephemeral capsule.
  ///
  /// Basic usage:
  /// ```dart
  /// final myEphemeral = capsule.ephemeral((use, id) {
  ///   return MyResource(onDone: use.dispose);
  /// });
  /// ```
  EphemeralCapsule<Param, Return> ephemeral<Param, Return>(
    EphemeralBuilder<Param, Return> builder,
  ) {
    return (CapsuleHandle use) => use.ephemeral(builder);
  }
}

/// Allows you to read and optionally launch ephemeral capsules.
extension EphemeralCapsuleReader on CapsuleReader {
  /// Reads the current ephemeral state for [param].
  ///
  /// If the state is inactive, [launch] is called with the next launch
  /// generation for [param]. Returning true launches the ephemeral instance;
  /// returning false leaves it inactive.
  Ephemeral<Return> readEphemeral<Param, Return>(
    EphemeralCapsule<Param, Return> capsule,
    Param param,
    EphemeralLaunchPredicate launch,
  ) {
    return call(capsule).read(param, launch);
  }
}
