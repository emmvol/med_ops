import 'package:flutter/material.dart';

import '../engine/game_engine.dart';
import '../models/game_state.dart';
import '../models/patient.dart';
import '../models/team.dart';

import '../widgets/case_header.dart';
import '../widgets/decision_card.dart';
import '../widgets/evidence_panel.dart';
import '../widgets/info_panel.dart';
import '../widgets/patient_panel.dart';
import '../widgets/result_dialog.dart';
import '../widgets/team_dashboard.dart';

class GameScreen extends StatefulWidget {

  final List<Team> teams;

  const GameScreen({
    super.key,
    required this.teams,
  });

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

        teams: widget.teams,

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

          padding: const EdgeInsets.all(16),

          child: Column(

            children: [

              CaseHeader(

                round: engine.game.roundManager.round,

                currentTeam: engine.currentTeam,

                title: node.title,

              ),

              const SizedBox(height: 12),

              TeamDashboard(

                teams: engine.game.teams,

                currentTurn: engine.game.roundManager.currentTeam,

              ),

              const SizedBox(height: 16),

              Expanded(

                child: Row(

                  children: [

                    Expanded(

                      flex: 3,

                      child: Column(

                        children: [

                          Card(

                            child: Padding(

                              padding: const EdgeInsets.all(20),

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    node.title,

                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,

                                  ),

                                  const SizedBox(height:12),

                                  Text(node.description),

                                ],

                              ),

                            ),

                          ),

                          const SizedBox(height:16),

                          Expanded(

                            child: ListView(

                              children: engine

                                  .getAvailableDecisions()

                                  .map(

                                    (decision) => DecisionCard(

                                  decision: decision,

                                  onTap: () async {

                                    final result =

                                    engine.executeDecision(decision);

                                    await showDialog(

                                      context: context,

                                      builder: (_) => ResultDialog(

                                        result: result,

                                      ),

                                    );

                                    setState(() {});

                                  },

                                ),

                              )

                                  .toList(),

                            ),

                          ),

                          const SizedBox(height: 12),

                          Row(

                            children: [

                              Expanded(

                                child: InfoPanel(

                                  title: "AP",

                                  value: "${team.actionPoints}/3",

                                ),

                              ),

                              const SizedBox(width: 10),

                              Expanded(

                                child: InfoPanel(

                                  title: "Reputación",

                                  value: "${team.trust}",

                                ),

                              ),

                              const SizedBox(width: 10),

                              Expanded(

                                child: InfoPanel(

                                  title: "Fondos",

                                  value: "\$${team.money}",

                                ),

                              ),

                            ],

                          ),

                          const SizedBox(height: 12),

                          SizedBox(

                            width: double.infinity,

                            child: FilledButton.icon(

                              icon: const Icon(Icons.skip_next),

                              label: const Text("Finalizar turno"),

                              onPressed: () {

                                engine.endTurn();

                                final event = engine.checkRandomEvent();

                                if (event != null) {

                                  showDialog(

                                    context: context,

                                    builder: (_) => AlertDialog(

                                      title: Text(event.title),

                                      content: Text(event.description),

                                    ),

                                  );

                                }

                                setState(() {});

                              },

                            ),

                          ),

                        ],

                      ),

                    ),

                    const SizedBox(width:16),

                    SizedBox(

                      width: 320,

                      child: Column(

                        children: [

                          PatientPanel(

                            patient: engine.game.patient,

                          ),

                          const SizedBox(height:16),

                          Expanded(

                            child: EvidencePanel(

                              teams: engine.game.teams,

                            ),

                          ),

                        ],

                      ),

                    ),

                  ],

                ),

              ),

            ],

          ),

        ),

    );

  }

}