class EvaluationResult {
  final String evaluationId;

  final int correctAnswers;
  final int totalQuestions;

  final bool passed;

  final int moneyChange;
  final int trustChange;

  final List<String> evidenceObtained;

  final String? unlockedFlag;

  const EvaluationResult({
    required this.evaluationId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.passed,
    required this.moneyChange,
    required this.trustChange,
    required this.evidenceObtained,
    required this.unlockedFlag,
  });
}