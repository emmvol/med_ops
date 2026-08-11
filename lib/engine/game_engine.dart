@@
*** Begin Patch
*** Update File: lib/engine/game_engine.dart
@@
   EvaluationResult executeEvaluation(
       String evaluationId,
       List<int> answers,
       ) {
@@
-    if (answers.length != evaluation.questions.length) {
-      throw StateError(
-        "La evaluación requiere "
-            "${evaluation.questions.length} respuestas.",
-      );
-    }
+    // Allow partial evaluations when maxQuestionsToAsk is set
+    final maxAllowed = evaluation.maxQuestionsToAsk ?? evaluation.questions.length;
+
+    if (answers.length == 0 || answers.length > evaluation.questions.length) {
+      throw StateError(
+        "Número de respuestas inválido.",
+      );
+    }
+
+    if (answers.length > maxAllowed) {
+      throw StateError(
+        "Se permiten como máximo $maxAllowed respuestas en esta evaluación.",
+      );
+    }
@@
-    final bool passed =
-        correct >= evaluation.requiredCorrect;
+    final bool passed =
+        correct >= evaluation.requiredCorrect;
@@
     // ------------------------------------------------------------
     // APLICAR RESULTADOS
     // ------------------------------------------------------------
@@
     team.trust += trustChange;
     team.money += moneyChange;
@@
     for (final item in evidence) {
       team.evidence.add(item);
     }
+
+    // Penalización en caso de fallo: coste de oportunidad.
+    // Consumir las acciones restantes del equipo y avanzar turno.
+    if (!passed) {
+      currentTeam.actionPoints = 0;
+      nextTurn();
+    }
*** End Patch
