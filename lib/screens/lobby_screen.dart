import 'package:flutter/material.dart';

import '../models/team.dart';
import 'intro_screen.dart';

class LobbyScreen extends StatefulWidget {

  const LobbyScreen({
    super.key,
  });

  @override
  State<LobbyScreen> createState() =>
      _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {

  final List<TextEditingController> names = [];
  final List<TextEditingController> hospitals = [];

  final aliases = [
    "Alfa",
    "Bravo",
    "Charlie",
    "Delta",
    "Echo",
    "Foxtrot",
  ];

  // ============================================================
  // DURACIÓN DEL CASO
  // ============================================================

  /// Duración seleccionada en minutos.
  ///
  /// Valor predeterminado: 60 minutos.
  int caseDurationMinutes = 60;

  @override
  void initState() {

    super.initState();

    addTeam();
    addTeam();
    addTeam();
  }

  @override
  void dispose() {

    for (final controller in names) {
      controller.dispose();
    }

    for (final controller in hospitals) {
      controller.dispose();
    }

    super.dispose();
  }

  void addTeam() {

    names.add(
      TextEditingController(),
    );

    hospitals.add(
      TextEditingController(),
    );

    setState(() {});
  }

  String get durationLabel {

    final hours = caseDurationMinutes ~/ 60;
    final minutes = caseDurationMinutes % 60;

    if (hours == 0) {
      return "$minutes minutos";
    }

    if (minutes == 0) {
      return hours == 1
          ? "1 hora"
          : "$hours horas";
    }

    return hours == 1
        ? "1 hora $minutes min"
        : "$hours horas $minutes min";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Hospitales participantes",
        ),
      ),

      floatingActionButton: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          FloatingActionButton.small(

            heroTag: "add",

            onPressed:
            names.length >= aliases.length
                ? null
                : addTeam,

            child: const Icon(
              Icons.add,
            ),
          ),

          const SizedBox(height: 10),

          FloatingActionButton.small(

            heroTag: "remove",

            onPressed:
            names.length <= 1
                ? null
                : () {

              setState(() {

                names
                    .removeLast();

                hospitals
                    .removeLast();
              });
            },

            child: const Icon(
              Icons.remove,
            ),
          ),
        ],
      ),

      body: ListView(

        padding:
        const EdgeInsets.all(20),

        children: [

          // ======================================================
          // DURACIÓN DE LA OPERACIÓN
          // ======================================================

          Card(

            child: Padding(

              padding:
              const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Tiempo de operación",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Inteligencia ha determinado el tiempo disponible para localizar y detener la amenaza.",
                  ),

                  const SizedBox(height: 16),

                  Row(

                    children: [

                      const Icon(
                        Icons.timer,
                      ),

                      const SizedBox(width: 10),

                      Expanded(

                        child: Text(
                          durationLabel,
                          style:
                          const TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(

                        tooltip:
                        "Restablecer a 1 hora",

                        onPressed: () {

                          setState(() {
                            caseDurationMinutes =
                            60;
                          });
                        },

                        icon: const Icon(
                          Icons.restart_alt,
                        ),
                      ),
                    ],
                  ),

                  Slider(

                    min: 60,

                    max: 240,

                    divisions: 12,

                    value:
                    caseDurationMinutes
                        .toDouble(),

                    label:
                    durationLabel,

                    onChanged:
                        (value) {

                      setState(() {

                        caseDurationMinutes =
                            value.round();
                      });
                    },
                  ),

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                    children: const [

                      Text("1 hora"),

                      Text("4 horas"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // EQUIPOS
          // ======================================================

          ...List.generate(

            names.length,

                (index) {

              return Card(

                child: Padding(

                  padding:
                  const EdgeInsets.all(16),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      Text(

                        aliases[index],

                        style:
                        const TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      TextField(

                        controller:
                        names[index],

                        decoration:
                        const InputDecoration(
                          labelText:
                          "Nombre del equipo",
                        ),
                      ),

                      TextField(

                        controller:
                        hospitals[index],

                        decoration:
                        const InputDecoration(
                          labelText:
                          "Hospital",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar:
      Padding(

        padding:
        const EdgeInsets.all(20),

        child: FilledButton(

          onPressed: () {

            final teams =
            List.generate(

              names.length,

                  (i) => Team(

                name:
                names[i].text.isEmpty
                    ? "Equipo ${aliases[i]}"
                    : names[i].text,

                hospital:
                hospitals[i].text.isEmpty
                    ? "Hospital General"
                    : hospitals[i].text,

                codeName:
                aliases[i],
              ),
            );

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (_) =>
                    IntroScreen(

                      teams: teams,

                      caseDuration:
                      Duration(
                        minutes:
                        caseDurationMinutes,
                      ),
                    ),
              ),
            );
          },

          child:
          const Text(
            "Iniciar operación",
          ),
        ),
      ),
    );
  }
}