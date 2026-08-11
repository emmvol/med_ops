import '../models/evaluation.dart';
import '../models/evaluation_result.dart';

class EvaluationService {

  EvaluationResult evaluate({
    required Evaluation evaluation,
    required List<int> answers,
  }) {
    int correct = 0;
    int moneyChange = evaluation.moneyReward;
    int trustChange = evaluation.trustReward;

    final List<String> evidence = [];

    for (int i = 0; i < evaluation.questions.length; i++) {
      final question = evaluation.questions[i];

      if (i >= answers.length) {
        continue;
      }

      final answer = answers[i];

      if (answer == question.correctIndex) {
        correct++;

        trustChange += question.trustOnSuccess;
        moneyChange += question.moneyReward;

        if (question.evidenceOnSuccess != null) {
          evidence.add(question.evidenceOnSuccess!);
        }
      } else {
        trustChange -= question.trustOnFail;
        moneyChange -= question.moneyPenalty;

        if (question.evidenceOnFail != null) {
          evidence.add(question.evidenceOnFail!);
        }
      }
    }

    final bool passed =
        correct >= evaluation.requiredCorrect;

    return EvaluationResult(
      evaluationId: evaluation.id,
      correctAnswers: correct,
      totalQuestions: evaluation.questions.length,
      passed: passed,
      moneyChange: moneyChange,
      trustChange: trustChange,
      evidenceObtained: evidence,
      unlockedFlag:
      passed ? evaluation.unlockFlagOnPass : evaluation.unlockFlagOnFail,
    );
  }
}