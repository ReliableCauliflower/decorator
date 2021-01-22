import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:decorator_annotation/decorator_annotation.dart';
import 'package:decorator/src/utils/type_utils.dart';

class MethodCodeGenerator {
  static String generate({
    MapEntry<MethodElement, DartObject> decoratedMethod,
    MethodElement notDecoratedMethod,
    ClassElement classElement,
  }) {
    final MethodElement method = decoratedMethod?.key ?? notDecoratedMethod;
    final DartObject methodAnnotation = decoratedMethod?.value ??
        TypeUtils.decoratorChecker.firstAnnotationOfExact(method);

    final String methodName = method.name;

    String wrapperName;
    final classAnnotation =
        TypeUtils.decoratorClassChecker.firstAnnotationOfExact(classElement);
    if (methodAnnotation != null) {
      wrapperName = _getAnnotationWrapperName(methodAnnotation);
    }
    if (wrapperName == null) {
      wrapperName = _getAnnotationWrapperName(classAnnotation);
      if (wrapperName == null) {
        print(
          '$methodName method does no have a wrapper function for the '
          'decorator, thus skipped',
        );
        return '';
      }
    }

    final String methodDisplayName =
        method.getDisplayString(withNullability: false);

    Map<String, dynamic> parameters = {};

    DartObject methodParametersObject =
        methodAnnotation?.getField(parametersFieldName);

    DartObject classParametersObject =
        classAnnotation.getField(parametersFieldName);

    parameters.addAll(_getParametersMapFromObject(classParametersObject));
    if (methodParametersObject != null) {
      parameters.addAll(_getParametersMapFromObject(methodParametersObject));
    }

    String parametersString = '';
    if (parameters.isNotEmpty) {
      parametersString =
          ''', $parametersFieldName: ${jsonEncode(parameters)},''';
    }

    final bool isAsync = method.isAsynchronous;
    final bool isStatic = method.isStatic;

    final String asyncString = isAsync ? 'async ' : '';
    final String staticString = isStatic ? 'static' : '';

    final String methodStaticString =
        isStatic ? '${classElement.name}.' : 'super.';

    return '''
      ${isStatic ? '' : '@override'}
      $staticString $methodDisplayName $asyncString{
          return ${isAsync ? 'await ' : ''}
          $wrapperName($methodStaticString$methodName$parametersString);
      }
      ''';
  }

  static String _getAnnotationWrapperName(DartObject annotation) {
    final DartObject wrapperField = annotation.getField(wrapperFieldName);
    if (wrapperField.isNull) {
      return null;
    }
    return wrapperField.toFunctionValue().displayName;
  }

  static Map<String, dynamic> _getParametersMapFromObject(
    DartObject parametersObject,
  ) {
    if (parametersObject.isNull) {
      return {};
    }
    return parametersObject.toMapValue().map(
          (key, value) => MapEntry(
            key.toStringValue(),
            TypeUtils.dartObjectToType(value),
          ),
        );
  }
}
