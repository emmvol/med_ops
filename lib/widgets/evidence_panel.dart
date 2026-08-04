import 'package:flutter/material.dart';

import '../models/team.dart';

class EvidencePanel extends StatelessWidget {

  final List<Team> teams;

  const EvidencePanel({

    super.key,

    required this.teams,

  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(

              "Evidencias",

              style: TextStyle(

                fontWeight: FontWeight.bold,

                fontSize: 20,

              ),

            ),

            const Divider(),

            Expanded(

              child: ListView(

                children: teams.expand((team){

                  return team.evidence.map(

                        (e)=>ListTile(

                      dense: true,

                      leading: const Icon(Icons.folder),

                      title: Text(e),

                      subtitle: Text(team.codeName),

                    ),

                  );

                }).toList(),

              ),

            )

          ],

        ),

      ),

    );

  }

}