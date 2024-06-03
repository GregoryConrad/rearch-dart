import 'package:flutter/widgets.dart' as flutter;
import 'package:flutter_rearch/flutter_rearch.dart' as flutter_rearch;
import 'package:macros/macros.dart';

// /// Creates a new [RearchConsumer] that delegates its [RearchConsumer.build]
// /// to the annotated function.
// const rearchWidget = _RearchWidget();

// TODO(GregoryConrad): transfer doc comments
// TODO(GregoryConrad): add better type checking/assertions, see:
//   https://github.com/dart-lang/language/issues/3606

// NOTE: this is still prototype code
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: deprecated_member_use_from_same_package

macro class RearchWidget implements FunctionTypesMacro {
  const RearchWidget();

  @override
  Future<void> buildTypesForFunction(
    FunctionDeclaration function,
    TypeBuilder builder,
  ) async {
    final data = _RearchWidgetFunctionMacroData(function);

    if (!data.dataType.isA('Widget')) {
      return builder.reportError(
        message: 'Only applicable to functions returning `Widget`',
        target: function.returnType.asDiagnosticTarget,
      );
    }

    if (data.firstOptPositParam != null) {
      return builder.reportError(
        message: 'Optional positional parameters are not allowed.\n'
            'This is because optional positional parameters are incompatible '
            'with widgets, which all have a super.key named parameter. '
            '(And named parameters are mutually exclusive '
            'with optional positional parameters.)',
        target: data.firstOptPositParam!.asDiagnosticTarget,
        correctionMessage: 'Make the optional positional parameter an '
            'optional named parameter.',
      );
    }

    final widgetCode = '''
class ${data.widgetName}{{typeParamsParamCode}} extends {{RearchConsumer}} {        
  const ${data.widgetName}(
    ${data.externalPositParams.map((param) => 'this.${param.code.name!},').join()}
    { {{constructorNamedParams}} super.key, }
  );

  {{classFields}}

  {{Widget}} build({{BuildContext}} ${data.contextName}, {{WidgetHandle}} ${data.useName}) =>
    ${data.functionName}{{typeParamsArgCode}}(${data.functionArgs});
}
'''
        .substitute({
          ...await _createDefaultTypeSubstitutions(builder),
          'classFields': data.classFields,
          if (data.typeParams.isNotEmpty) ...{
            'typeParamsParamCode': data.typeParamsParamCode,
            'typeParamsArgCode': data.typeParamsArgCode,
          } else ...{
            'typeParamsParamCode': '',
            'typeParamsArgCode': '',
          },
          'constructorNamedParams': data.externalNamedParams.map((param) {
            if (param.isRequired) {
              return 'required this.${param.code.name!},';
            }
            return [
              'this.${param.code.name!} = ',
              param.code.defaultValue ?? 'null',
              ',',
            ];
          }),
        })
        .flatten()
        .toList()
        .toDeclarationCode();
    builder.declareType(data.widgetName, widgetCode);
  }
}

