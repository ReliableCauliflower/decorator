import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:decorator_annotation/decorator_annotation.dart';
import 'package:source_gen/source_gen.dart';

class DecoratorVisitor extends SimpleElementVisitor {
  static final decoratorChecker = const TypeChecker.fromRuntime(Decorator);

  final Map<MethodElement, DartObject> decoratedMethods = {};
  final List<MethodElement> notDecoratedMethods = [];

  @override
  visitMethodElement(MethodElement element) {
    if (decoratorChecker.hasAnnotationOfExact(element)) {
      bool ignore = false;
      final DartObject decoratorAnnotation =
          decoratorChecker.firstAnnotationOfExact(element);
      final DartObject ignoreField =
          decoratorAnnotation.getField(ignoreFieldName);
      ignore = ignoreField.isNull ? false : ignoreField.toBoolValue();
      if (!ignore) {
        decoratedMethods[element] = decoratorAnnotation;
      }
    } else {
      notDecoratedMethods.add(element);
    }
  }
}
