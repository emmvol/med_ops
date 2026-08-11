class EvaluationQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  final String correctMessage;
  final String incorrectMessage;

  final int trustOnSuccess;
  final int trustOnFail;

  final int moneyReward;
  final int moneyPenalty;

  final String? evidenceOnSuccess;
  final String? evidenceOnFail;

  const EvaluationQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.correctMessage,
    required this.incorrectMessage,

    this.trustOnSuccess = 5,
    this.trustOnFail = 5,

    this.moneyReward = 0,
    this.moneyPenalty = 100,

    this.evidenceOnSuccess,
    this.evidenceOnFail,
  });
}