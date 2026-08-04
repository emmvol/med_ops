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