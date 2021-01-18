// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dummy_service.dart';

// **************************************************************************
// DecoratorGenerator
// **************************************************************************

class DummyService extends _$DummyService {
  @override
  Future<String> performRequest() async {
    return await timeWrapper(
      super.performRequest,
      parameters: {"className": "DummyService", "methodName": "performRequest"},
    );
  }

  @override
  Future<String> performRequest1() async {
    return await timeWrapper(
      super.performRequest1,
      parameters: {
        "className": "DummyService",
        "methodName": "performRequest1"
      },
    );
  }

  @override
  Future<String> performRequest2() async {
    return await timeWrapper(
      super.performRequest2,
      parameters: {
        "className": "DummyService",
        "methodName": "performRequest2"
      },
    );
  }
}