// TODO(GregoryConrad): perhaps name @rearchScopedData, @rearchScopeWidget
macro class RearchInheritedWidget implements FunctionTypesMacro {
  const RearchInheritedWidget();

  @override
  Future<void> buildTypesForFunction(
    FunctionDeclaration function,
    TypeBuilder builder,
  ) async {
    final data = _RearchWidgetFunctionMacroData(function);

    if (data.firstOptPositParam != null) {
      return builder.reportError(
        message: 'Optional positional parameters are not allowed.\n'
            'This is because optional positional parameters are incompatible '
            'with widgets, which all have a super.key named parameter. '
            '(And named parameters are mutually exclusive '
            'with optional positional parameters.)',
        target: data.firstOptPositParam!.asDiagnosticTarget,
        correctionMessage: 'Make the optional positional parameter an '
            'optional named parameter.',
      );
    }

    final inheritedWidgetName = r'_$' + data.widgetName;
    const dataName = '_data';

    final inheritedWidgetCode = '''
class $inheritedWidgetName{{typeParamsParamCode}} extends {{InheritedWidget}} {
  const $inheritedWidgetName(this.$dataName, {required super.child});

  final {{dataType}} $dataName;

  {{bool}} updateShouldNotify($inheritedWidgetName oldWidget) =>
    oldWidget.$dataName != $dataName;

  static $inheritedWidgetName? _maybeOf({{BuildContext}} context) =>
    context.dependOnInheritedWidgetOfExactType<$inheritedWidgetName>();

  static $inheritedWidgetName _of({{BuildContext}} context) {
    final widget = _maybeOf(context);
    assert(widget != null, 'No "${data.widgetName}" found in context');
    return widget!;
  }
}
'''
        .substitute({
          ...await _createDefaultTypeSubstitutions(builder),
          'dataType': data.dataType.code,
          if (data.typeParams.isNotEmpty) ...{
            'typeParamsParamCode': data.typeParamsParamCode,
            'typeParamsArgCode': data.typeParamsArgCode,
          } else ...{
            'typeParamsParamCode': '',
            'typeParamsArgCode': '',
          },
        })
        .flatten()
        .toList()
        .toDeclarationCode();
    builder.declareType(inheritedWidgetName, inheritedWidgetCode);

    final rearchWidgetCode = '''
class ${data.widgetName}{{typeParamsParamCode}} extends {{RearchConsumer}} {
  const ${data.widgetName}(
    ${data.externalPositParams.map((param) => 'this.${param.code.name!},').join()}
    { {{constructorNamedParams}} required this.child, super.key, }
  );

  final {{Widget}} child;

  {{classFields}}

  {{Widget}} build({{BuildContext}} ${data.contextName}, {{WidgetHandle}} ${data.useName}) =>
    $inheritedWidgetName(
      ${data.functionName}{{typeParamsArgCode}}(${data.functionArgs}),
      child: child,
    );

  static {{nullableDataType}} maybeOf({{BuildContext}} context) =>
    $inheritedWidgetName._maybeOf(context)?.$dataName;

  static {{dataType}} of({{BuildContext}} context) =>
    $inheritedWidgetName._of(context).$dataName;
}
'''
        .substitute({
          ...await _createDefaultTypeSubstitutions(builder),
          'classFields': data.classFields,
          'dataType': data.dataType.code,
          'nullableDataType': data.dataType.code.asNullable,
          if (data.typeParams.isNotEmpty) ...{
            'typeParamsParamCode': data.typeParamsParamCode,
            'typeParamsArgCode': data.typeParamsArgCode,
          } else ...{
            'typeParamsParamCode': '',
            'typeParamsArgCode': '',
          },
          'constructorNamedParams': data.externalNamedParams.map((param) {
            if (param.isRequired) {
              return 'required this.${param.code.name!},';
            }
            return [
              'this.${param.code.name!} = ',
              param.code.defaultValue ?? 'null',
              ',',
            ];
          }),
        })
        .flatten()
        .toList()
        .toDeclarationCode();
    builder.declareType(data.widgetName, rearchWidgetCode);
  }
}

class _RearchWidgetFunctionMacroData {
  _RearchWidgetFunctionMacroData(this.function);
  final FunctionDeclaration function;

  final useName = '__use';
  final contextName = '__context';

  late final dataType = function.returnType;
  late final functionName = function.identifier.name;
  late final widgetName = () {
    final upperCaseCutOff = functionName.lastIndexOf('_') + 2;
    return functionName.substring(0, upperCaseCutOff).toUpperCase() +
        functionName.substring(upperCaseCutOff);
  }();

  late final typeParams = function.typeParameters.map((t) => t.code);
  late final positParams = function.positionalParameters;
  late final namedParams = function.namedParameters;

  // Needed for error reporting purposes
  late final firstOptPositParam =
      positParams.where((p) => !p.isRequired).firstOrNull;

  bool isParamWidgetHandle(FormalParameterDeclaration param) =>
      param.type.isA('WidgetHandle');
  bool isParamBuildContext(FormalParameterDeclaration param) =>
      param.type.isA('BuildContext');
  bool isExternalParam(FormalParameterDeclaration param) =>
      !isParamWidgetHandle(param) && !isParamBuildContext(param);

