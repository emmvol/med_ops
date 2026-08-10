import 'package:flutter/material.dart';

import '../models/patient.dart';

class PatientPanel extends StatelessWidget {
  final Patient patient;

  const PatientPanel({
    super.key,
    required this.patient,
  });

  // ============================================================
  // ESTADO DEL PACIENTE
  // ============================================================

  String get statusLabel {
    switch (patient.status) {
      case PatientStatus.stable:
        return "Estable";

      case PatientStatus.serious:
        return "Grave";

      case PatientStatus.critical:
        return "Crítico";

      case PatientStatus.dead:
        return "Fallecido";
    }
  }

  IconData get statusIcon {
    switch (patient.status) {
      case PatientStatus.stable:
        return Icons.check_circle;

      case PatientStatus.serious:
        return Icons.warning;

      case PatientStatus.critical:
        return Icons.error;

      case PatientStatus.dead:
        return Icons.cancel;
    }
  }

  Color get statusColor {
    switch (patient.status) {
      case PatientStatus.stable:
        return Colors.green;

      case PatientStatus.serious:
        return Colors.orange;

      case PatientStatus.critical:
        return Colors.red;

      case PatientStatus.dead:
        return Colors.grey;
    }
  }

  String get objective {
    switch (patient.status) {
      case PatientStatus.stable:
        return "Mantener estabilidad y continuar la investigación.";

      case PatientStatus.serious:
        return "Mantenerlo con vida y continuar la evaluación.";

      case PatientStatus.critical:
        return "Estabilizar al paciente de forma prioritaria.";

      case PatientStatus.dead:
        return "Determinar causa de muerte y continuar la investigación médico-legal.";
    }
  }

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
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.person),
              title: Text("Gabriel Ortega"),
              subtitle: Text("22 años"),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // ESTADO
            // ==================================================

            Chip(
              avatar: Icon(
                statusIcon,
                color: statusColor,
              ),
              label: Text(
                "Estado: $statusLabel",
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // ESTABILIDAD
            // ==================================================

            Text(
              "Estabilidad: ${patient.stability}/100",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            LinearProgressIndicator(
              value: patient.stability / 100,
              minHeight: 8,
            ),

            const SizedBox(height: 12),

            // ==================================================
            // OBJETIVO
            // ==================================================

            Text(
              "Objetivo:\n$objective",
            ),
          ],
        ),
      ),
    );
  }
}