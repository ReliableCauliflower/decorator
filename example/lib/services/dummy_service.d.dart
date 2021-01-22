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
      parameters: {
        "className": "DummyService",
        "methodName": "performRequest1"
      },
    );
  }

  @override
  Future<String> performRequest1() async {
    return await resultWrapper(
      super.performRequest1,
      parameters: {"className": "DummyService"},
    );
  }

  static Future<String> staticRequest() async {
    return await timeWrapper(
      _$DummyService.staticRequest,
      parameters: {"className": "DummyService"},
    );
  }
}
