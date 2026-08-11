@@
*** Begin Patch
*** Update File: lib/models/evaluation.dart
@@
   final List<EvaluationQuestion> questions;
 
   /// Número mínimo de respuestas correctas para aprobar.
   final int requiredCorrect;
+  
+  /// Máximo número de preguntas que el jugador puede seleccionar/contestar
+  /// en evaluaciones tipo interrogatorio (por ejemplo: 3 de 5).
+  final int? maxQuestionsToAsk;
@@
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
+    this.maxQuestionsToAsk,
   });
 }
*** End Patch
