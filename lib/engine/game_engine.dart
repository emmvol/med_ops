import 'dart:math';

import '../data/campaign_evaluations.dart';
import '../data/decisions.dart';
import '../data/events.dart';
import '../data/mini_case_evaluations.dart';
import '../data/sample_case.dart';
import '../models/decision.dart';
import '../models/decision_result.dart';
import '../models/evaluation.dart';
import '../models/evaluation_result.dart';
import '../models/game_event.dart';
import '../models/game_state.dart';
import '../models/location.dart';
import '../models/story_node.dart';
import '../models/team.dart';
import '../services/campaign_progression.dart';
import '../services/location_manager.dart';

class GameEngine {

     final GameState game;

     final Random random = Random();

     static const int decisionStabilityDecay = 5;

     GameEngine(this.game);

     // ============================================================
     // EQUIPO
     // ============================================================

     Team get currentTeam =>
         game.teams[game.roundManager.currentTeam];

     // ============================================================
     // HISTORIA GLOBAL
     // ============================================================

     StoryNode get currentNode =>
         caseNodes[game.currentNodeId]!;

     // ============================================================
     // DECISIONES
     // ============================================================

     DecisionResult executeDecision(Decision decision) {

          if (game.caseFinished) {
               return const DecisionResult(
                    success: false,
                    title: "Caso terminado",
                    message: "La operación ya ha finalizado.",
               );
          }

          if (game.gamePaused) {
               return const DecisionResult(
                    success: false,
                    title: "Juego pausado",
                    message: "Reanuda la operación para continuar.",
               );
          }

          final team = currentTeam;

          if (team.actionPoints < decision.apCost) {
               return const DecisionResult(
                    success: false,
                    title: "Sin acciones",
                    message: "No quedan suficientes puntos de acción.",
               );
          }

          if (team.money < decision.moneyCost) {
               return const DecisionResult(
                    success: false,
                    title: "Fondos insuficientes",
                    message: "El equipo no dispone de fondos suficientes.",
               );
          }

          // ------------------------------------------------------------
          // COSTOS
          // ------------------------------------------------------------

          team.actionPoints -= decision.apCost;
          team.money -= decision.moneyCost;

          // ------------------------------------------------------------
          // RESULTADO
          // ------------------------------------------------------------

          final success =
              random.nextInt(100) < decision.successRate;

          if (success) {

               team.trust += decision.trustChange;

               // Las decisiones que abren una evaluación de integración
               // permanecen disponibles hasta que la evaluación sea aprobada.
               if (
               decision.repeat == DecisionRepeat.once &&
                   decision.evaluationId == null
               ) {
                    game.completedActions.add(decision.id);
               }

               if (decision.evidence != null) {
                    team.evidence.add(decision.evidence!);
               }

               decision.onSuccess?.call(game);

               if (decision.evaluationId != null) {
                    game.unlockedEvaluations.add(
                         decision.evaluationId!,
                    );
               }

          } else {

               team.trust -= 5;

               decision.onFail?.call(game);
          }

          // ------------------------------------------------------------
          // DESGASTE CLÍNICO POR DECISIÓN
          // ------------------------------------------------------------

          // No decrementar la estabilidad por decisiones clínicas a partir de EXPEDIENTE 4.
          // El paciente puede despertarse y debe conservar estabilidad durante el interrogatorio.
          if (!game.flags.patientDead && game.currentExpediente < 4) {
               game.patient.modifyStability(-3);
          }

          // ------------------------------------------------------------
          // ESTADO CLÍNICO
          // ------------------------------------------------------------

          checkPatientStatus();

          // ------------------------------------------------------------
          // PROGRESIÓN GLOBAL
          // ------------------------------------------------------------

          checkStoryProgress();

          return DecisionResult(
               success: success,
               title: success
                   ? "Acción completada"
                   : "Acción fallida",
               message: success
                   ? decision.result
                   : decision.failResult,
               evidence: success
                   ? decision.evidence
                   : null,
               evaluationId: decision.evaluationId,
          );
     }

