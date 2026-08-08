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

  DateTime? _lastPatientDecay;

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

    if (checkTimeExpired()) {
      return const DecisionResult(
        success: false,
        title: "Tiempo agotado",
        message: "El tiempo disponible para la operación ha terminado.",
      );
    }

    // El tiempo afecta al paciente progresivamente.
    _applyPatientTimePressure();

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

      // El fracaso tiene una penalización moderada.
      // No queremos que una sola mala decisión destruya una partida.
      team.trust -= 5;

      decision.onFail?.call(game);
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
    );
  }

  // ============================================================
  // PRESIÓN TEMPORAL SOBRE EL PACIENTE
  // ============================================================

  void _applyPatientTimePressure() {

    if (
    !game.caseStarted ||
        game.gamePaused ||
        game.caseFinished ||
        game.flags.patientDead
    ) {
      return;
    }

    final now = DateTime.now();

    _lastPatientDecay ??= now;

    final elapsed =
    now.difference(_lastPatientDecay!);

    // La estabilidad cae lentamente con el tiempo real.
    //
    // Esto evita que una partida larga tenga automáticamente
    // que matar al paciente por cantidad de decisiones.
    //
    // 1 punto cada 60 segundos aproximadamente.

    final minutes = elapsed.inMinutes;

    if (minutes <= 0) {
      return;
    }

    game.patient.modifyStability(-minutes);

    _lastPatientDecay =
        _lastPatientDecay!.add(
          Duration(minutes: minutes),
        );

    checkPatientStatus();
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

    _lastPatientDecay =
        DateTime.now();

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

    _lastPatientDecay =
        DateTime.now();

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

    _lastPatientDecay =
        DateTime.now();

    game.gamePaused = false;
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

    game.patient.reset();

    for (final team in game.teams) {

      team.actionPoints = 3;

      team.trust = 100;

      team.evidence.clear();

      team.location =
          Location.hospital;

      team.currentNode =
      "EXPEDIENTE_1";
    }

    game.roundManager.reset();

    game.caseDuration =
        duration ??
            const Duration(hours: 1);

    game.caseStartedAt = null;

    game.elapsedBeforePause =
        Duration.zero;

    _lastPatientDecay = null;

    game.caseStarted = false;
    game.gamePaused = false;
    game.timeExpired = false;
    game.caseFinished = false;

    game.currentNodeId =
    "EXPEDIENTE_1";
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

    switch (game.currentExpediente) {

      case 1:

        if (game.flags.exp1Complete) {
          game.currentExpediente = 2;
        }

        break;

      case 2:

        if (game.flags.exp2Complete) {
          game.currentExpediente = 3;
        }

        break;

      case 3:

        if (game.flags.exp3Complete) {
          game.currentExpediente = 4;
        }

        break;

      case 4:

        if (game.flags.exp4Complete) {
          game.currentExpediente = 5;
        }

        break;

      case 5:
        break;
    }
  }
}