import 'package:flutter/material.dart';

import '../models/decision.dart';

class DecisionCard extends StatelessWidget {

  final Decision decision;

  final VoidCallback onTap;

  const DecisionCard({

    super.key,

    required this.decision,

    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: InkWell(

        onTap: onTap,

        child: Padding(

          padding: const EdgeInsets.all(18),

          child: Row(

            children: [

              CircleAvatar(

                radius: 28,

                child: Icon(decision.icon),

              ),

              const SizedBox(width:20),

              Expanded(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(

                      decision.title,

                      style: const TextStyle(

                        fontWeight: FontWeight.bold,

                        fontSize: 18,

                      ),

                    ),

                    const SizedBox(height:6),

                    Text(decision.description),

                    const SizedBox(height:12),

                    Row(

                      children: [

                        Chip(

                          label: Text(decision.type.name),

                        ),

                        const SizedBox(width:8),

                        Chip(

                          avatar: const Icon(Icons.attach_money),

                          label: Text("${decision.moneyCost}"),

                        ),

                        const SizedBox(width:8),

                        Chip(

                          avatar: const Icon(Icons.schedule),

                          label: Text("${decision.apCost}"),

                        ),

                      ],

                    )

                  ],

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}