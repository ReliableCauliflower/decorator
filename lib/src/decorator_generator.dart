import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:decorator/src/templates/class_template.dart';
import 'package:source_gen/source_gen.dart';

import 'package:decorator_annotation/decorator_annotation.dart';

class DecoratorGenerator extends GeneratorForAnnotation<DecoratorClass> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    return ClassTemplate(classElement: element).toString();
  }
}
