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

  /// Número mínimo de respuestas correctas para aprobar.
  final int requiredCorrect;

  /// Flag que se desbloquea al aprobar.
  /// Ejemplo: "raveHouseUnlocked"
  final String? unlockFlagOnPass;

  /// Flag que se desbloquea al fallar.
  /// Normalmente null.
  final String? unlockFlagOnFail;

  /// Dinero obtenido al aprobar.
  final int moneyReward;

  /// Reputación obtenida al aprobar.
  final int trustReward;

  const Evaluation({
    required this.id,
    required this.expediente,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.questions,
    this.requiredCorrect = 3,
    this.unlockFlagOnPass,
    this.unlockFlagOnFail,
    this.moneyReward = 0,
    this.trustReward = 0,
  });
}