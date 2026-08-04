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

      !game.completedActions.contains(d.id);

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

Esto es lo que debo continuar con Chat:

Cómo continuo arreglando esto?

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



      !game.completedActions.contains(d.id);



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



GameState está así:

import 'package:med_ops/models/round_manager.dart';



import 'team.dart';

import 'patient.dart';



class GameState {



  List<Team> teams;



  Patient patient;



  int currentTurn;



  int round;



  /// Acciones ya realizadas sobre el caso

  final Set<String> completedActions;



  final RoundManager roundManager;



  GameState({



    required this.teams,



    required this.patient,



    this.currentTurn = 0,



    this.round = 1,



    Set<String>? completedActions,



    RoundManager? roundManager,



  }) :

        completedActions = completedActions ?? {},

        roundManager = roundManager ?? RoundManager();



}



El dashboard cómo o cuál?

import 'package:flutter/material.dart';



import '../models/team.dart';



class TeamDashboard extends StatelessWidget {



  final List<Team> teams;



  final int currentTurn;



  const TeamDashboard({



    super.key,



    required this.teams,



    required this.currentTurn,



  });



  @override

  Widget build(BuildContext context) {



    return SizedBox(



      height: 145,



      child: ListView.builder(



        scrollDirection: Axis.horizontal,



        itemCount: teams.length,



        itemBuilder: (_, index){



          final team = teams[index];



          final active = index == currentTurn;



          return Container(



            width: 220,



            margin: const EdgeInsets.only(right: 12),



            child: Card(



              color: active



                  ? Theme.of(context).colorScheme.primaryContainer



                  : Theme.of(context).cardColor,



              shape: RoundedRectangleBorder(



                borderRadius: BorderRadius.circular(14),



                side: BorderSide(



                  color: active



                      ? Colors.green



                      : Colors.transparent,



                  width: 3,



                ),



              ),



              child: Padding(



                padding: const EdgeInsets.all(12),



                child: Column(



                  crossAxisAlignment: CrossAxisAlignment.start,



                  children: [



                    Text(



                      team.codeName,



                      style: const TextStyle(



                        fontWeight: FontWeight.bold,



                        fontSize: 20,



                      ),



                    ),



                    Text(team.name),



                    Text(team.hospital),



                    const Spacer(),



                    Row(



                      children: [



                        const Icon(Icons.star,size:18),



                        Text("${team.trust}"),



                        const SizedBox(width:12),



                        const Icon(Icons.attach_money,size:18),



                        Text("${team.money}")



                      ],



                    )



                  ],



                ),



              ),



            ),



          );



        },



      ),



    );



  }



}



Y no recuerdo cuál es la barra de expediente