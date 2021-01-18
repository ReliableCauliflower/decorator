import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:decorator_annotation/decorator_annotation.dart';
import 'package:source_gen/source_gen.dart';

class DecoratorVisitor extends SimpleElementVisitor {
  final _decoratorChecker = const TypeChecker.fromRuntime(Decorator);

  final Map<MethodElement, DartObject> decoratedMethods = {};

  @override
  visitMethodElement(MethodElement element) {
    if (_decoratorChecker.hasAnnotationOfExact(element)) {
      decoratedMethods[element] =
          _decoratorChecker.firstAnnotationOfExact(element);
    }
  }
}
