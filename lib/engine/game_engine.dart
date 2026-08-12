import 'dart:math';

import '../data/campaign_evaluations.dart';
import '../data/crime_scene_decisions.dart';
import '../data/decisions.dart';
import '../data/hospital_decisions.dart';
import '../data/hospital_expediente2_decisions.dart';
import '../data/hospital_expediente4_decisions.dart';
import '../data/mini_case_evaluations.dart';
import '../data/police_decisions.dart';
import '../data/rave_house_decisions.dart';
import '../data/sample_case.dart';
import '../data/warehouse_decisions.dart';
import '../models/decision.dart';
import '../models/decision_result.dart';
import '../models/evaluation.dart';
import '../models/evaluation_result.dart';
import '../models/game_state.dart';
import '../models/location.dart';
import '../models/story_node.dart';
import '../models/team.dart';
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
          // IMPORTANTE: Asegúrate de importar todos los archivos de decisiones aquí
          final allDecisions = [
               ...decisions.values,
               ...hospitalDecisions.values,
               ...hospitalExpediente2Decisions.values, // <--- Verifica que este mapa tenga las tarjetas
               ...hospitalExpediente4Decisions.values,
               ...policeDecisions.values,
               ...crimeSceneDecisions.values,
               ...raveHouseDecisions.values,
               ...warehouseDecisions.values,
          ];

          print("DEBUG: Buscando tarjeta asociada a evaluación: $evaluationId");

          for (final decision in allDecisions) {
               if (decision.evaluationId == evaluationId) {
                    game.completedActions.add(decision.id);
                    print("SISTEMA: Tarjeta ${decision.id} ocultada con éxito.");
                    return; // Salimos en cuanto encontramos la primera coincidencia
               }
          }

          print("DEBUG WARNING: No se encontró ninguna tarjeta con evaluationId: $evaluationId");
     }

     // CRONÓMETRO

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
          print("DEBUG: Iniciando executeEvaluation para: $evaluationId");

          final evaluation = getEvaluation(evaluationId);
          if (evaluation == null) {
               print("DEBUG ERROR: No se encontró la evaluación $evaluationId");
               throw StateError("Evaluación no encontrada");
          }

          final team = currentTeam;
          int correct = 0;

          for (int i = 0; i < answers.length; i++) {
               if (i < evaluation.questions.length &&
                   answers[i] == evaluation.questions[i].correctIndex) {
                    correct++;
               }
          }

          final bool passed = correct >= evaluation.requiredCorrect;
          print("DEBUG: Resultado Evaluación -> Correctas: $correct. Pasó: $passed");

          if (passed) {
               // 1. Marcar como completada
               game.completedEvaluations.add(evaluationId);

               // 2. Activar Flag (Esto es lo que checkea la 'condition' de la tarjeta)
               if (evaluation.unlockFlagOnPass != null) {
                    print("DEBUG: Activando flag: ${evaluation.unlockFlagOnPass}");
                    _setEvaluationUnlockFlag(evaluation.unlockFlagOnPass!);
               }

               // 3. Ocultar la tarjeta de decisión del menú
               _completeDecisionForEvaluation(evaluationId);

               // 4. Progresión de expediente
               if (evaluation.type == EvaluationType.integration) {
                    _markIntegrationCompleted(evaluationId);
                    _advanceAfterIntegration(evaluationId);
               }
          } else {
               print("DEBUG: Evaluación fallida. Penalizando equipo.");
               team.trust -= 5;
               team.actionPoints = 0;
          }

          if (evaluationId == "EVAL_OMEGA_FINAL") {
               // 1. Guardamos las decisiones específicas del jugador en los flags
               // answers[0] es la ubicación, answers[1] es el método de entrada
               game.flags.omegaQuestionnaireCompleted = true;
               game.flags.omegaCorrectLocationFound = (answers[0] == 2);
               game.flags.omegaEntryBySpecialists = (answers[1] == 1);

               // 2. Marcamos el caso como terminado
               game.caseFinished = true;

               print("SISTEMA: Operación Quimera finalizada. Procesando desenlace...");
          }

          checkStoryProgress();
          return EvaluationResult(
               evaluationId: evaluationId,
               correctAnswers: correct,
               totalQuestions: evaluation.questions.length,
               passed: passed,
               moneyChange: evaluation.moneyReward,
               trustChange: evaluation.trustReward,
               evidenceObtained: [],
               unlockedFlag: passed ? evaluation.unlockFlagOnPass : evaluation.unlockFlagOnFail,
               previousExpediente: game.currentExpediente,
               currentExpediente: game.currentExpediente,
               expedienteAdvanced: false,
          );
     }
