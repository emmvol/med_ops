class EvaluationQuestion {

  final String question;

  final List<String> options;

  final int correctIndex;

  final String correctMessage;

  final String incorrectMessage;

  final int trustOnSuccess;

  final int trustOnFail;

  final int moneyPenalty;

  final String? evidenceOnSuccess;

  const EvaluationQuestion({

    required this.question,

    required this.options,

    required this.correctIndex,

    required this.correctMessage,

    required this.incorrectMessage,

    this.trustOnSuccess = 5,

    this.trustOnFail = 5,

    this.moneyPenalty = 100,

    this.evidenceOnSuccess,
  });
}