// ignore_for_file: public_member_api_docs, implementation_imports
import 'package:_fe_analyzer_shared/src/macros/api.dart';

// /// Creates a new [RearchConsumer] that delegates its [RearchConsumer.build]
// /// to the annotated function.
// const rearchWidget = _RearchWidget();

// TODO(GregoryConrad): transfer doc comments
// TODO(GregoryConrad): add better type checking/assertions, see:
//   https://github.com/dart-lang/language/issues/3606

macro class RearchWidget implements FunctionDeclarationsMacro {
  const RearchWidget();

  @override
  Future<void> buildDeclarationsForFunction(
    FunctionDeclaration function,
    DeclarationBuilder builder,
  ) async {
    final data = _RearchWidgetFunctionMacroData(function, builder);

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

    final canBeStatelessWidget = !data.positParams
        .followedBy(data.namedParams)
        .any(data.isParamWidgetHandle);

    final constructorParams = [
      for (final param in data.externalPositParams) 'this.${param.code.name!},',
      '{',
      for (final param in data.externalNamedParams)
        if (param.isRequired)
          'required this.${param.code.name!},'
        else ...[
          'this.${param.code.name!} = ',
          param.code.defaultValue ?? 'null',
          ',',
        ],
      'super.key,',
      '}',
    ];

    final widgetCode = [
      ...[
        'class ',
        data.widgetName,
        if (data.typeParams.isNotEmpty) ...data.typeParamsParamCode,
        ' extends ',
        if (canBeStatelessWidget) 'StatelessWidget' else 'RearchConsumer',
        ' {',
      ],
      ...['const ', data.widgetName, '(', ...constructorParams, ');'],
      ...data.classFields,
      ...[
        'Widget',
        ' build(',
        ...[
          ...['BuildContext', ' ', data.contextName, ', '],
          if (!canBeStatelessWidget) ...['WidgetHandle', ' ', data.useName],
        ],
        ') => ',
        ...[
          data.functionName,
          if (data.typeParams.isNotEmpty) ...data.typeParamsArgCode,
          '(',
          data.functionArgs,
          ');',
        ],
      ],
      '}',
    ];
    builder.declareInLibrary(DeclarationCode.fromParts(widgetCode));
  }
}

// TODO(GregoryConrad): perhaps name @rearchScopedData, @rearchScopeWidget
macro class RearchInheritedWidget implements FunctionDeclarationsMacro {
  const RearchInheritedWidget();

  @override
  Future<void> buildDeclarationsForFunction(
    FunctionDeclaration function,
    DeclarationBuilder builder,
  ) async {
    final data = _RearchWidgetFunctionMacroData(function, builder);

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

    final rearchWidgetConstructorParams = [
      for (final param in data.externalPositParams) 'this.${param.code.name!},',
      '{',
      for (final param in data.externalNamedParams)
        if (param.isRequired)
          'required this.${param.code.name!},'
        else ...[
          'this.${param.code.name!} = ',
          param.code.defaultValue ?? 'null',
          ',',
        ],
      'required this.child,',
      'super.key,',
      '}',
    ];

    final inheritedWidgetCode = [
      ...[
        'class ',
        inheritedWidgetName,
        if (data.typeParams.isNotEmpty) ...data.typeParamsParamCode,
        ' extends ',
        'InheritedWidget',
        ' {',
      ],
      ...[
        'const ',
        inheritedWidgetName,
        '(this.',
        dataName,
        ', {required super.child});',
      ],
      ...['final ', data.dataType.code, ' ', dataName, ';'],
      ...[
        // TODO(GregoryConrad): this should return bool not void
        // 'bool',
        'void',
        ' updateShouldNotify(',
        inheritedWidgetName,
        ' oldWidget) => oldWidget.',
        dataName,
        ' != ',
        dataName,
        ';',
      ],
      ...[
        'static ',
        inheritedWidgetName,
        '? _maybeOf(',
        'BuildContext',
        ' context) => ',
        'context.dependOnInheritedWidgetOfExactType<',
        inheritedWidgetName,
        '>();',
      ],
      ...[
        'static ',
        inheritedWidgetName,
        ' _of(',
        'BuildContext',
        ' context) {',
        'final widget = _maybeOf(context);',
        "assert(widget != null, 'No ",
        data.widgetName,
        " found in context');",
        'return widget!;',
        '}',
      ],
      '}',
    ];
    builder.declareInLibrary(DeclarationCode.fromParts(inheritedWidgetCode));

    final rearchWidgetCode = [
      ...[
        'class ',
        data.widgetName,
        if (data.typeParams.isNotEmpty) ...data.typeParamsParamCode,
        ' extends ',
        'RearchConsumer',
        ' {',
      ],
      ...[
        'const ',
        data.widgetName,
        '(',
        ...rearchWidgetConstructorParams,
        ');',
      ],
      ...['final ', 'Widget', ' child;'],
      ...data.classFields,
      ...[
        'Widget',
        ' build(',
        ...[
          'BuildContext',
          ' ',
          data.contextName,
          ', ',
          'WidgetHandle',
          ' ',
          data.useName,
        ],
        ') => ',
        inheritedWidgetName,
        '(',
        data.functionName,
        if (data.typeParams.isNotEmpty) ...data.typeParamsArgCode,
        '(',
        data.functionArgs,
        '),',
        'child: child,',
        ');',
      ],
      ...[
        'static ',
        data.dataType.code.asNullable,
        ' maybeOf(',
        'BuildContext',
        ' context) => ',
        inheritedWidgetName,
        '._maybeOf(context)?.',
        dataName,
        ';',
      ],
      ...[
        'static ',
        data.dataType.code,
        ' of(',
        'BuildContext',
        ' context) => ',
        inheritedWidgetName,
        '._of(context).',
        dataName,
        ';',
      ],
      '}',
    ];
    builder.declareInLibrary(DeclarationCode.fromParts(rearchWidgetCode));
  }
}

class _RearchWidgetFunctionMacroData {
  _RearchWidgetFunctionMacroData(this.function, this.builder);
  late final FunctionDeclaration function;
  late final DeclarationBuilder builder;

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

  bool isParamWidgetHandle(ParameterDeclaration param) =>
      param.type.isA('WidgetHandle');
  bool isParamBuildContext(ParameterDeclaration param) =>
      param.type.isA('BuildContext');
  bool isExternalParam(ParameterDeclaration param) =>
      !isParamWidgetHandle(param) && !isParamBuildContext(param);

  late final externalPositParams = positParams.where(isExternalParam);
  late final externalNamedParams = namedParams.where(isExternalParam);

  late final classFields = externalPositParams
      .followedBy(externalNamedParams)
      .expand((p) => ['final ', p.code.type!, ' ', p.code.name!, ';']);

  String paramToArg(ParameterDeclaration param) {
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
