import 'package:flutter/material.dart';

import '../models/team.dart';
import 'intro_screen.dart';

class LobbyScreen extends StatefulWidget {

  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();

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

  @override
  void initState() {

    super.initState();

    addTeam();
    addTeam();
    addTeam();

  }

  void addTeam(){

    names.add(TextEditingController());

    hospitals.add(TextEditingController());

    setState((){});

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Hospitales participantes"),

      ),

      floatingActionButton: Column(

      mainAxisSize: MainAxisSize.min,

      children: [

        FloatingActionButton.small(

          heroTag: "add",

          onPressed: names.length >= aliases.length
              ? null
              : addTeam,

          child: const Icon(Icons.add),

        ),

        const SizedBox(height: 10),

        FloatingActionButton.small(

          heroTag: "remove",

          onPressed: names.length <= 1
              ? null
              : () {

            setState(() {

              names.removeLast();
              hospitals.removeLast();

            });

          },

          child: const Icon(Icons.remove),

        ),

      ],

    ),

      body: ListView.builder(

        padding: const EdgeInsets.all(20),

        itemCount: names.length,

        itemBuilder: (_, index){

          return Card(

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(

                    aliases[index],

                    style: const TextStyle(

                      fontSize: 22,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                  TextField(

                    controller: names[index],

                    decoration: const InputDecoration(

                      labelText: "Nombre del equipo",

                    ),

                  ),

                  TextField(

                    controller: hospitals[index],

                    decoration: const InputDecoration(

                      labelText: "Hospital",

                    ),

                  ),

                ],

              ),

            ),

          );

        },

      ),

      bottomNavigationBar: Padding(

        padding: const EdgeInsets.all(20),

        child: FilledButton(

          onPressed: (){

            Navigator.push(

              context,

              MaterialPageRoute(

                  builder: (_) => IntroScreen(

                    teams: List.generate(

                      names.length,

                          (i) => Team(

                        name: names[i].text.isEmpty
                            ? "Equipo ${aliases[i]}"
                            : names[i].text,

                        hospital: hospitals[i].text.isEmpty
                            ? "Hospital General"
                            : hospitals[i].text,

                        codeName: aliases[i],

                      ),

                    ),

                  ),

              ),

            );

          },

          child: const Text("Iniciar operación"),

        ),

      ),

    );

  }

}