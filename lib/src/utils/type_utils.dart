import 'dart:convert';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:decorator_annotation/decorator_annotation.dart';
import 'package:source_gen/source_gen.dart';

class TypeUtils {
  static final decoratorChecker = const TypeChecker.fromRuntime(Decorator);
  static final decoratorClassChecker =
      const TypeChecker.fromRuntime(DecoratorClass);

  static dynamic dartObjectToType(DartObject dartObject) {
    if (dartObject.isNull) {
      return null;
    }
    final type = dartObject.type;

    if (type.isDartCoreString) {
      return dartObject.toStringValue();
    } else if (type.isDartCoreBool) {
      return dartObject.toBoolValue();
    } else if (type.isDartCoreDouble) {
      return dartObject.toDoubleValue();
    } else if (type.isDartCoreInt) {
      return dartObject.toIntValue();
    } else if (type.isDartCoreList || type.isDartCoreIterable) {
      return dartObject.toListValue().map(dartObjectToType).toList();
    } else if (type.isDartCoreMap) {
      return dartObject.toMapValue().map(
            (key, value) => MapEntry(
              dartObjectToType(key),
              dartObjectToType(value),
            ),
          );
    } else if (type.isDartCoreNum) {
      return dartObject.toDoubleValue();
    } else if (type.isDartCoreSet) {
      return dartObject.toSetValue().map(dartObjectToType);
    }
    print('Unsupported parameter type: $type');
    throw JsonUnsupportedObjectError(dartObject.runtimeType);
  }

  static bool validateMethodElement(
    MethodElement methodElement,
    Set<Set<DartObject>> forAllWhereAny,
  ) {
    return true;
  }
}