  late final externalPositParams = positParams.where(isExternalParam);
  late final externalNamedParams = namedParams.where(isExternalParam);

  late final classFields = externalPositParams
      .followedBy(externalNamedParams)
      .expand((p) => ['final ', p.code.type!, ' ', p.code.name!, ';']);

  String paramToArg(FormalParameterDeclaration param) {
    if (isParamWidgetHandle(param)) {
      return useName;
    } else if (isParamBuildContext(param)) {
      return contextName;
    } else {
      return param.code.name!;
    }
  }

  late final functionArgs = () {
    final functionPositArgs = positParams.map(paramToArg);
    final functionNamedArgs =
        namedParams.map((param) => '${param.code.name!}: ${paramToArg(param)}');
    return functionPositArgs.followedBy(functionNamedArgs).join(', ');
  }();

  late final typeParamsParamCode = [
    '<',
    ...(typeParams as Iterable<Object>).intersperse(','),
    '>',
  ];
  late final typeParamsArgCode = [
    '<',
    ...typeParams.map((tp) => tp.name).intersperse(','),
    '>',
  ];
}

Future<Map<String, Identifier>> _createTypeSubstitutions(
  TypePhaseIntrospector resolver,
  Map<String, String> types,
) async {
  return {
    for (final MapEntry(key: type, value: lib) in types.entries)
      // NOTE: there is no alternative right now.
      // ignore: deprecated_member_use
      type: await resolver.resolveIdentifier(Uri.parse(lib), type),
  };
}

Future<Map<String, Identifier>> _createDefaultTypeSubstitutions(
  TypePhaseIntrospector resolver,
) {
  const dartCore = 'dart:core';
  const flutter = 'package:flutter/widgets.dart';
  const flutterRearch = 'package:flutter_rearch/flutter_rearch.dart';

  return _createTypeSubstitutions(resolver, {
    'bool': dartCore,
    'Widget': flutter,
    'BuildContext': flutter,
    'InheritedWidget': flutter,
    'WidgetHandle': flutterRearch,
    'RearchConsumer': flutterRearch,
  });
}

extension _EzTypes on TypeAnnotation {
  String get typeName {
    final NamedTypeAnnotation(
      identifier: Identifier(:name),
      typeArguments: typeArgTypes,
    ) = this as NamedTypeAnnotation;
    final typeArgs = typeArgTypes.map((arg) => arg.typeName).join(', ');
    return '$name${typeArgs.isNotEmpty ? '<$typeArgs>' : ''}';
  }

  @Deprecated('replace with safe API')
  bool isA(String name) => typeName == name;
}

extension _EzReport on Builder {
  void reportError({
    required String message,
    DiagnosticTarget? target,
    String? correctionMessage,
  }) {
    report(
      Diagnostic(
        DiagnosticMessage(message, target: target),
        Severity.error,
        correctionMessage: correctionMessage,
      ),
    );
  }
}

extension _Interspersed<T> on Iterable<T> {
  Iterable<T> intersperse(T toIntersperse) sync* {
    final i = iterator;
    if (i.moveNext()) {
      yield i.current;
    }
    while (i.moveNext()) {
      yield toIntersperse;
      yield i.current;
    }
  }
}

extension _Substitute on String {
  Iterable<Object> substitute(Map<String, Object> substitutes) sync* {
    final regex = RegExp('{{(.*?)}}');
    var lastIndex = 0;
    for (final match in regex.allMatches(this)) {
      yield substring(lastIndex, match.start);
      final key = match.group(1);
      final substitution = substitutes[key] ??
          (() => throw ArgumentError('"$key" was not provided'))();
      yield substitution;
      lastIndex = match.end;
    }
    yield substring(lastIndex);
  }
}

extension _Flatten on Iterable<Object> {
  Iterable<Object> flatten() sync* {
    for (final obj in this) {
      if (obj is Iterable<Object>) {
        yield* obj.flatten();
      } else {
        yield obj;
      }
    }
  }
}

extension _ToDeclarationCode on List<Object> {
  DeclarationCode toDeclarationCode() => DeclarationCode.fromParts(this);
}
