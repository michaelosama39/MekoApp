import 'package:flutter/material.dart';
import 'package:meko_app/ImageScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageScreen(),
    );
  }
}