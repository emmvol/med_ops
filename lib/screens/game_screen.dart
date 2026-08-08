import 'dart:async';

import 'package:flutter/material.dart';

import '../engine/game_engine.dart';
import '../models/game_state.dart';
import '../models/location.dart';
import '../models/patient.dart';
import '../models/team.dart';

import '../widgets/case_header.dart';
import '../widgets/decision_card.dart';
import '../widgets/evidence_panel.dart';
import '../widgets/info_panel.dart';
import '../widgets/patient_panel.dart';
import '../widgets/result_dialog.dart';
import '../widgets/team_dashboard.dart';

import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {

  final List<Team> teams;

  final GameEngine? existingEngine;

  final Duration? caseDuration;

  const GameScreen({
    super.key,
    required this.teams,
    this.caseDuration,
    this.existingEngine,
  });

  @override
  State<GameScreen> createState() =>
      _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  late final GameEngine engine;

  Timer? _timer;

  // ============================================================
  // INICIALIZACIÓN
  // ============================================================

  @override
  void initState() {

    super.initState();

    engine = widget.existingEngine ??
        GameEngine(
          GameState(
            teams: widget.teams,
            patient: Patient(),
            caseDuration:
            widget.caseDuration ??
                const Duration(hours: 1),
          ),
        );

    if (!engine.game.caseStarted) {
      engine.startCase();
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _updateTimer(),
    );
  }

  // ============================================================
  // CRONÓMETRO
  // ============================================================

  void _updateTimer() {

    if (!mounted) {
      return;
    }

    if (engine.checkTimeExpired()) {

      _timer?.cancel();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameOverScreen(
            engine: engine,
          ),
        ),
      );

      return;
    }

    setState(() {});
  }

  // ============================================================
  // PAUSA
  // ============================================================

  Future<void> _showPauseMenu() async {

    if (engine.game.gamePaused) {
      return;
    }

    engine.pauseGame();

    if (!mounted) {
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,

      builder: (_) => AlertDialog(

        title: const Row(
          children: [
            Icon(Icons.pause_circle_outline),
            SizedBox(width: 10),
            Text("Operación pausada"),
          ],
        ),

        content: const Text(
          "El cronómetro se encuentra detenido. "
              "Ninguna acción podrá realizarse hasta reanudar la operación.",
        ),

        actions: [

          FilledButton.icon(

            icon: const Icon(Icons.play_arrow),

            label: const Text("Reanudar"),

            onPressed: () {

              engine.resumeGame();

              Navigator.pop(context);

              setState(() {});
            },
          ),

        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {

    final node = engine.currentNode;
    final team = engine.currentTeam;

    return Scaffold(

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(

        title: const Text(
          "Operación Quimera",
        ),

        actions: [

          // ----------------------------------------------------
          // TIEMPO
          // ----------------------------------------------------

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),

            child: Center(

              child: Row(

                children: [

                  Icon(
                    engine.isTimeCritical
                        ? Icons.warning_amber
                        : Icons.timer,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    engine.formattedRemainingTime,

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,

                      color:
                      engine.isTimeCritical
                          ? Colors.red
                          : null,
                    ),
                  ),

                ],
              ),
            ),
          ),

          // ----------------------------------------------------
          // PAUSA
          // ----------------------------------------------------

          IconButton(

            tooltip: "Pausar operación",

            icon: const Icon(
              Icons.pause,
            ),

            onPressed:
            engine.game.gamePaused
                ? null
                : _showPauseMenu,
          ),

          const SizedBox(width: 6),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            // ==================================================
            // ENCABEZADO DEL CASO
            // ==================================================

            CaseHeader(

              round:
              engine.game.roundManager.round,

              currentTeam:
              engine.currentTeam,

              expediente:
              node.expediente,

              title:
              node.title,

              location:
              team.location.label,
            ),

            const SizedBox(height: 12),

            // ==================================================
            // TIEMPO
            // ==================================================

            Card(

              child: Padding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                child: Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    const Row(
                      children: [

                        Icon(
                          Icons.timer,
                        ),

                        SizedBox(width: 8),

                        Text(
                          "Tiempo restante",
                        ),
                      ],
                    ),

                    Text(
                      engine.formattedRemainingTime,

                      style: TextStyle(

                        fontSize: 22,

                        fontWeight:
                        FontWeight.bold,

                        color:
                        engine.isTimeCritical
                            ? Colors.red
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // EQUIPOS
            // ==================================================

            TeamDashboard(

              teams:
              engine.game.teams,

              currentTurn:
              engine.game.roundManager.currentTeam,
            ),

            const SizedBox(height: 16),

            // ==================================================
            // VIAJAR
            // ==================================================

            Align(

              alignment:
              Alignment.centerRight,

              child: OutlinedButton.icon(

                icon:
                const Icon(Icons.map),

                label:
                const Text("Viajar"),

                onPressed:
                engine.game.gamePaused
                    ? null
                    : () async {

                  final location =
                  await showDialog<Location>(

                    context:
                    context,

                    builder: (_) =>
                        AlertDialog(

                          title:
                          const Text(
                            "Seleccionar ubicación",
                          ),

                          content:
                          Column(

                            mainAxisSize:
                            MainAxisSize.min,

                            children: engine
                                .getAvailableLocations()
                                .map(

                                  (loc) =>
                                  ListTile(

                                    leading:
                                    const Icon(
                                      Icons.place,
                                    ),

                                    title:
                                    Text(
                                      loc.label,
                                    ),

                                    onTap: () =>
                                        Navigator.pop(
                                          context,
                                          loc,
                                        ),
                                  ),
                            )
                                .toList(),
                          ),
                        ),
                  );

                  if (location != null) {

                    final result =
                    engine.travelTo(
                      location,
                    );

                    if (mounted) {

                      await showDialog(
                        context: context,

                        builder: (_) =>
                            ResultDialog(
                              result:
                              result,
                            ),
                      );
                    }

                    setState(() {});
                  }
                },
              ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // CONTENIDO PRINCIPAL
            // ==================================================

            Expanded(

              child: Row(

                children: [

                  // ============================================
                  // COLUMNA PRINCIPAL
                  // ============================================

                  Expanded(

                    flex: 3,

                    child: Column(

                      children: [

                        // ----------------------------------------
                        // EXPEDIENTE
                        // ----------------------------------------

                        Card(

                          child: Padding(

                            padding:
                            const EdgeInsets.all(20),

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(

                                  node.title,

                                  style:
                                  Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                Text(
                                  node.description,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // ----------------------------------------
                        // DECISIONES
                        // ----------------------------------------

                        Expanded(

                          child: ListView(

                            children: engine
                                .getAvailableDecisions()
                                .map(

                                  (decision) =>
                                  DecisionCard(

                                    decision:
                                    decision,

                                    onTap: () async {

                                      final result =
                                      engine
                                          .executeDecision(
                                        decision,
                                      );

                                      await showDialog(

                                        context:
                                        context,

                                        builder: (_) =>
                                            ResultDialog(
                                              result:
                                              result,
                                            ),
                                      );

                                      setState(() {});
                                    },
                                  ),
                            )
                                .toList(),
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        // ----------------------------------------
                        // INFORMACIÓN DEL EQUIPO
                        // ----------------------------------------

                        Row(

                          children: [

                            Expanded(

                              child: InfoPanel(

                                title: "AP",

                                value:
                                "${team.actionPoints}/3",
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(

                              child: InfoPanel(

                                title:
                                "Reputación",

                                value:
                                "${team.trust}",
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(

                              child: InfoPanel(

                                title:
                                "Fondos",

                                value:
                                "\$${team.money}",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        // ----------------------------------------
                        // FINALIZAR TURNO
                        // ----------------------------------------

                        SizedBox(

                          width:
                          double.infinity,

                          child:
                          FilledButton.icon(

                            icon:
                            const Icon(
                              Icons.skip_next,
                            ),

                            label:
                            const Text(
                              "Finalizar turno",
                            ),

                            onPressed:
                            engine.game.gamePaused
                                ? null
                                : () {

                              engine.endTurn();

                              final event =
                              engine
                                  .checkRandomEvent();

                              if (event !=
                                  null) {

                                showDialog(

                                  context:
                                  context,

                                  builder:
                                      (_) =>
                                      AlertDialog(

                                        title:
                                        Text(
                                          event.title,
                                        ),

                                        content:
                                        Text(
                                          event.description,
                                        ),
                                      ),
                                );
                              }

                              setState(
                                    () {},
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 16,
                  ),

                  // ============================================
                  // PANEL DERECHO
                  // ============================================

                  SizedBox(

                    width: 320,

                    child: Column(

                      children: [

                        if (
                        team.location ==
                            Location.hospital
                        )
                          PatientPanel(

                            patient:
                            engine.game.patient,
                          ),

                        const SizedBox(
                          height: 16,
                        ),

                        Expanded(

                          child:
                          EvidencePanel(

                            teams:
                            engine.game.teams,
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

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {

    _timer?.cancel();

    super.dispose();
  }
}