     void _completeDecisionForEvaluation(String evaluationId) {

          for (final decision in decisions.values) {

               if (decision.evaluationId == evaluationId) {

                    game.completedActions.add(decision.id);

                    break;
               }
          }
     }

     // ============================================================
     // CRONÓMETRO
     // ============================================================

     Duration get remainingTime {

          if (!game.caseStarted) {
               return game.caseDuration;
          }

          Duration elapsed =
              game.elapsedBeforePause;

          if (
          !game.gamePaused &&
              game.caseStartedAt != null
          ) {
               elapsed += DateTime.now().difference(
                    game.caseStartedAt!,
               );
          }

          final remaining =
              game.caseDuration - elapsed;

          if (remaining.isNegative) {
               return Duration.zero;
          }

          return remaining;
     }

     bool get isTimeCritical {

          return remainingTime <=
              const Duration(minutes: 15);
     }

     String get formattedRemainingTime {

          final duration = remainingTime;

          final hours = duration.inHours;
          final minutes =
          duration.inMinutes.remainder(60);
          final seconds =
          duration.inSeconds.remainder(60);

          if (hours > 0) {
               return
                    '${hours.toString().padLeft(2, '0')}:'
                        '${minutes.toString().padLeft(2, '0')}:'
                        '${seconds.toString().padLeft(2, '0')}';
          }

          return
               '${minutes.toString().padLeft(2, '0')}:'
                   '${seconds.toString().padLeft(2, '0')}';
     }

     void startCase() {

          game.caseStartedAt = DateTime.now();

          game.elapsedBeforePause =
              Duration.zero;

          game.caseStarted = true;
          game.gamePaused = false;
          game.timeExpired = false;
          game.caseFinished = false;
     }

     void pauseGame() {

          if (
          !game.caseStarted ||
              game.gamePaused ||
              game.timeExpired ||
              game.caseFinished
          ) {
               return;
          }

          if (game.caseStartedAt != null) {

               game.elapsedBeforePause +=
                   DateTime.now().difference(
                        game.caseStartedAt!,
                   );
          }

          game.caseStartedAt = null;
          game.gamePaused = true;
     }

     void resumeGame() {

          if (
          !game.gamePaused ||
              game.timeExpired ||
              game.caseFinished
          ) {
               return;
          }

          game.caseStartedAt = DateTime.now();

          game.gamePaused = false;
     }

     bool checkTimeExpired() {

          if (
          !game.caseStarted ||
              game.gamePaused ||
              game.timeExpired ||
              game.caseFinished
          ) {
               return false;
          }

          if (remainingTime <= Duration.zero) {

               game.timeExpired = true;
               game.caseFinished = true;

               return true;
          }

          return false;
     }

     void extendCaseBy15Minutes() {

          if (!game.timeExpired) {
               return;
          }

          game.caseDuration +=
          const Duration(minutes: 15);

          game.timeExpired = false;
          game.caseFinished = false;

          game.caseStartedAt =
              DateTime.now();

          game.gamePaused = false;
     }

     // ============================================================
     // EVALUACIONES
     // ============================================================

     Evaluation? getEvaluation(String evaluationId) {

          if (campaignEvaluations.containsKey(evaluationId)) {
               return campaignEvaluations[evaluationId];
          }

          if (finalEvaluations.containsKey(evaluationId)) {
               return finalEvaluations[evaluationId];
          }

          if (miniCaseEvaluations.containsKey(evaluationId)) {
               return miniCaseEvaluations[evaluationId];
          }

          return null;
     }

