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

  static bool isMethodValid(
    MethodElement methodElement,
    DartObject forAllWhereAnyObject,
    DartObject ignoreWhereAnyObject,
  ) {
    if (forAllWhereAnyObject.isNull && ignoreWhereAnyObject.isNull) {
      return true;
    }
    final Set<Set<MethodPredicate>> forAllWhereAny =
        _objectToMethodPredicateSet(forAllWhereAnyObject) ?? {};
    final Set<Set<MethodPredicate>> ignoreWhereAny =
        _objectToMethodPredicateSet(ignoreWhereAnyObject) ?? {};

    for (final predicateSet in forAllWhereAny) {
      if (ignoreWhereAny.contains(predicateSet)) {
        forAllWhereAny.remove(predicateSet);
        ignoreWhereAny.remove(predicateSet);
      }
    }
    bool result = true;
    if (forAllWhereAny.isNotEmpty) {
      result = _methodHasAny(methodElement, forAllWhereAny);
    }
    if (ignoreWhereAny.isNotEmpty) {
      result = result && !_methodHasAny(methodElement, ignoreWhereAny);
    }

    return result;
  }

  static Set<Set<MethodPredicate>> _objectToMethodPredicateSet(
    DartObject setObject,
  ) {
    if (setObject.isNull) {
      return null;
    }
    return setObject
        .toSetValue()
        .map(
          (e) => e.toSetValue().map(
            (DartObject methodPredicateObject) {
              return MethodPredicate
                  .values[methodPredicateObject.getField('index').toIntValue()];
            },
          ).toSet(),
        )
        .toSet();
  }

  static bool _methodHasAny(
    MethodElement methodElement,
    Set<Set<MethodPredicate>> methodPredicates,
  ) {
    for (final predicateSet in methodPredicates) {
      bool hasAll = true;

      for (final predicate in predicateSet) {
        if (!_methodMatchesPredicate(methodElement, predicate)) {
          hasAll = false;
          break;
        }
      }

      if (hasAll) {
        return true;
      }
    }

    return false;
  }

  static bool _methodMatchesPredicate(
    MethodElement methodElement,
    MethodPredicate predicate,
  ) {
    switch (predicate) {
      case MethodPredicate.hasImplicitReturnType:
        return methodElement.hasImplicitReturnType;
      case MethodPredicate.isAbstract:
        return methodElement.isAbstract;
      case MethodPredicate.isSynchronous:
        return methodElement.isSynchronous;
      case MethodPredicate.isAsynchronous:
        return methodElement.isAsynchronous;
      case MethodPredicate.isExternal:
        return methodElement.isExternal;
      case MethodPredicate.isGenerator:
        return methodElement.isGenerator;
      case MethodPredicate.isOperator:
        return methodElement.isOperator;
      case MethodPredicate.isStatic:
        return methodElement.isStatic;
      case MethodPredicate.hasAlwaysThrows:
        return methodElement.hasAlwaysThrows;
      case MethodPredicate.hasDeprecated:
        return methodElement.hasDeprecated;
      case MethodPredicate.hasDoNotStore:
        return methodElement.hasDoNotStore;
      case MethodPredicate.hasFactory:
        return methodElement.hasFactory;
      case MethodPredicate.hasInternal:
        return methodElement.hasInternal;
      case MethodPredicate.hasIsTest:
        return methodElement.hasIsTest;
      case MethodPredicate.hasIsTestGroup:
        return methodElement.hasIsTestGroup;
      case MethodPredicate.hasJS:
        return methodElement.hasJS;
      case MethodPredicate.hasLiteral:
        return methodElement.hasLiteral;
      case MethodPredicate.hasMustCallSuper:
        return methodElement.hasMustCallSuper;
      case MethodPredicate.hasNonVirtual:
        return methodElement.hasNonVirtual;
      case MethodPredicate.hasOptionalTypeArgs:
        return methodElement.hasOptionalTypeArgs;
      case MethodPredicate.hasOverride:
        return methodElement.hasOverride;
      case MethodPredicate.hasProtected:
        return methodElement.hasProtected;
      case MethodPredicate.hasRequired:
        return methodElement.hasRequired;
      case MethodPredicate.hasSealed:
        return methodElement.hasSealed;
      case MethodPredicate.hasVisibleForTemplate:
        return methodElement.hasVisibleForTemplate;
      case MethodPredicate.hasVisibleForTesting:
        return methodElement.hasVisibleForTesting;
      case MethodPredicate.isPrivate:
        return methodElement.isPrivate;
      case MethodPredicate.isPublic:
        return methodElement.isPublic;
    }
    return false;
  }
}
