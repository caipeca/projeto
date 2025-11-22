class ExerciseOption {
  final String id;
  final String text;
  ExerciseOption({required this.id, required this.text});
}


class Exercise {
  final String id;
  final String type; // 'mcq' | 'fill'
  final String question;
  final List<ExerciseOption>? options;
  final String? answer;
  final String? explanation;


  Exercise({required this.id, required this.type, required this.question, this.options, this.answer, this.explanation});
}


class Lesson {
  final String id;
  final String title;
  final String module;
  final List<dynamic> content; // text, examples, etc.
  final List<Exercise> exercises;


  Lesson({required this.id, required this.title, required this.module, required this.content, required this.exercises});
}