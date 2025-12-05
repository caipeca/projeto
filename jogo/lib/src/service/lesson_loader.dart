import 'package:flutter/services.dart' show rootBundle;
import '../models/lesson.dart';

class LessonLoader {
  static Future<List<Lesson>> loadFromAssets() async {
    final jsonStr = await rootBundle.loadString('assets/lessons/lessons.json');
    return Lesson.fromJsonList(jsonStr);
  }
}