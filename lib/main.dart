import 'package:flutter/material.dart';
import 'package:flutter_vidio_upload/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'example upload vidio',
      home: HomePage(),
    );
  }
}
