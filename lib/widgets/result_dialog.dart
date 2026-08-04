import 'package:flutter/material.dart';

import '../models/decision_result.dart';

class ResultDialog extends StatelessWidget {

  final DecisionResult result;

  const ResultDialog({

    super.key,

    required this.result,

  });

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: Text(result.title),

      content: Column(

        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(result.message),

          if(result.evidence != null)...[

            const SizedBox(height: 16),

            const Text(

              "Nueva evidencia",

              style: TextStyle(

                fontWeight: FontWeight.bold,

              ),

            ),

            Text(result.evidence!),

          ],

        ],

      ),

      actions: [

        FilledButton(

          onPressed: (){

            Navigator.pop(context);

          },

          child: const Text("Continuar"),

        ),

      ],

    );

  }

}