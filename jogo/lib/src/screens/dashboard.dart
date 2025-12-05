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
      backgroundColor: const Color(0xfff0f6f4), // igual imagem
      appBar: AppBar(
        title: const Text('Trilha • Redes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            // CARD DO PROGRESSO (idêntico ao da imagem)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CableMascot(size: 90),
                    const SizedBox(width: 12),
                    Expanded(child: _ProgressSummary(lessons: _lessons)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // BOTÕES (igual imagem)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffeaf4f1),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const DragQuizScreen(),
                      ));
                    },
                    icon: const Icon(Icons.extension),
                    label: const Text("Quiz de Arrastar"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffeaf4f1),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const QuizMapScreen(),
                      ));
                    },
                    child: const Text("Mapa de Quizzes"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // LISTA DAS AULAS
            Expanded(
              child: ListView.separated(
                itemCount: _lessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final lesson = _lessons[i];
                  return LessonCard(
                    lesson: lesson,
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
  const _ProgressSummary({required this.lessons});

  @override
  Widget build(BuildContext context) {
    final completed = lessons.where((l) => l.completed).length;
    final progress = lessons.isEmpty ? 0.0 : completed / lessons.length;
    final xp = completed * 50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Progresso",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation(Color(0xff0e8c79)),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Aulas concluídas: $completed / ${lessons.length}"),
            Text("XP: $xp"),
          ],
        )
      ],
    );
  }
}
