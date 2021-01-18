import 'package:build/build.dart';
import 'package:decorator/src/decorator_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder decoratorBuilder(BuilderOptions options) =>
    SharedPartBuilder([DecoratorGenerator()], 'decorator');
