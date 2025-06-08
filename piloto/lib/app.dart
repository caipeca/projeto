import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piloto/screen/login.dart';

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
      home: Login(),
    );
  }
}
