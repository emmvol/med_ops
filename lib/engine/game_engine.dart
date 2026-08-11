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

               if (decision.repeat == DecisionRepeat.once) {
                    game.completedActions.add(decision.id);
               }

               if (decision.evidence != null) {
                    team.evidence.add(decision.evidence!);
               }

               decision.onSuccess?.call(game);

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
               game.patient.modifyStability(-5);
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

          unlockFinalEvaluation(
               game.currentExpediente,
          );
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

          if (game.completedEvaluations.contains(evaluationId)) {
               throw StateError(
                    "La evaluación ya fue completada: $evaluationId",
               );
          }

          // Validación de longitud: permitimos respuestas parciales si maxQuestionsToAsk está definido.
          final maxAllowed = evaluation.maxQuestionsToAsk ?? evaluation.questions.length;

          if (answers.length == 0 || answers.length > evaluation.questions.length) {
               throw StateError(
                    "Número de respuestas inválido.",
               );
          }

          if (answers.length > maxAllowed) {
               throw StateError(
                    "Se permiten como máximo $maxAllowed respuestas en esta evaluación.",
               );
          }

          int correct = 0;
          int trustChange = 0;
          int moneyChange = 0;

          final List<String> evidence = [];

          // Evaluar únicamente las preguntas contestadas (asumimos que answers[i] corresponde a question i)
          for (int i = 0; i < answers.length; i++) {

               final question = evaluation.questions[i];

               final answer = answers[i];

               if (
               answer < 0 ||
                   answer >= question.options.length
               ) {
                    throw StateError(
                         "Respuesta inválida en pregunta ${i + 1}.",
                    );
               }

               if (answer == question.correctIndex) {

                    correct++;

                    trustChange += question.trustOnSuccess;
                    moneyChange += question.moneyReward;

                    if (question.evidenceOnSuccess != null) {
                         evidence.add(
                              question.evidenceOnSuccess!,
                         );
                    }

               } else {

                    trustChange -= question.trustOnFail;
                    moneyChange -= question.moneyPenalty;

                    if (question.evidenceOnFail != null) {
                         evidence.add(
                              question.evidenceOnFail!,
                         );
                    }
               }
          }

          final bool passed =
              correct >= evaluation.requiredCorrect;

          trustChange += evaluation.trustReward;
          moneyChange += evaluation.moneyReward;

          // ------------------------------------------------------------
          // APLICAR RESULTADOS
          // ------------------------------------------------------------

          final team = currentTeam;

          team.trust += trustChange;
          team.money += moneyChange;

          for (final item in evidence) {
               team.evidence.add(item);
          }

          // ------------------------------------------------------------
          // DESBLOQUEO
          // ------------------------------------------------------------

          final unlockedFlag = passed
              ? evaluation.unlockFlagOnPass
              : evaluation.unlockFlagOnFail;

          if (unlockedFlag != null) {
               _setEvaluationUnlockFlag(unlockedFlag);
          }

          // ------------------------------------------------------------
          // REGISTRAR EVALUACIÓN
          // ------------------------------------------------------------

          game.completedEvaluations.add(
               evaluationId,
          );

          // Penalización en caso de fallo: coste de oportunidad.
          // Consumir las acciones restantes del equipo y avanzar turno.
          if (!passed) {
               currentTeam.actionPoints = 0;
               nextTurn();
          }

          // ------------------------------------------------------------
          // PROGRESIÓN
          // ------------------------------------------------------------

          checkStoryProgress();

          return EvaluationResult(
               evaluationId: evaluationId,
               correctAnswers: correct,
               totalQuestions: evaluation.questions.length,
               passed: passed,
               moneyChange: moneyChange,
               trustChange: trustChange,
               evidenceObtained: evidence,
               unlockedFlag: unlockedFlag,
          );
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

          return allEvaluations.where((evaluation) {

               if (
               game.completedEvaluations.contains(
                    evaluation.id,
               )
               ) {
                    return false;
               }

               return game.unlockedEvaluations.contains(
                    evaluation.id,
               );

          }).toList();
     }

     // ============================================================
     // UBICACIONES
     // ============================================================
     List<Location> getAvailableLocations() {

          return LocationManager
              .availableLocations(
               game.flags,
          );
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

          final nextExpediente =
          CampaignProgression.getNextExpediente(game);

          if (
          nextExpediente > game.currentExpediente &&
              nextExpediente <= 5
          ) {

               game.currentExpediente =
                   nextExpediente;

               game.currentNodeId =
               "EXPEDIENTE_$nextExpediente";

               unlockFinalEvaluation(
                    nextExpediente,
               );
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