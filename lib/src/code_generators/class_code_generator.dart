import 'package:analyzer/dart/element/element.dart';
import 'package:decorator_annotation/decorator_annotation.dart';
import 'package:decorator/src/code_generators/method_code_generator.dart';
import 'package:decorator/src/decorator_visitor.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:source_gen/source_gen.dart';

class ClassCodeGenerator {
  static String generate(ClassElement classElement) {
    final String className = classElement.displayName;
    if (className.substring(0, 2) != '_\$' || !classElement.isAbstract) {
      return null;
    }
    final String generatedClassName = className.substring(2);

    final decoratedMethodsVisitor = DecoratorVisitor();
    classElement.visitChildren(decoratedMethodsVisitor);

    final _classDecoratorChecker =
        const TypeChecker.fromRuntime(DecoratorClass);

    final DartObject classAnnotation =
        _classDecoratorChecker.firstAnnotationOfExact(classElement);

    String methodsString = '';
    final Map<MethodElement, DartObject> decoratedMethods =
        decoratedMethodsVisitor.decoratedMethods;
    for (final entry in decoratedMethods.entries) {
      methodsString += MethodCodeGenerator.generate(entry, classAnnotation);
    }

    return '''
      class $generatedClassName extends $className {
          $methodsString
      }
    ''';
  }
}
