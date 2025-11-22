import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import 'lesson_screen.dart';


class ModulesScreen extends StatelessWidget {
  static const routeName = '/modules';


  final modules = [
    {'id':'addressing','title_en':'Addressing','title_pt':'Endereçamento'},
    {'id':'layers','title_en':'Layers & Models','title_pt':'Camadas & Modelos'},
  ];


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('modules'))),
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (context, idx) {
          final m = modules[idx];
          final title = Localizations.localeOf(context).languageCode == 'pt' ? m['title_pt']! : m['title_en']!;
          return ListTile(
            title: Text(title),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, LessonScreen.routeName, arguments: {'lessonId':'lesson-subnetting-1'});
            },
          );
        },
      ),
    );
  }
}