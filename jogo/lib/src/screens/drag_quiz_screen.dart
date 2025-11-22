import 'package:flutter/material.dart';

class DragQuizScreen extends StatefulWidget {
  const DragQuizScreen({super.key});

  @override
  State<DragQuizScreen> createState() => _DragQuizScreenState();
}

class _DragQuizScreenState extends State<DragQuizScreen> {
  // EXEMPLO: associar protocolo → porta
  final List<_Pair> pairs = [
    _Pair(left: "HTTP", right: "80"),
    _Pair(left: "DNS", right: "53"),
    _Pair(left: "HTTPS", right: "443"),
  ];

  // Guarda onde cada porta foi solta
  final Map<String, String?> placed = {};

  @override
  void initState() {
    super.initState();
    for (var p in pairs) {
      placed[p.left] = null;
    }
  }

  bool get isCompleted =>
      placed.values.every((value) => value != null);

  bool get isCorrect {
    for (var p in pairs) {
      if (placed[p.left] != p.right) return false;
    }
    return true;
  }

  void _reset() {
    setState(() {
      for (var p in pairs) {
        placed[p.left] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rightItems = pairs.map((e) => e.right).toList()..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz — Arrastar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Arraste cada protocolo para a porta correspondente:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Row(
                children: [
                  // COLUNA ESQUERDA — Protocolo (alvo)
                  Expanded(
                    child: ListView(
                      children: pairs.map((item) {
                        return _buildTarget(item.left, placed[item.left]);
                      }).toList(),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // COLUNA DIREITA — Portas (arrastáveis)
                  Expanded(
                    child: ListView(
                      children: rightItems.map((text) {
                        return _buildDraggable(text);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // BOTÕES DE AÇÃO
            if (isCompleted) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (isCorrect) {
                    _showResult(context, true);
                  } else {
                    _showResult(context, false);
                  }
                },
                child: const Text("Validar Respostas"),
              ),
            ],
            TextButton(onPressed: _reset, child: const Text("Reiniciar")),
          ],
        ),
      ),
    );
  }

  /* --------------------------------------------------------
     WIDGET: Área onde soltar o item
     -------------------------------------------------------- */
  Widget _buildTarget(String leftLabel, String? currentValue) {
    return DragTarget<String>(
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          placed[leftLabel] = data;
        });
      },
      builder: (context, candidateData, rejected) {
        return Card(
          color: Colors.grey.shade100,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: Text(leftLabel[0]),
            ),
            title: Text(leftLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: currentValue == null ? Colors.grey.shade300 : Colors.teal.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentValue ?? "Solte aqui",
                style: TextStyle(
                  color: currentValue == null ? Colors.black54 : Colors.teal.shade900,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /* --------------------------------------------------------
     WIDGET: Elemento arrastável
     -------------------------------------------------------- */
  Widget _buildDraggable(String text) {
    return Draggable<String>(
      data: text,
      feedback: _dragBox(text, isDragging: true),
      childWhenDragging: _dragBox(text, faded: true),
      child: _dragBox(text),
    );
  }

  Widget _dragBox(String text, {bool faded = false, bool isDragging = false}) {
    return Opacity(
      opacity: faded ? 0.3 : 1.0,
      child: Card(
        elevation: isDragging ? 8 : 2,
        color: Colors.blueGrey.shade50,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* --------------------------------------------------------
     POPUP RESULTADO
     -------------------------------------------------------- */
  void _showResult(BuildContext context, bool correct) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(correct ? "✔ Resposta Correta!" : "✖ Algumas respostas estão erradas"),
          content: Text(
            correct
                ? "Muito bem! Todos os pares estão corretos."
                : "Tenta novamente — alguns pares não correspondem.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (correct) Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }
}

/* --------------------------------------------------------
   Classe auxiliar (par de itens)
   -------------------------------------------------------- */
class _Pair {
  final String left;
  final String right;
  _Pair({required this.left, required this.right});
}
