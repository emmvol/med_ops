import 'evaluation_question.dart';

class Evaluation {

  final String id;

  final String title;

  final String subtitle;

  final List<EvaluationQuestion> questions;

  final int requiredCorrect;

  const Evaluation({

    required this.id,

    required this.title,

    required this.subtitle,

    required this.questions,

    this.requiredCorrect = 3,
  });
}