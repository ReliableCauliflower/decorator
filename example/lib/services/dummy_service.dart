import 'package:decorator_annotation/decorator_annotation.dart';

import '../utils/strings.dart';
import '../utils/wrappers.dart';

part 'dummy_service.d.dart';

@DecoratorClass(
  wrapper: timeWrapper,
  parameters: {
    classNameKey: 'DummyService',
  },
)
abstract class _$DummyService {
  @Decorator(
    parameters: {
      methodNameKey: 'performRequest',
    },
  )
  Future<String> performRequest() async {
    return await Future<String>.delayed(
      const Duration(seconds: 3),
      () => 'Method completed',
    );
  }

  @Decorator(
    parameters: {
      methodNameKey: 'performRequest1',
    },
  )
  Future<String> performRequest1() async {
    return await Future<String>.delayed(
      const Duration(seconds: 3),
      () => 'Method completed',
    );
  }

  @Decorator(
    parameters: {
      methodNameKey: 'performRequest2',
    },
  )
  Future<String> performRequest2() async {
    return await Future<String>.delayed(
      const Duration(seconds: 3),
      () => 'Method completed',
    );
  }
}
