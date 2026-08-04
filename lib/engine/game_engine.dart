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

  Team get currentTeam => game.teams[game.currentTurn];

  StoryNode get currentNode => caseNodes[currentTeam.currentNode]!;

  DecisionResult executeDecision(Decision decision) {

    final team = game.teams[game.currentTurn];

    team.money -= decision.moneyCost;

    final success =
        random.nextInt(100) < decision.successRate;

    if (success) {

      team.trust += decision.trustChange;

      team.currentNode = decision.nextNode;

      team.completedActions.add(decision.id);

      if (decision.evidence != null) {
        team.evidence.add(decision.evidence!);
      }

      final result = DecisionResult(

        success: true,

        title: "Acción completada",

        message: decision.result,

        evidence: decision.evidence,

      );

      nextTurn();

      return result;

    }

    if (decision.failNode.isNotEmpty) {
      team.currentNode = decision.failNode;
    }

    team.trust -= 10;

    final result = DecisionResult(

      success: false,

      title: "La situación se complica",

      message: decision.failResult,

    );

    nextTurn();

    return result;

  }

  GameEvent? getRoundEvent(){

    if(game.round % 2 != 0){

      return null;

    }

    return randomEvents[random.nextInt(randomEvents.length)];

  }

  List<Decision> getAvailableDecisions() {

    final node = getCurrentNode();

    return node.decisions
        .map((id) => decisions[id]!)
        .toList();

  }

  void nextTurn(){

    game.currentTurn++;

    if(game.currentTurn >= game.teams.length){

      game.currentTurn = 0;

      game.round++;

    }

  }

  StoryNode getCurrentNode() {

    final team = game.teams[game.currentTurn];

    return caseNodes[team.currentNode]!;

  }

}