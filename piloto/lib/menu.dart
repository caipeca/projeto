
import 'package:flutter/material.dart';
import 'package:piloto/data/notifier.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return NavigationBar(
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
            ],
            onDestinationSelected: (int value) {
              selectedPageNotifier.value = value;
            },
            selectedIndex: selectedPage,
          );
        },
    );
  }
}
