import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:decorator_annotation/decorator_annotation.dart';
import 'package:decorator/src/utils/type_utils.dart';

class MethodCodeGenerator {
  static String generate(
    MapEntry<MethodElement, DartObject> decoratedMethod,
    DartObject classAnnotation,
  ) {
    final MethodElement method = decoratedMethod.key;
    final DartObject methodAnnotation = decoratedMethod.value;

    final String methodName = method.name;

    String wrapperName = _getAnnotationWrapperName(methodAnnotation);
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

    final bool isAsync = method.isAsynchronous;

    final String asyncString = isAsync ? 'async ' : '';
    final String methodDisplayName =
        method.getDisplayString(withNullability: false);

    Map<String, dynamic> parameters = {};
    DartObject methodParametersObject =
        methodAnnotation.getField(parametersFieldName);
    DartObject classParametersObject =
        classAnnotation.getField(parametersFieldName);

    parameters.addAll(_getParametersMapFromObject(classParametersObject));
    parameters.addAll(_getParametersMapFromObject(methodParametersObject));

    String parametersString = '';
    if (parameters.isNotEmpty) {
      parametersString =
          ''', $parametersFieldName: ${jsonEncode(parameters)},''';
    }

    return '''
      @override
      $methodDisplayName $asyncString{
          return ${isAsync ? 'await ' : ''}$wrapperName(super.$methodName$parametersString);
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