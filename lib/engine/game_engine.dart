import '../data/decisions.dart';
import '../models/decision_result.dart';
import '../models/game_event.dart';
import '../models/game_state.dart';
import '../models/decision.dart';
import '../data/sample_case.dart';
import '../models/location.dart';
import '../models/story_node.dart';
import 'dart:math';

import '../data/events.dart';
import '../models/team.dart';
import '../services/location_manager.dart';

class GameEngine {

  final GameState game;

  final Random random = Random();

  GameEngine(this.game);

  Team get currentTeam =>
      game.teams[game.roundManager.currentTeam];

  StoryNode get currentNode =>
      caseNodes["EXPEDIENTE_${game.currentExpediente}"]!;

  DecisionResult executeDecision(Decision decision) {

    final team = currentTeam;

    if (team.actionPoints < decision.apCost) {

      return const DecisionResult(
        success: false,
        title: "Sin acciones",
        message: "No quedan suficientes puntos de acción.",
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

    } else {

      team.trust -= 10;

      decision.onFail?.call(game);

    }

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

  GameEvent? checkRandomEvent() {

    final roll = random.nextInt(100);

    if (

    game.flags.patientAwake == false &&

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

  List<Decision> getAvailableDecisions() {

    return decisions.values.where((decision){

      if(decision.location != currentTeam.location){
        return false;
      }

      if(decision.expediente > game.currentExpediente){
        return false;
      }

      if(
      decision.repeat == DecisionRepeat.once &&
          game.completedActions.contains(decision.id)
      ){
        return false;
      }

      return decision.isAvailable(game);

    }).toList();

  }

  List<Location> getAvailableLocations() {
    return LocationManager.availableLocations(game.flags);
  }

  DecisionResult travelTo(Location location){

    if(currentTeam.actionPoints <= 0){

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

      message: location.description,

    );

  }

  void nextTurn(){

    game.roundManager.nextTurn(

      game.teams.length,

    );

  }

  void endTurn() {
    currentTeam.actionPoints = 3;

    nextTurn();
  }

  void checkStoryProgress() {

    switch (game.currentExpediente) {

      case 1:

        if (

        game.flags.patientStable &&
            game.flags.labConfirmed &&
            game.flags.policeCalled &&
            game.flags.foundPhone

        ) {

          game.currentExpediente = 2;

        }

        break;

      case 2:

        if (

        game.flags.phoneTracked &&
            game.flags.raveDiscovered

        ) {

          game.currentExpediente = 3;

        }

        break;

      case 3:

        if (

        game.flags.crimeSceneVisited &&
            game.flags.familyInterviewed

        ) {

          game.currentExpediente = 4;

        }

        break;

      case 4:

        if (

        game.flags.warehouseUnlocked

        ) {

          game.currentExpediente = 5;

        }

        break;

    }

  }
}