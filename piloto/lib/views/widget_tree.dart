import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piloto/data/notifier.dart';
import 'package:piloto/menu.dart';
import 'package:piloto/views/screen/home.dart';
import 'package:piloto/views/screen/profile.dart';
import 'package:piloto/views/screen/store.dart';

//List<Widget> pages = [
  //Home(),
  //Store(),
  //ProfilePage(),
//];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Economizar')),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return _buildPage(selectedPage);
        },
      ),
      bottomNavigationBar: Menu(),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return Store();
      case 2:
        return ProfilePage();
      default:
        return Home();
    }
  }
}
