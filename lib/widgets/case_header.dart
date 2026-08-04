import 'package:flutter/material.dart';

import '../models/team.dart';

class CaseHeader extends StatelessWidget {

  final int round;

  final Team currentTeam;

  final String title;

  const CaseHeader({

    super.key,

    required this.round,

    required this.currentTeam,

    required this.title,

  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Row(

          children: [

            const Icon(
              Icons.folder_special,
              size: 40,
            ),

            const SizedBox(width: 16),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(

                    "OPERACIÓN QUIMERA",

                    style: TextStyle(

                      fontWeight: FontWeight.bold,

                      fontSize: 18,

                    ),

                  ),

                  Text(title),

                  Text("Ronda $round"),

                  Text(
                    "Turno: ${currentTeam.codeName} • ${currentTeam.name}",
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