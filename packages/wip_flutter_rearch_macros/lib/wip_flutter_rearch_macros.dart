// ignore_for_file: public_member_api_docs, implementation_imports
import 'package:_fe_analyzer_shared/src/macros/api.dart';

// /// Creates a new [RearchConsumer] that delegates its [RearchConsumer.build]
// /// to the annotated function.
// const rearchWidget = _RearchWidget();

// TODO(GregoryConrad): make inheritedRearchWidget macro
// TODO(GregoryConrad): add better type checking/assertions with something like:
// final returnType = await builder.resolve(function.returnType.code);
// (function.returnType as NamedTypeAnnotation).identifier;
// builder.typeDeclarationOf();
// returnType.isExactly(StaticType)
// final widget = await builder.typeDeclarationOf(
//   await builder.resolveIdentifier(
//     Uri.parse('package:flutter/widgets.dart'),
//     'Widget',
//   ),
// );
// await builder.resolve(widget);
// TODO(GregoryConrad): widget generics via function.typeParameters
// TODO(GregoryConrad): stless widget optimization
// TODO(GregoryConrad): transfer doc comments
macro class RearchWidget implements FunctionDeclarationsMacro {
  const RearchWidget();

  @override
  Future<void> buildDeclarationsForFunction(
    FunctionDeclaration function,
    DeclarationBuilder builder,
  ) async {
    if (!function.returnType.isA('Widget')) {
      builder.reportError(
        message: 'Only applicable to functions returning `Widget`',
        target: function.returnType.asDiagnosticTarget,
      );
      return;
    }

    final firstOptPosParam =
        function.positionalParameters.where((p) => !p.isRequired).firstOrNull;
    if (firstOptPosParam != null) {
      builder.reportError(
        message: 'Optional positional parameters are not allowed.\n'
            'This is because optional positional parameters are incompatible '
            'with widgets, which all have a super.key named parameter. '
            '(And named parameters are mutually exclusive '
            'with optional positional parameters.)',
        target: firstOptPosParam.asDiagnosticTarget,
        correctionMessage: 'Make the optional positional parameter an '
            'optional named parameter.',
      );
      return;
    }

    final functionName = function.identifier.name;
    final upperCaseCutOff = functionName.lastIndexOf('_') + 2;
    final widgetName =
        functionName.substring(0, upperCaseCutOff).toUpperCase() +
            functionName.substring(upperCaseCutOff);

    final positParams = function.positionalParameters.toList();
    final namedParams = function.namedParameters.toList();

    bool isParamWidgetHandle(ParameterDeclaration param) =>
        param.type.isA('WidgetHandle');
    bool isParamBuildContext(ParameterDeclaration param) =>
        param.type.isA('BuildContext');
    bool isExternalParam(ParameterDeclaration param) =>
        !isParamWidgetHandle(param) && !isParamBuildContext(param);

    final externalPositParams = positParams.where(isExternalParam).toList();
    final externalNamedParams = namedParams.where(isExternalParam).toList();

    final classFields = externalPositParams
        .followedBy(externalNamedParams)
        .map((param) => 'final ${param.type.typeName} ${param.code.name};')
        .join('\n');

    final constructorParams = [
      for (final param in externalPositParams) 'this.${param.code.name},',
      '{',
      for (final param in externalNamedParams)
        if (param.isRequired)
          'required this.${param.code.name},'
        else
          'this.${param.code.name} = ${param.code.defaultValue},',
      'super.key,',
      '}',
    ].join('\n');

    const useName = '__use';
    const contextName = '__context';
    String paramToArg(ParameterDeclaration param) {
      if (isParamWidgetHandle(param)) {
        return useName;
      } else if (isParamBuildContext(param)) {
        return contextName;
      } else {
        return param.code.name.toString();
      }
    }

    final functionPositArgs = positParams.map(paramToArg);
    final functionNamedArgs =
        namedParams.map((param) => '${param.code.name}: ${paramToArg(param)}');
    final functionArgs =
        functionPositArgs.followedBy(functionNamedArgs).join(', ');

    final widgetCode = '''
class $widgetName extends RearchConsumer {
  const $widgetName($constructorParams);
  $classFields
  @override
  Widget build(BuildContext $contextName, WidgetHandle $useName) {
    return $functionName($functionArgs);
  }
}''';
    builder.declareInLibrary(DeclarationCode.fromString(widgetCode));
  }
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
