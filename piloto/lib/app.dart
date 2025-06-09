import 'package:flutter/material.dart';
import 'package:piloto/views/screen/login.dart';
import 'package:piloto/views/widget_tree.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal.shade700,
            brightness: Brightness.dark
        ),
      ),
      home: WidgetTree(),
    );
  }
}
