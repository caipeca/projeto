import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';


import '../localization/app_localizations.dart';
import '../models/lesson.dart';
import '../services/progress_service.dart';


class LessonScreen extends StatefulWidget {
  static const routeName = '/lesson';

  @override
  _LessonScreenState createState() => _LessonScreenState();
}


class _LessonScreenState extends State<LessonScreen> {
  Lesson? lesson;
  bool loading = true;
  String? selectedOptionId;
  bool answered = false;
  bool correct = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loading) _loadLesson();
  }

  Future<void> _loadLesson() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final lessonId = args?['lessonId'] ?? 'lesson-subnetting-1';
// load static json from assets
    final jsonStr = await rootBundle.loadString('assets/lessons/subnetting.json');
    final map = json.decode(jsonStr);


    final exercises = (map['exercises'] as List).map((e) {
      return Exercise(
        id: e['id'],
        type: e['type'],
        question: e['question'],
        options: e['options'] != null ? (e['options'] as List).map((o) => ExerciseOption(id: o['id'], text: o['text'])).toList() : null,
        answer: e['answer'],
        explanation: e['explanation'],
      );
    }).toList();


    setState(() {
      lesson = Lesson(id: map['id'], title: map['title'], module: map['module'], content: map['content'], exercises: exercises);
      loading = false;
    });
  }

  void submitAnswer(Exercise ex) {
    if (selectedOptionId == null) return;
    setState(() {
      answered = true;
      correct = selectedOptionId == ex.answer;
    });
    if (correct) {
      Provider.of<ProgressService>(context, listen: false).markCompleted(lesson!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));


    final ex = lesson!.exercises.first;


    return Scaffold(
      appBar: AppBar(title: Text(lesson!.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// content
            Text(lesson!.content[0]['value']),
            SizedBox(height: 16),
            Text(ex.question, style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            ...ex.options!.map((opt) {
              return RadioListTile<String>(
                value: opt.id,
                groupValue: selectedOptionId,
                onChanged: answered ? null : (v) => setState(() => selectedOptionId = v),
                title: Text(opt.text),
              );
            }).toList(),
            Spacer(),
            if (!answered)
              ElevatedButton(
                onPressed: selectedOptionId == null ? null : () => submitAnswer(ex),
                child: Text(loc.translate('lesson_continue')),
              ),
            if (answered) ...[
              SizedBox(height: 8),
              Text(correct ? loc.translate('correct') : loc.translate('incorrect'), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(ex.explanation ?? ''),
              SizedBox(height: 12),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
            ]
          ],
        ),
      ),
    );
  }
}