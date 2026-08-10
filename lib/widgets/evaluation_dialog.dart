import 'package:flutter/material.dart';

import '../models/evaluation.dart';
import '../models/evaluation_question.dart';

class EvaluationDialog extends StatefulWidget {

  final Evaluation evaluation;

  final void Function(
      bool success,
      String? evidence,
      ) onFinished;

  final VoidCallback? onClose;

  const EvaluationDialog({

    super.key,

    required this.evaluation,

    required this.onFinished,

    this.onClose,
  });

  @override
  State<EvaluationDialog> createState() =>
      _EvaluationDialogState();
}

class _EvaluationDialogState
    extends State<EvaluationDialog> {

  int currentQuestion = 0;

  int consecutiveCorrect = 0;

  int? selectedOption;

  bool answered = false;

  bool lastAnswerCorrect = false;

  EvaluationQuestion get question =>
      widget.evaluation.questions[currentQuestion];

  // ============================================================
  // RESPONDER
  // ============================================================

  void answer() {

    if (selectedOption == null || answered) {
      return;
    }

    final correct =
        selectedOption == question.correctIndex;

    setState(() {

      answered = true;

      lastAnswerCorrect = correct;

      if (correct) {
        consecutiveCorrect++;
      } else {
        consecutiveCorrect = 0;
      }
    });
  }

  // ============================================================
  // CONTINUAR
  // ============================================================

  void continueQuestion() {

    // ----------------------------------------------------------
    // EVALUACIÓN COMPLETADA
    // ----------------------------------------------------------

    if (
    consecutiveCorrect >=
        widget.evaluation.requiredCorrect
    ) {

      widget.onFinished(
        true,
        question.evidenceOnSuccess,
      );

      Navigator.pop(context);

      return;
    }

    // ----------------------------------------------------------
    // SI FALLÓ
    // ----------------------------------------------------------

    if (!lastAnswerCorrect) {

      setState(() {

        currentQuestion = 0;

        selectedOption = null;

        answered = false;

        lastAnswerCorrect = false;
      });

      return;
    }

    // ----------------------------------------------------------
    // SIGUIENTE PREGUNTA
    // ----------------------------------------------------------

    if (
    currentQuestion + 1 <
        widget.evaluation.questions.length
    ) {

      setState(() {

        currentQuestion++;

        selectedOption = null;

        answered = false;

        lastAnswerCorrect = false;
      });

      return;
    }

    // ----------------------------------------------------------
    // VOLVER A LA PRIMERA PREGUNTA
    // ----------------------------------------------------------

    setState(() {

      currentQuestion = 0;

      selectedOption = null;

      answered = false;

      lastAnswerCorrect = false;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {

    final progress =
        (currentQuestion + 1) /
            widget.evaluation.questions.length;

    return PopScope(
      canPop: false,

      child: AlertDialog(

        title: Row(

          children: [

            const Icon(
              Icons.assignment_turned_in,
            ),

            const SizedBox(
              width: 10,
            ),

            Expanded(
              child: Text(
                widget.evaluation.title,
              ),
            ),
          ],
        ),

        content: SizedBox(

          width: 600,

          child: SingleChildScrollView(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  widget.evaluation.subtitle,

                  style:
                  Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(
                  height: 16,
                ),

                // ------------------------------------------------
                // PROGRESO
                // ------------------------------------------------

                LinearProgressIndicator(
                  value: progress,
                ),

                const SizedBox(
                  height: 8,
                ),

                Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    Text(
                      "Pregunta ${currentQuestion + 1}"
                          " de "
                          "${widget.evaluation.questions.length}",
                    ),

                    Text(
                      "Aciertos consecutivos: "
                          "$consecutiveCorrect/"
                          "${widget.evaluation.requiredCorrect}",
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // ------------------------------------------------
                // PREGUNTA
                // ------------------------------------------------

                Text(

                  question.question,

                  style:
                  Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // ------------------------------------------------
                // OPCIONES
                // ------------------------------------------------

                ...List.generate(

                  question.options.length,

                      (index) {

                    final selected =
                        selectedOption == index;

                    return Card(

                      margin:
                      const EdgeInsets.only(
                        bottom: 8,
                      ),

                      child: RadioListTile<int>(

                        value: index,

                        groupValue:
                        selectedOption,

                        onChanged:
                        answered
                            ? null
                            : (value) {

                          setState(() {

                            selectedOption =
                                value;
                          });
                        },

                        title: Text(
                          question.options[index],
                        ),

                        selected:
                        selected,
                      ),
                    );
                  },
                ),

                // ------------------------------------------------
                // RESULTADO
                // ------------------------------------------------

                if (answered) ...[

                  const SizedBox(
                    height: 12,
                  ),

                  Container(

                    width:
                    double.infinity,

                    padding:
                    const EdgeInsets.all(14),

                    decoration:
                    BoxDecoration(

                      borderRadius:
                      BorderRadius.circular(8),

                      color:
                      lastAnswerCorrect
                          ? Colors.green
                          .withValues(
                        alpha: 0.12,
                      )
                          : Colors.red
                          .withValues(
                        alpha: 0.12,
                      ),
                    ),

                    child: Row(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Icon(

                          lastAnswerCorrect
                              ? Icons.check_circle
                              : Icons.cancel,

                          color:
                          lastAnswerCorrect
                              ? Colors.green
                              : Colors.red,
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(

                          child: Text(

                            lastAnswerCorrect
                                ? question
                                .correctMessage
                                : question
                                .incorrectMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        actions: [

          if (!answered)

            FilledButton.icon(

              icon: const Icon(
                Icons.check,
              ),

              label: const Text(
                "Responder",
              ),

              onPressed:
              selectedOption == null
                  ? null
                  : answer,
            )

          else

            FilledButton.icon(

              icon: Icon(

                consecutiveCorrect >=
                    widget.evaluation
                        .requiredCorrect
                    ? Icons.flag
                    : Icons.arrow_forward,
              ),

              label: Text(

                consecutiveCorrect >=
                    widget.evaluation
                        .requiredCorrect
                    ? "Resolver caso"
                    : "Continuar",
              ),

              onPressed:
              continueQuestion,
            ),
        ],
      ),
    );
  }
}