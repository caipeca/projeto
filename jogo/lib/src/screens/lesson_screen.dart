// lib/src/screens/lesson_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/lesson.dart';
import '../widgets/animated_paragraph.dart';
import '../widgets/animated_mascot.dart';
import '../widgets/cable_mascot.dart';
import 'order_steps_quiz.dart';

class LessonScreen extends StatelessWidget {
  final Lesson lesson;
  const LessonScreen({super.key, required this.lesson});

  Widget _buildBlock(BuildContext context, LessonContentBlock block, int index) {
    switch (block.type) {
      case 'title':
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Text(block.value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        );
      case 'text':
        return AnimatedParagraph(text: block.value, delay: Duration(milliseconds: 80 * index));
      case 'list':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (block.value as List<dynamic>).map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 6), child: Icon(Icons.circle, size: 8)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.toString())),
                ],
              ),
            );
          }).toList(),
        );
      case 'image':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(block.value, fit: BoxFit.cover),
          ),
        );
      case 'diagram':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(12)),
          child: Text(block.value, style: const TextStyle(fontFamily: 'monospace', color: Colors.greenAccent)),
        );
      case 'example':
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(block.value['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(block.value['description']),
          ]),
        );
      case 'animation':
      // espera um path Lottie nas assets
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(height: 140, child: Lottie.asset(block.value)),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          // Mascote animado no topo
          const CableMascot(size: 140),
          //AnimatedMascot(size: 120, assetPath: 'assets/animations/mascot_idle.json'),
          const SizedBox(height: 10),
          Text(lesson.description, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // render blocks com index (para delays)
                  for (int i = 0; i < lesson.content.length; i++)
                    _buildBlock(context, lesson.content[i], i),
                  // animação Lottie entre seções opcional
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Center(child: SizedBox(height: 120, child: Lottie.asset('assets/animations/reading.json'))),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),

      // botão fixo no fundo
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final passed = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => OrderStepsQuiz(lesson: lesson)),
                );

                if (passed == true) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Concluir aula (fazer quiz)'),
            ),
          ),
        ),

      ),
    );
  }
}
