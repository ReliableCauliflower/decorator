import 'dart:async';

import 'strings.dart';

FutureOr<T> timeWrapper<T>(
  FutureOr<T> Function() body, {
  Map<String, dynamic> parameters,
}) async {
  final start = DateTime.now();

  final T result = await body?.call();

  final end = DateTime.now();

  final String methodName = parameters != null ? parameters[methodNameKey] : '';
  final String className = parameters != null ? parameters[classNameKey] : '';
  print(
    '$className::$methodName method completed in '
    '${end.difference(start).inMilliseconds}ms',
  );

  return result;
}
