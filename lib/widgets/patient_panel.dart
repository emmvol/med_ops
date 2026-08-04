import 'package:flutter/material.dart';

import '../models/patient.dart';

class PatientPanel extends StatelessWidget {

  final Patient patient;

  const PatientPanel({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Paciente",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const Divider(),

            const ListTile(

              leading: Icon(Icons.person),

              title: Text("Gabriel Ortega"),

              subtitle: Text("22 años"),

            ),

            const SizedBox(height: 10),

            const Chip(
              avatar: Icon(Icons.favorite),
              label: Text("Estado: Grave"),
            ),

            const SizedBox(height: 10),

            const Text(

              "Objetivo:\nMantenerlo con vida para obtener información.",

            ),

          ],

        ),

      ),

    );

  }

}