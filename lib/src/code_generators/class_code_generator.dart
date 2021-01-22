import 'package:analyzer/dart/element/element.dart';
import 'package:decorator/src/utils/type_utils.dart';
import 'package:decorator_annotation/decorator_annotation.dart';
import 'package:decorator/src/code_generators/method_code_generator.dart';
import 'package:decorator/src/decorator_visitor.dart';
import 'package:analyzer/dart/constant/value.dart';

class ClassCodeGenerator {
  static String generate(ClassElement classElement) {
    final String className = classElement.displayName;
    if (className.substring(0, 2) != '_\$' || !classElement.isAbstract) {
      return null;
    }
    final String generatedClassName = className.substring(2);

    final decoratedMethodsVisitor = DecoratorVisitor();
    classElement.visitChildren(decoratedMethodsVisitor);

    final DartObject classAnnotation =
        TypeUtils.decoratorClassChecker.firstAnnotationOfExact(classElement);

    final Map<MethodElement, DartObject> decoratedMethods =
        decoratedMethodsVisitor.decoratedMethods;

    final List<MethodElement> notDecoratedMethods =
        decoratedMethodsVisitor.notDecoratedMethods;

    final DartObject forAllWhereAnyObject =
        classAnnotation.getField(forAllWhereAnyFieldName);

    final DartObject ignoreWhereAnyObject =
        classAnnotation.getField(ignoreWhereAnyFieldName);

    notDecoratedMethods.removeWhere(
      (methodElement) => !TypeUtils.isMethodValid(
        methodElement,
        forAllWhereAnyObject,
        ignoreWhereAnyObject,
      ),
    );

    if (decoratedMethods.isEmpty && notDecoratedMethods.isEmpty) {
      return null;
    }

    String methodsString = '';
    for (final entry in decoratedMethods.entries) {
      methodsString += MethodCodeGenerator.generate(
        decoratedMethod: entry,
        classElement: classElement,
      );
    }

    for (final method in notDecoratedMethods) {
      methodsString += MethodCodeGenerator.generate(
        notDecoratedMethod: method,
        classElement: classElement,
      );
    }

    return '''
      class $generatedClassName extends $className {
          $methodsString
      }
    ''';
  }
}
