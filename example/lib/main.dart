import 'package:flutter/material.dart';

import 'services/dummy_service.dart';

void main() {
  final DummyService dummyService = DummyService();
  dummyService.performRequest();
  dummyService.performRequest1();
  dummyService.performRequest2();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(),
    );
  }
}
