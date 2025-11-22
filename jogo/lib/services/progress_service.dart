import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProgressService extends ChangeNotifier {
  final SharedPreferences prefs;
  ProgressService(this.prefs);


// key: lessonId -> bool
  bool isCompleted(String lessonId) => prefs.getBool('completed_$lessonId') ?? false;


  Future<void> markCompleted(String lessonId) async {
    await prefs.setBool('completed_$lessonId', true);
    notifyListeners();
  }
}