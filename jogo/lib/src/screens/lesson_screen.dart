import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../widgets/cable_mascot.dart';
import 'order_steps_quiz.dart';

class LessonScreen extends StatelessWidget {
  final Lesson lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            SizedBox(height: 140, child: Center(child: CableMascot(size: 120))),
            const SizedBox(height: 12),
            Text(lesson.description, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: lesson.content.map((block) {
                      switch (block.type) {

                        case "title":
                          return Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Text(
                              block.value,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          );

                        case "text":
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              block.value,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );

                        case "list":
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (block.value as List<String>).map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle, size: 8),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(item)),
                                  ],
                                ),
                              );
                            }).toList(),
                          );

                        case "image":
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(block.value),
                            ),
                          );

                        case "diagram":
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              block.value,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                color: Colors.greenAccent,
                                height: 1.3,
                              ),
                            ),
                          );

                        case "example":
                          return Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  block.value["title"],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(block.value["description"]),
                              ],
                            ),
                          );

                        default:
                          return const SizedBox.shrink();
                      }
                    }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 1),
            ElevatedButton(
              onPressed: () async {
                final passed = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => OrderStepsQuiz(lesson: lesson)),
                );

                if (passed == true) {
                  // retornar ao Dashboard informando que a lição foi completada
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Concluir aula (fazer quiz)'),
            ),
          ],
        ),
      ),
    );
  }
}
