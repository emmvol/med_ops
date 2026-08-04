import 'package:flutter/material.dart';

import '../engine/game_engine.dart';
import '../models/game_state.dart';
import '../models/patient.dart';
import '../models/team.dart';

import '../widgets/decision_card.dart';
import '../widgets/info_panel.dart';
import '../widgets/result_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  late final GameEngine engine;

  @override
  void initState() {
    super.initState();

    engine = GameEngine(

      GameState(

        teams: [

          Team(name: "Hospital Alfa"),

          Team(name: "Hospital Bravo"),

          Team(name: "Hospital Charlie"),

        ],

        patient: Patient(),

      ),

    );

  }

  @override
  Widget build(BuildContext context) {

    final node = engine.currentNode;
    final team = engine.currentTeam;

    return Scaffold(

      appBar: AppBar(

        title: const Text("Operación Quimera"),

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                Expanded(

                  child: InfoPanel(

                    title: "Equipo",

                    value: team.name,

                  ),

                ),

                const SizedBox(width: 12),

                Expanded(

                  child: InfoPanel(

                    title: "Confianza",

                    value: "${team.trust}",

                  ),

                ),

                const SizedBox(width: 12),

                Expanded(

                  child: InfoPanel(

                    title: "Fondos",

                    value: "\$${team.money}",

                  ),

                ),

              ],

            ),

            const SizedBox(height: 20),

            Card(

              child: Padding(

                padding: const EdgeInsets.all(20),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(

                      node.title,

                      style: Theme.of(context).textTheme.headlineSmall,

                    ),

                    const SizedBox(height: 12),

                    Text(node.description),

                  ],

                ),

              ),

            ),

            const SizedBox(height: 20),

            Text(

              "Decisiones",

              style: Theme.of(context).textTheme.titleLarge,

            ),

            const SizedBox(height: 10),

            Expanded(

              child: ListView.builder(

                itemCount: engine.getAvailableDecisions().length,

                itemBuilder: (_, index){

                  final decision = engine.getAvailableDecisions()[index];

                  return DecisionCard(

                    decision: decision,

                    onTap: () async{

                      final result =
                      engine.executeDecision(decision);

                      await showDialog(

                        context: context,

                        builder: (_) => ResultDialog(

                          result: result,

                        ),

                      );

                      setState((){});

                    },

                  );

                },

              ),

            ),

          ],

        ),

      ),

    );

  }

}