import '../data/decisions.dart';
import '../models/decision_result.dart';
import '../models/game_event.dart';
import '../models/game_state.dart';
import '../models/decision.dart';
import '../data/sample_case.dart';
import '../models/story_node.dart';
import 'dart:math';

import '../data/events.dart';
import '../models/team.dart';

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

  GameEvent? getRoundEvent(){

    if(game.roundManager.round.isOdd){

      return null;

    }

    return randomEvents[

    random.nextInt(randomEvents.length)

    ];

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

  void nextTurn(){

    game.roundManager.nextTurn(

      game.teams.length,

    );

  }
}