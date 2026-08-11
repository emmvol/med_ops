import 'evaluation_question.dart';

enum EvaluationType {
  integration,
  finalCase,
  miniCase,
}

class Evaluation {
  final String id;
  final int expediente;
  final String title;
  final String subtitle;
  final EvaluationType type;
  final List<EvaluationQuestion> questions;

  final int requiredCorrect;

  final int? maxQuestionsToAsk;

  final String? unlockFlagOnPass;

  final String? unlockFlagOnFail;

  final int moneyReward;

  final int trustReward;

  /// Si es true, fallar cierra la evaluación, pero permite
  /// volver a abrirla mediante la decisión que la desencadena.
  final bool retryOnFail;

  const Evaluation({
    required this.id,
    required this.expediente,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.questions,
    this.requiredCorrect = 3,
    this.maxQuestionsToAsk,
    this.unlockFlagOnPass,
    this.unlockFlagOnFail,
    this.moneyReward = 0,
    this.trustReward = 0,
    this.retryOnFail = false,
  });
}