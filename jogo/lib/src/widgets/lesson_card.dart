import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback? onTap;
  final int index;

  const LessonCard({
    super.key,
    required this.lesson,
    this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: lesson.unlocked ? 1.0 : 0.6,
      child: InkWell(
        onTap: lesson.unlocked ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: lesson.unlocked ? Colors.teal.shade100 : Colors.grey.shade300,
                child: Icon(Icons.router, color: lesson.unlocked ? Colors.teal.shade800 : Colors.grey.shade700),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title, style: TextStyle(fontWeight: FontWeight.bold, color: lesson.unlocked ? Colors.black87 : Colors.black45)),
                    const SizedBox(height: 4),
                    Text(lesson.description, style: TextStyle(color: lesson.unlocked ? Colors.black54 : Colors.black45)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // status icon: cadeado / checado / seta
              if (!lesson.unlocked)
                Icon(Icons.lock, color: Colors.grey.shade700)
              else if (lesson.completed)
                Icon(Icons.check_circle, color: Colors.green)
              else
                Icon(Icons.chevron_right, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}
