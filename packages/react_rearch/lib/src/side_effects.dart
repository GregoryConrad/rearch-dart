import 'package:react_rearch/react_rearch.dart';
import 'package:rearch/rearch.dart';

extension _UseConvenience on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
}

/// A collection of the builtin [ComponentSideEffect]s.
extension BuiltinWidgetSideEffects on ComponentSideEffectRegistrar {
  /// The [ComponentSideEffectApi] backing this [ComponentSideEffectRegistrar].
  ComponentSideEffectApi api() => register((api) => api);
}
