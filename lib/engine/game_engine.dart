import 'dart:math';

import '../data/decisions.dart';
import '../data/events.dart';
import '../data/sample_case.dart';
import '../models/decision.dart';
import '../models/decision_result.dart';
import '../models/game_event.dart';
import '../models/game_state.dart';
import '../models/location.dart';
import '../models/story_node.dart';
import '../models/team.dart';
import '../services/location_manager.dart';

class GameEngine {

  final GameState game;

  final Random random = Random();

  GameEngine(this.game);

  // ============================================================
  // EQUIPO / HISTORIA
  // ============================================================

  Team get currentTeam =>
      game.teams[game.roundManager.currentTeam];

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

    if (checkTimeExpired()) {

      return const DecisionResult(
        success: false,
        title: "Tiempo agotado",
        message: "El tiempo disponible para la operación ha terminado.",
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

    team.actionPoints -= decision.apCost;
    team.money -= decision.moneyCost;

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

      if (decision.nextNode != null) {
        game.currentNodeId = decision.nextNode!;
      }

    } else {

      team.trust -= 10;

      decision.onFail?.call(game);

      if (decision.failNextNode != null) {
        game.currentNodeId = decision.failNextNode!;
      }

    }

    checkPatientStatus();
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

    );
  }

  // ============================================================
  // CRONÓMETRO
  // ============================================================

  Duration get remainingTime {

    if (!game.caseStarted) {
      return game.caseDuration;
    }

    Duration elapsed = game.elapsedBeforePause;

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

    final remaining = remainingTime;

    return remaining <= const Duration(minutes: 15);
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

  /// Agrega 15 minutos para continuar la partida
  /// después de agotar el tiempo.
  void extendCaseBy15Minutes() {

    if (!game.timeExpired) {
      return;
    }

    game.caseDuration +=
    const Duration(minutes: 15);

    game.timeExpired = false;
    game.caseFinished = false;

    game.caseStartedAt = DateTime.now();

    game.gamePaused = false;
  }

  // ============================================================
  // REINICIAR CASO
  // ============================================================

  void resetCase({
    Duration? duration,
  }) {

    game.currentExpediente = 1;

    game.completedActions.clear();

    game.flags.reset();

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

    final roll = random.nextInt(100);

    if (
    !game.flags.patientAwake &&
        roll < 12
    ) {

      game.flags.patientAwake = true;

      return randomEvents.firstWhere(
            (e) => e.title == "Paciente despierta",
      );
    }

    if (
    game.flags.policeCalled &&
        !game.flags.phoneTracked &&
        roll < 20
    ) {

      game.flags.phoneTracked = true;

      return randomEvents.firstWhere(
            (e) => e.title == "Teléfono localizado",
      );
    }

    if (
    game.patient.stability < 40 &&
        roll < 25
    ) {

      return randomEvents.firstWhere(
            (e) => e.title == "Paciente empeora",
      );
    }

    return null;
  }

  // ============================================================
  // DECISIONES DISPONIBLES
  // ============================================================

  List<Decision> getAvailableDecisions() {

    if (game.caseFinished ||
        game.gamePaused) {
      return [];
    }

    return decisions.values.where((decision) {

      if (
      decision.location !=
          currentTeam.location
      ) {
        return false;
      }

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
      message: "El equipo se ha trasladado a ${location.label}.",
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

    if (game.patient.stability <= 0) {
      game.patient.stability = 0;
      game.flags.patientDead = true;
    } else {
      game.flags.patientDead = false;
    }
  }

  // ============================================================
  // PROGRESIÓN DE HISTORIA
  // ============================================================

  void checkStoryProgress() {

    switch (game.currentExpediente) {

    // ============================================================
    // EXPEDIENTE 1 → EXPEDIENTE 2
    // Hospital → Policía
    // ============================================================

      case 1:

        if (
        game.flags.policeCalled &&
            game.flags.foundPhone
        ) {
          game.currentExpediente = 2;
        }

        break;

    // ============================================================
    // EXPEDIENTE 2 → EXPEDIENTE 3
    // Investigación → Casa del Rave
    // ============================================================

      case 2:

        if (
        game.flags.raveHouseSuspected
        ) {
          game.currentExpediente = 3;
        }

        break;

    // ============================================================
    // EXPEDIENTE 3 → EXPEDIENTE 4
    // Casa del Rave → Escena del crimen
    // ============================================================

      case 3:

        if (
        game.flags.crimeSceneVisited
        ) {
          game.currentExpediente = 4;
        }

        break;

    // ============================================================
    // EXPEDIENTE 4 → EXPEDIENTE 5
    // Escena del crimen → Warehouse
    // ============================================================

      case 4:

        if (
        game.flags.warehouseUnlocked
        ) {
          game.currentExpediente = 5;
        }

        break;

    // ============================================================
    // EXPEDIENTE 5
    // FINAL
    // ============================================================

      case 5:
        break;
    }
  }
}