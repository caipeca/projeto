import 'package:flutter/material.dart';
import 'package:piloto/utils/theme/theme.dart';
import 'package:piloto/views/screen/login.dart';
import 'package:piloto/views/widget_tree.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: PAppTheme.ligTheme,
      darkTheme: PAppTheme.darkTheme,
      home: Login(),
    );
  }
}