     EvaluationResult executeEvaluation(
         String evaluationId,
         List<int> answers,
         ) {

          final evaluation = getEvaluation(evaluationId);

          if (evaluation == null) {
               throw StateError(
                    "Evaluación no encontrada: $evaluationId",
               );
          }

          if (!game.unlockedEvaluations.contains(evaluationId)) {
               throw StateError(
                    "La evaluación no está desbloqueada: $evaluationId",
               );
          }

          if (game.completedEvaluations.contains(evaluationId)) {
               throw StateError(
                    "La evaluación ya fue completada: $evaluationId",
               );
          }

          // Coste en AP al iniciar evaluación
          final team = currentTeam;
          if (team.actionPoints <= 0) {
               throw StateError("No quedan puntos de acción para iniciar la evaluación.");
          }
          team.actionPoints -= 1;

          // Validación de respuestas parciales según maxQuestionsToAsk
          final maxAllowed = evaluation.maxQuestionsToAsk ?? evaluation.questions.length;
          if (answers.isEmpty || answers.length > evaluation.questions.length) {
               throw StateError("Número de respuestas inválido.");
          }
          if (answers.length > maxAllowed) {
               throw StateError("Se permiten como máximo $maxAllowed respuestas en esta evaluación.");
          }

          int correct = 0;
          int trustChange = 0;
          int moneyChange = 0;
          final List<String> evidence = [];

          // Evaluar solo las preguntas contestadas (answers[i] => question i)
          for (int i = 0; i < answers.length; i++) {
               final question = evaluation.questions[i];
               final answer = answers[i];

               if (answer < 0 || answer >= question.options.length) {
                    throw StateError("Respuesta inválida en pregunta ${i + 1}.");
               }

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

          final bool passed = correct >= evaluation.requiredCorrect;

          // Aplicar recompensas fijas de la evaluación (se acumulan a los cambios por preguntas)
          trustChange += evaluation.trustReward;
          moneyChange += evaluation.moneyReward;

          // Guardar expediente previo para el resultado
          final int previousExpediente = game.currentExpediente;

          // ------------------------------------------------------------
          // APLICAR RESULTADOS AL EQUIPO
          // ------------------------------------------------------------
          team.trust += trustChange;
          team.money += moneyChange;
          for (final item in evidence) {
               team.evidence.add(item);
          }

          // ------------------------------------------------------------
          // DESBLOQUEOS / REGISTRO
          // ------------------------------------------------------------
          final unlockedFlag = passed ? evaluation.unlockFlagOnPass : evaluation.unlockFlagOnFail;

          if (passed) {
               // aplicar flag asociado si lo tiene
               if (unlockedFlag != null) {
                    _setEvaluationUnlockFlag(unlockedFlag);
               }

               // registrar evaluación completada permanentemente (si no estaba)
               if (!game.completedEvaluations.contains(evaluationId)) {
                    game.completedEvaluations.add(evaluationId);
               }

               // Si es una evaluación integradora, marcar el expediente como integrado (flag)
               if (evaluation.type == EvaluationType.integration) {
                    switch (evaluation.expediente) {
                         case 1:
                              game.flags.exp1Complete = true;
                              break;
                         case 2:
                              game.flags.exp2Complete = true;
                              break;
                         case 3:
                              game.flags.exp3Complete = true;
                              break;
                         case 4:
                              game.flags.exp4Complete = true;
                              break;
                         case 5:
                              game.flags.exp5Complete = true;
                              break;
                         default:
                              break;
                    }
               }

          } else {
               // En fallo: si es un mini-case, cerrarlo y marcarlo en completedMiniCases para evitar reapertura automática
               if (evaluation.type == EvaluationType.miniCase) {
                    game.unlockedEvaluations.remove(evaluationId);
                    game.flags.completedMiniCases.add(evaluationId);
               }

               // Penalización: consumir las acciones restantes del equipo y avanzar turno.
               team.actionPoints = 0;
               nextTurn();
          }

          // ------------------------------------------------------------
          // SINCRONIZAR PROGRESIÓN y desbloqueos (forzar evaluación de disponibilidad)
          // ------------------------------------------------------------
          checkStoryProgress();

          final int currentExpediente = game.currentExpediente;
          final bool expedienteAdvanced = currentExpediente > previousExpediente;

          return EvaluationResult(
               evaluationId: evaluationId,
               correctAnswers: correct,
               totalQuestions: evaluation.questions.length,
               passed: passed,
               moneyChange: moneyChange,
               trustChange: trustChange,
               evidenceObtained: evidence,
               unlockedFlag: unlockedFlag,
               previousExpediente: previousExpediente,
               currentExpediente: currentExpediente,
               expedienteAdvanced: expedienteAdvanced,
          );
     }

     bool _advanceAfterIntegration(String evaluationId) {
          int? nextExpediente;

          switch (evaluationId) {
               case "EVAL_EXP1_INTEGRATION":
                    nextExpediente = 2;
                    break;

               case "EVAL_EXP2_INTEGRATION":
                    nextExpediente = 3;
                    break;

               case "EVAL_EXP3_INTEGRATION":
                    nextExpediente = 4;
                    break;

               case "EVAL_EXP4_INTEGRATION":
                    nextExpediente = 5;
                    break;
          }

          if (nextExpediente == null) {
               return false;
          }

          // Evitar regresar o repetir expediente.
          if (game.currentExpediente >= nextExpediente) {
               return false;
          }

          final previous = game.currentExpediente;

          game.currentExpediente = nextExpediente;

          game.currentNodeId =
          "EXPEDIENTE_$nextExpediente";

          // ------------------------------------------------------------
          // DESBLOQUEAR INTEGRACIÓN DEL NUEVO EXPEDIENTE
          // ------------------------------------------------------------

          final integrationId =
              "EVAL_EXP${nextExpediente}_INTEGRATION";

          if (getEvaluation(integrationId) != null) {
               game.unlockedEvaluations.add(integrationId);
          }

          // ------------------------------------------------------------
          // DESBLOQUEAR EVALUACIÓN FINAL DEL NUEVO EXPEDIENTE
          // ------------------------------------------------------------

          unlockFinalEvaluation(nextExpediente);

          return game.currentExpediente > previous;
     }

     void _updateEvaluationProgress(
         String evaluationId,
         bool passed,
         ) {

          if (!passed) {
               return;
          }

          switch (evaluationId) {

               case "EVAL_EXP1_INTEGRATION":
                    game.flags.evalExp1IntegrationCompleted = true;
                    break;

               case "EVAL_EXP2_INTEGRATION":
                    game.flags.evalExp2IntegrationCompleted = true;
                    break;

               case "EVAL_EXP3_INTEGRATION":
                    game.flags.evalExp3IntegrationCompleted = true;
                    break;

               case "EVAL_EXP4_INTEGRATION":
                    game.flags.evalExp4IntegrationCompleted = true;
                    break;

               case "EVAL_FINAL_EXP1":
                    game.flags.evalExp1FinalCompleted = true;
                    break;

               case "EVAL_FINAL_EXP2":
                    game.flags.evalExp2FinalCompleted = true;
                    break;

               case "EVAL_FINAL_EXP3":
                    game.flags.evalExp3FinalCompleted = true;
                    break;

               case "EVAL_FINAL_EXP4":
                    game.flags.evalExp4FinalCompleted = true;
                    break;

               case "EVAL_FINAL_EXP5":
                    game.flags.evalExp5FinalCompleted = true;
                    break;
          }
     }

     void _markIntegrationCompleted(String evaluationId) {

          switch (evaluationId) {

               case "EVAL_EXP1_INTEGRATION":
                    game.flags.evalExp1IntegrationCompleted = true;
                    game.flags.exp1Complete = true;
                    break;

               case "EVAL_EXP2_INTEGRATION":
                    game.flags.evalExp2IntegrationCompleted = true;
                    game.flags.exp2Complete = true;
                    break;

               case "EVAL_EXP3_INTEGRATION":
                    game.flags.evalExp3IntegrationCompleted = true;
                    game.flags.exp3Complete = true;
                    break;

               case "EVAL_EXP4_INTEGRATION":
                    game.flags.evalExp4IntegrationCompleted = true;
                    game.flags.exp4Integrated = true;
                    game.flags.exp4Complete = true;
                    break;
          }
     }

     void _setEvaluationUnlockFlag(String flag) {

          switch (flag) {

               case "policeUnlocked":
                    game.flags.policeUnlocked = true;
                    break;

               case "raveHouseUnlocked":
                    game.flags.raveHouseUnlocked = true;
                    break;

               case "crimeSceneUnlocked":
                    game.flags.crimeSceneUnlocked = true;
                    break;

               case "warehouseUnlocked":
                    game.flags.warehouseUnlocked = true;
                    break;

               case "omegaQuestionnaireUnlocked":
                    game.flags.omegaQuestionnaireUnlocked = true;
                    break;

               default:
                    break;
          }
     }

     // ============================================================
     // RESET
     // ============================================================

     void resetCase({
          Duration? duration,
     }) {

          game.currentExpediente = 1;

          game.completedActions.clear();

          game.flags.reset();

          game.completedEvaluations.clear();

          game.unlockedEvaluations.clear();

          game.patient.reset();

          for (final team in game.teams) {

               team.actionPoints = 3;

               team.trust = 100;

               team.evidence.clear();

               team.location = Location.hospital;

               team.currentNode = "EXPEDIENTE_1";
          }

          game.roundManager.reset();

          game.caseDuration =
              duration ??
                  const Duration(hours: 1);

          game.caseStartedAt = null;

          game.elapsedBeforePause =
              Duration.zero;

          game.caseStarted = false;
          game.gamePaused = false;
          game.timeExpired = false;
          game.caseFinished = false;

          game.currentNodeId = "EXPEDIENTE_1";
     }

     // ============================================================
     // EVENTOS
     // ============================================================
     GameEvent? checkRandomEvent() {

          final roll =
          random.nextInt(100);

          if (
          !game.flags.patientAwake &&
              !game.flags.patientDead &&
              roll < 12
          ) {

               game.flags.patientAwake = true;

               return randomEvents.firstWhere(
                        (e) =>
                    e.title ==
                        "Paciente despierta",
               );
          }

          if (
          game.flags.policeCalled &&
              !game.flags.phoneTracked &&
              roll < 20
          ) {

               game.flags.phoneTracked = true;

               return randomEvents.firstWhere(
                        (e) =>
                    e.title ==
                        "Teléfono localizado",
               );
          }

          if (
          game.patient.stability < 40 &&
              !game.flags.patientDead &&
              roll < 25
          ) {

               return randomEvents.firstWhere(
                        (e) =>
                    e.title ==
                        "Paciente empeora",
               );
          }

          return null;
     }

     // ============================================================
     // DECISIONES DISPONIBLES
     // ============================================================
     List<Decision> getAvailableDecisions() {

          if (
          game.caseFinished ||
              game.gamePaused
          ) {
               return [];
          }

          return decisions.values.where(
                   (decision) {

                    if (
                    decision.location !=
                        currentTeam.location
                    ) {
                         return false;
                    }

                    // El expediente es global.
                    if (
                    decision.expediente >
                        game.currentExpediente
                    ) {
                         return false;
                    }

                    if (
                    decision.repeat ==
                        DecisionRepeat.once &&
                        game.completedActions.contains(
                             decision.id,
                        )
                    ) {
                         return false;
                    }

                    return decision.isAvailable(game);
               },
          ).toList();
     }

     List<Evaluation> getAvailableEvaluations() {

          if (
          game.caseFinished ||
              game.gamePaused
          ) {
               return [];
          }

          final allEvaluations = [
               ...campaignEvaluations.values,
               ...finalEvaluations.values,
               ...miniCaseEvaluations.values,
          ];

          return allEvaluations.where(
                   (evaluation) {

                    // ----------------------------------------------------------
                    // SOLO MOSTRAR EVALUACIONES DEL EXPEDIENTE ACTUAL
                    // ----------------------------------------------------------

                    if (
                    evaluation.expediente !=
                        game.currentExpediente
                    ) {
                         return false;
                    }

                    // ----------------------------------------------------------
                    // NO MOSTRAR EVALUACIONES YA COMPLETADAS
                    // ----------------------------------------------------------

                    if (
                    game.completedEvaluations.contains(
                         evaluation.id,
                    )
                    ) {
                         return false;
                    }

                    // ----------------------------------------------------------
                    // DEBE ESTAR DESBLOQUEADA
                    // ----------------------------------------------------------

                    return game.unlockedEvaluations.contains(
                         evaluation.id,
                    );
               },
          ).toList();
     }

     // ============================================================
     // UBICACIONES
     // ============================================================
     List<Location> getAvailableLocations() {

          return LocationManager.availableLocations(game);
     }

     DecisionResult travelTo(
         Location location,
         ) {

          if (game.caseFinished) {
               return const DecisionResult(
                    success: false,
                    title: "Caso terminado",
                    message: "La operación ya ha finalizado.",
               );
          }

          if (game.gamePaused) {
               return const DecisionResult(
                    success: false,
                    title: "Juego pausado",
                    message: "Reanuda la operación para continuar.",
               );
          }

          if (checkTimeExpired()) {
               return const DecisionResult(
                    success: false,
                    title: "Tiempo agotado",
                    message: "La operación ha terminado.",
               );
          }

          if (currentTeam.actionPoints <= 0) {
               return const DecisionResult(
                    success: false,
                    title: "Sin acciones",
                    message: "No quedan suficientes puntos de acción.",
               );
          }

          currentTeam.actionPoints--;

          currentTeam.location = location;

          return DecisionResult(
               success: true,
               title: location.label,
               message:
               "El equipo se ha trasladado a ${location.label}.",
          );
     }

     // ============================================================
     // TURNOS
     // ============================================================
     void nextTurn() {

          game.roundManager.nextTurn(
               game.teams.length,
          );
     }

     void endTurn() {

          if (game.caseFinished) {
               return;
          }

          currentTeam.actionPoints = 3;

          nextTurn();
     }

     // ============================================================
     // ESTADO DEL PACIENTE
     // ============================================================
     void checkPatientStatus() {

          if (
          game.patient.stability <= 0
          ) {

               game.patient.stability = 0;

               game.flags.patientDead = true;

               // La muerte bloquea acciones clínicas normales,
               // pero NO termina la campaña.
               //
               // Esto es importante porque EXPEDIENTE 4 todavía
               // puede contener la autopsia.

          } else {

               game.flags.patientDead = false;
          }

          // Estados auxiliares.

          game.flags.patientCritical =
              game.patient.stability <= 25 &&
                  !game.flags.patientDead;

          game.flags.patientStable =
              game.patient.stability >= 70 &&
                  !game.flags.patientDead;
     }

     // ============================================================
     // PROGRESIÓN GLOBAL
     // ============================================================

     void checkStoryProgress() {

          // 1) Intentar desbloquear la evaluación integradora del siguiente expediente
          //    si sus prerrequisitos ya están cumplidos (CampaignProgression.canStartExpediente).
          final nextCandidate = game.currentExpediente + 1;
          if (nextCandidate <= 5 && CampaignProgression.canStartExpediente(game, nextCandidate)) {
               final integrationId = "EVAL_EXP${nextCandidate}_INTEGRATION";
               final integrationEval = getEvaluation(integrationId);
               if (integrationEval != null &&
                   !game.completedEvaluations.contains(integrationId) &&
                   !game.unlockedEvaluations.contains(integrationId)) {
                    game.unlockedEvaluations.add(integrationId);
               }
          }

          // 2) Avanzar expediente de forma controlada según CampaignProgression.
          //    getNextExpediente ya utiliza las reglas (p. ej. requiere completedEvaluations de integradoras).
          final nextExpediente = CampaignProgression.getNextExpediente(game);

          if (nextExpediente > game.currentExpediente && nextExpediente <= 5) {

               // Avanzar al siguiente expediente determinado por la progresión.
               game.currentExpediente = nextExpediente;
               game.currentNodeId = "EXPEDIENTE_$nextExpediente";

               // Desbloquear la evaluación final del expediente (si existe)
               unlockFinalEvaluation(nextExpediente);

               // Asegurar que la integradora del expediente activado esté desbloqueada también
               final integrationId = "EVAL_EXP${nextExpediente}_INTEGRATION";
               if (getEvaluation(integrationId) != null && !game.unlockedEvaluations.contains(integrationId)) {
                    game.unlockedEvaluations.add(integrationId);
               }
          }
     }

     void unlockFinalEvaluation(int expediente) {

          final id =
              "EVAL_FINAL_EXP$expediente";

          if (getEvaluation(id) == null) {
               return;
          }

          game.unlockedEvaluations.add(id);
     }
}