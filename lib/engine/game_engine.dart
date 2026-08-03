import '../models/game_event.dart';
import '../models/game_state.dart';
import '../models/decision.dart';
import '../data/sample_case.dart';
import '../models/story_node.dart';
import 'dart:math';

import '../data/events.dart';

class GameEngine {

  final GameState game;

  final Random random = Random();

  GameEngine(this.game);

  String executeDecision(Decision decision) {

    final team = game.teams[game.currentTurn];

    // Siempre se cobra el dinero
    team.money -= decision.moneyCost;

    bool success =
        random.nextInt(100) < decision.successRate;

    if (success) {

      team.trust += decision.trustChange;

      team.currentNode = decision.nextNode;

      if (decision.evidence != null) {
        team.evidence.add(decision.evidence!);
      }

      team.completedActions.add(decision.id);

      nextTurn();

      return decision.result;

    } else {

      team.trust -= 10;

      if (decision.failNode.isNotEmpty) {
        team.currentNode = decision.failNode;
      }

      nextTurn();

      return decision.failResult;
    }

  }

  GameEvent? getRoundEvent(){

    if(game.round % 2 != 0){

      return null;

    }

    return randomEvents[random.nextInt(randomEvents.length)];

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