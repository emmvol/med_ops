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

  StoryNode get currentNode => caseNodes[currentTeam.currentNode]!;

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

    final success = random.nextInt(100) < decision.successRate;

    if (success) {

      team.trust += decision.trustChange;

      team.currentNode = decision.nextNode;

      if (decision.unique) {
        game.completedActions.add(decision.id);
      }

      if (decision.evidence != null) {
        team.evidence.add(decision.evidence!);
      }

      if (decision.id == 'CALL_POLICE') {
        game.flags.policeCalled = true;
        game.flags.policeTrust = true;
      }

      if (decision.id == 'BACKPACK') {
        game.flags.raveDiscovered = true;
      }

      return DecisionResult(

        success: true,

        title: "Acción completada",

        message: decision.result,

        evidence: decision.evidence,

      );

    }

    if (decision.failNode.isNotEmpty) {
      team.currentNode = decision.failNode;
    }

    team.trust -= 10;

    return DecisionResult(

      success: false,

      title: "La situación se complica",

      message: decision.failResult,

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

    final node = currentNode;

    return node.decisions

        .map((id) => decisions[id]!)

        .where(
          (decision) =>
      !decision.unique ||
          !game.completedActions.contains(decision.id),
    )

        .toList();

  }

  List<Location> getAvailableLocations() {
    return LocationManager.availableLocations(game.flags);
  }

  void travelTo(Location location) {

    if(currentTeam.actionPoints <= 0){
      return;
    }

    currentTeam.actionPoints--;

    currentTeam.location = location;

    switch(location){

      case Location.hospital:
        currentTeam.currentNode = "START";
        break;

      case Location.police:
        currentTeam.currentNode = "POLICE_HQ";
        break;

      case Location.crimeScene:
        currentTeam.currentNode = "CRIME_SCENE";
        break;

      case Location.raveHouse:
        currentTeam.currentNode = "RAVE_HOUSE";
        break;

      case Location.warehouse:
        currentTeam.currentNode = "WAREHOUSE_ENTRY";
        break;
    }

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
}