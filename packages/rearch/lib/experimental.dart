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
}
