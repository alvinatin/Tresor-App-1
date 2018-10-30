import 'package:flutter/material.dart';
import 'removable_list.dart';
import 'input_text.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        home: InputTextPage()
    );
  }
}
