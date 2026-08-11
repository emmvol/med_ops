import 'package:flutter/material.dart';

import '../engine/game_engine.dart';
import '../services/finalizer.dart';
import 'game_screen.dart';
import 'lobby_screen.dart';

class GameOverScreen extends StatelessWidget {

  final GameEngine engine;

  const GameOverScreen({
    super.key,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {

    final timeExpired = engine.game.timeExpired;
    final finalOutcome = Finalizer.computeFinalOutcome(engine.game);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                timeExpired
                    ? Icons.timer_off
                    : Icons.warning_amber,
                size: 80,
              ),

              const SizedBox(height: 24),

              Text(
                timeExpired
                    ? "TIEMPO AGOTADO"
                    : "OPERACIÓN FINALIZADA",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              if (!timeExpired)
                Column(
                  children: [
                    Text(
                      "Desenlace: ${finalOutcome.endingId}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      finalOutcome.patientAlive ? "El paciente sobrevivió." : "El paciente no sobrevivió.",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Ganadores: Reputación: ${finalOutcome.firstTrustTeam} • Dinero: ${finalOutcome.firstMoneyTeam} • Evidencias: ${finalOutcome.firstEvidenceTeam}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    // Listado sencillo de puntajes
                    ...finalOutcome.scoresByTeam.entries.map((e) {
                      final name = e.key;
                      final scores = e.value;
                      return Text("$name — Trust: ${scores['trust']} • Money: ${scores['money']} • Evidence: ${scores['evidence']}");
                    }).toList(),
                  ],
                )
              else
                Text(
                  "La red de distribución no fue localizada dentro del tiempo disponible. Revisa las decisiones y las evaluaciones realizadas.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),

              const SizedBox(height: 40),

              if (timeExpired)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add_alarm),
                    label: const Text(
                      "Continuar operación (+15 min)",
                    ),
                    onPressed: () {
                      engine.extendCaseBy15Minutes();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(
                            teams: engine.game.teams,
                            existingEngine: engine,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const LobbyScreen(),
                      ),
                          (_) => false,
                    );
                  },
                  child: const Text(
                    "Terminar operación",
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}