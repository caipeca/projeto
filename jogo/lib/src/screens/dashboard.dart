import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../widgets/lesson_card.dart';
import 'lesson_screen.dart';
import 'drag_quiz_screen.dart';
import 'quiz_map_screen.dart';
import '../widgets/cable_mascot.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Lesson> _lessons;

  @override
  void initState() {
    super.initState();
    _lessons = DemoLesson.sample();
  }

  Future<void> _openLesson(int index) async {
    final lesson = _lessons[index];

    if (!lesson.unlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete a aula anterior para desbloquear esta.")),
      );
      return;
    }

    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => LessonScreen(lesson: lesson)),
    );

    if (completed == true) {
      setState(() {
        _lessons[index].completed = true;
        if (index + 1 < _lessons.length) {
          _lessons[index + 1].unlocked = true;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Parabéns — '${lesson.title}' concluída! Próxima desbloqueada.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trilha • Redes'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const CableMascot(size: 90),
                    const SizedBox(width: 12),
                    Expanded(child: _ProgressSummary(lessons: _lessons,)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DragQuizScreen()));
                  },
                  icon: const Icon(Icons.extension),
                  label: const Text("Quiz de Arrastar"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizMapScreen()));
                  },
                  child: const Text("Mapa de Quizzes"),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Expanded(
              child: ListView.separated(
                itemCount: _lessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final l = _lessons[i];
                  return LessonCard(
                    lesson: l,
                    index: i,
                    onTap: () => _openLesson(i),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  final List<Lesson> lessons;

  const _ProgressSummary({super.key, required this.lessons});

  @override
  Widget build(BuildContext context) {
    final completed = lessons.where((l) => l.completed).length;
    final progress = lessons.isEmpty ? 0.0 : completed / lessons.length;
    final xp = completed * 50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progresso',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),

        // BARRA DE PROGRESSO REAL
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation(Colors.teal),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Aulas concluídas: $completed / ${lessons.length}'),
            Text('XP: $xp'),
          ],
        )
      ],
    );
  }
}

