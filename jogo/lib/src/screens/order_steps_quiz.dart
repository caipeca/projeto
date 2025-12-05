// order_steps_quiz.dart (resumo importante da parte de verificação)
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/lesson.dart';

class OrderStepsQuiz extends StatefulWidget {
  final Lesson lesson;
  const OrderStepsQuiz({super.key, required this.lesson});

  @override
  State<OrderStepsQuiz> createState() => _OrderStepsQuizState();
}

class _OrderStepsQuizState extends State<OrderStepsQuiz> {
  late List<String> shuffled;

  @override
  void initState() {
    super.initState();
    shuffled = [...widget.lesson.quizSteps]..shuffle();
  }

  void verifyOrder() {
    if (listEquals(shuffled, widget.lesson.quizSteps)) {
      // sucesso: retorna true para o caller
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ordem incorreta! Tente novamente.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz • ${widget.lesson.title}")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Arraste para ordenar as etapas na sequência correta:", textAlign: TextAlign.center),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = shuffled.removeAt(oldIndex);
                  shuffled.insert(newIndex, item);
                });
              },
              children: [
                for (final s in shuffled)
                  Card(
                    key: ValueKey(s),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(title: Text(s)),
                  )
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: verifyOrder,
                child: const Text('Verificar'),
              ),
            ),
          ),
                  ],
      ),
    );
  }
}
