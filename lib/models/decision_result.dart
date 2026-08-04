class DecisionResult {

  final bool success;

  final String title;

  final String message;

  final String? evidence;

  final bool patientConditionChanged;

  const DecisionResult({

    required this.success,

    required this.title,

    required this.message,

    this.evidence,

    this.patientConditionChanged = false,

  });

}