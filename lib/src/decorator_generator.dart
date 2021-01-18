import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:decorator/src/code_generators/class_code_generator.dart';
import 'package:source_gen/source_gen.dart';

import 'package:decorator_annotation/decorator_annotation.dart';

class DecoratorGenerator extends GeneratorForAnnotation<DecoratorClass> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    return ClassCodeGenerator.generate(element as ClassElement);
  }
}
