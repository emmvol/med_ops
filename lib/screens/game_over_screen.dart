import 'package:flutter/material.dart';

import '../engine/game_engine.dart';
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

    return Scaffold(

      body: Center(

        child: Padding(

          padding: const EdgeInsets.all(32),

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

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

              Text(
                timeExpired
                    ? "La red de distribución no fue localizada dentro del tiempo disponible. Las autoridades no lograron impedir la siguiente distribución y los hospitales comienzan a recibir nuevos pacientes intoxicados."
                    : "La operación ha terminado.",
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