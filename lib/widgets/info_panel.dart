import 'package:flutter/material.dart';

class InfoPanel extends StatelessWidget {

  final String title;
  final String value;

  const InfoPanel({

    super.key,

    required this.title,

    required this.value,

  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(14),

        child: Column(

          children: [

            Text(title),

            const SizedBox(height: 8),

            Text(

              value,

              style: const TextStyle(

                fontSize: 20,

                fontWeight: FontWeight.bold,

              ),

            ),

          ],

        ),

      ),

    );

  }

}