// Helper para evitar errores de compilación
     EvaluationResult _buildEmptyResult(String id) => EvaluationResult(
          evaluationId: id, correctAnswers: 0, totalQuestions: 0, passed: true,
          moneyChange: 0, trustChange: 0, evidenceObtained: [], unlockedFlag: null,
          previousExpediente: game.currentExpediente, currentExpediente: game.currentExpediente,
          expedienteAdvanced: false,
     );

     void checkStoryProgress() {
          final currentExp = game.currentExpediente;

          // --- DESBLOQUEO DE INTEGRACIONES (Expedientes 1 a 4) ---
          // Determinamos si el expediente actual cumple los requisitos para abrir su evaluación final
          bool readyForIntegration = false;

          switch (currentExp) {
               case 1:
               // Se desbloquea por flags internos en la decisión EXP1_CLOSE
                    readyForIntegration = game.flags.exp1Complete;
                    break;

               case 2:
               // Todos los minicasos clínicos aprobados
                    readyForIntegration = game.flags.miniCaseAlcoholComplete &&
                        game.flags.miniCaseCocaineComplete &&
                        game.flags.miniCaseCannabisComplete &&
                        game.flags.miniCaseHallucinogensComplete &&
                        game.flags.miniCaseOpioidsComplete &&
                        game.flags.miniCaseBenzosComplete &&
                        game.flags.miniCasePolyComplete;
                    break;

               case 3:
               // Investigación de la Rave House terminada
                    readyForIntegration = game.flags.exp3Complete;
                    break;

               case 4:
               // Interrogatorio realizado (si vive) O Autopsia (si muere) + Escena del Crimen visitada
                    bool medicalDone = game.flags.omegaQuestionnaireUnlocked || game.flags.autopsyCompleted;
                    readyForIntegration = medicalDone && game.flags.crimeSceneEvidenceFound;
                    break;

               case 5:
               // Evidencia final del almacén asegurada
                    readyForIntegration = game.flags.finalEvidenceSecured;
                    break;
          }

          // ID de la evaluación a desbloquear
          String evaluationId = currentExp == 5
              ? "EVAL_OMEGA_FINAL"
              : "EVAL_EXP${currentExp}_INTEGRATION";

          // Si cumplimos requisitos y no estaba desbloqueada, la activamos
          if (readyForIntegration && !game.unlockedEvaluations.contains(evaluationId)) {
               game.unlockedEvaluations.add(evaluationId);
               print("SISTEMA: Desbloqueada evaluación: $evaluationId");
          }
     }

     bool _advanceAfterIntegration(String evaluationId) {
          int? nextExp;
          if (evaluationId == "EVAL_EXP1_INTEGRATION") nextExp = 2;
          else if (evaluationId == "EVAL_EXP2_INTEGRATION") nextExp = 3;
          else if (evaluationId == "EVAL_EXP3_INTEGRATION") nextExp = 4;
          else if (evaluationId == "EVAL_EXP4_INTEGRATION") nextExp = 5;

          if (nextExp == null || game.currentExpediente >= nextExp) return false;

          game.currentExpediente = nextExp;
          game.currentNodeId = "EXPEDIENTE_$nextExp";

          // ACTUALIZACIÓN CRÍTICA: Mueve a los equipos al nuevo nodo
          for (var team in game.teams) {
               team.currentNode = "EXPEDIENTE_$nextExp";
          }

          print("SISTEMA: Avance a Expediente $nextExp confirmado.");
          return true;
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
          // Expediente 1
               case "policeUnlocked": game.flags.policeUnlocked = true; break;

          // Expediente 2 - Minicasos
               case "miniCaseAlcoholComplete": game.flags.miniCaseAlcoholComplete = true; break;
               case "miniCaseCocaineComplete": game.flags.miniCaseCocaineComplete = true; break;
               case "miniCaseCannabisComplete": game.flags.miniCaseCannabisComplete = true; break;
               case "miniCaseHallucinogensComplete": game.flags.miniCaseHallucinogensComplete = true; break;
               case "miniCaseOpioidsComplete": game.flags.miniCaseOpioidsComplete = true; break;
               case "miniCaseBenzosComplete": game.flags.miniCaseBenzosComplete = true; break;
               case "miniCasePolyComplete": game.flags.miniCasePolyComplete = true; break;

          // Expediente 2 - Integración
               case "raveHouseUnlocked": game.flags.raveHouseUnlocked = true; break;

          // Expediente 4
               case "omegaQuestionnaireUnlocked": game.flags.omegaQuestionnaireUnlocked = true; break;

               default:
                    print("ADVERTENCIA: Flag no reconocida: $flag");
                    break;
          }
     }

     // RESET

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

     // DECISIONES DISPONIBLES

     List<Decision> getAvailableDecisions() {
          if (game.caseFinished || game.gamePaused) return [];

          // 1. Unificamos todos los mapas usando un Map para evitar duplicados por ID
          final Map<String, Decision> allPossible = {
               ...decisions,
               ...hospitalDecisions,
               ...hospitalExpediente2Decisions,
               ...hospitalExpediente4Decisions,
               ...policeDecisions,
               ...crimeSceneDecisions,
               ...raveHouseDecisions,
               ...warehouseDecisions,
          };

          return allPossible.values.where((decision) {
               // Filtro de ubicación
               if (decision.location != currentTeam.location) return false;

               // Filtro de expediente
               if (decision.expediente > game.currentExpediente) return false;

               // Filtro de un solo uso
               if (decision.repeat == DecisionRepeat.once &&
                   game.completedActions.contains(decision.id)) {
                    return false;
               }

               return decision.isAvailable(game);
          }).toList();
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

                    // SOLO MOSTRAR EVALUACIONES DEL EXPEDIENTE ACTUAL

                    if (
                    evaluation.expediente !=
                        game.currentExpediente
                    ) {
                         return false;
                    }

                    // NO MOSTRAR EVALUACIONES YA COMPLETADAS

                    if (
                    game.completedEvaluations.contains(
                         evaluation.id,
                    )
                    ) {
                         return false;
                    }

                    // DEBE ESTAR DESBLOQUEADA

                    return game.unlockedEvaluations.contains(
                         evaluation.id,
                    );
               },
          ).toList();
     }

     // UBICACIONES

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

     // TURNOS

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

     // ESTADO DEL PACIENTE

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

     void unlockFinalEvaluation(int expediente) {

          final id =
              "EVAL_FINAL_EXP$expediente";

          if (getEvaluation(id) == null) {
               return;
          }

          game.unlockedEvaluations.add(id);
     }
}