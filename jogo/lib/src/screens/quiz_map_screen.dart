import 'package:flutter/material.dart';
import 'drag_quiz_screen.dart';

class QuizMapScreen extends StatefulWidget {
  const QuizMapScreen({super.key});

  @override
  State<QuizMapScreen> createState() => _QuizMapScreenState();
}

class _QuizMapScreenState extends State<QuizMapScreen>
    with SingleTickerProviderStateMixin {
  int progress = 1; // número de quizzes concluídos

  late AnimationController _controller;
  late Animation<double> _animation;

  final List<_QuizNode> quizzes = [
    _QuizNode(title: "Básico 1"),
    _QuizNode(title: "Básico 2"),
    _QuizNode(title: "Tipos de Cabos"),
    _QuizNode(title: "Topologias"),
    _QuizNode(title: "Endereçamento"),
    _QuizNode(title: "Sub-redes"),
    _QuizNode(title: "ARP / DHCP"),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openQuiz(int index) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DragQuizScreen()),
    );

    // Simula completar a lição
    setState(() {
      progress = (progress + 1).clamp(0, quizzes.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trilha de Quizzes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // 🔥 Barra de progresso
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressIndicator(
              value: progress / quizzes.length,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
            ),
          ),

          const SizedBox(height: 8),
          Text("${progress} / ${quizzes.length} concluídos"),

          const SizedBox(height: 20),

          // 🔥 Conteúdo principal
          Expanded(
            child: ListView.builder(
              itemCount: quizzes.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (_, i) {
                bool unlocked = i <= progress;
                bool completed = i < progress;

                return ScaleTransition(
                  scale: _animation,
                  child: GestureDetector(
                    onTap: unlocked ? () => openQuiz(i) : null,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: completed
                            ? Colors.green.shade400
                            : unlocked
                            ? Colors.blue.shade400
                            : Colors.grey.shade300,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            completed
                                ? Icons.check_circle
                                : unlocked
                                ? Icons.play_circle_fill
                                : Icons.lock,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            quizzes[i].title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _QuizNode {
  final String title;
  _QuizNode({required this.title});
}
