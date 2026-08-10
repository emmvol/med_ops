import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';
import '../models/location.dart';

final Map<String, Decision> hospitalExpediente4Decisions = {

  // ============================================================
  // AUTOPSIA
  // ============================================================

  "EXP4_AUTOPSY_REQUEST": Decision(
    id: "EXP4_AUTOPSY_REQUEST",
    expediente: 4,
    title: "Solicitar autopsia médico-legal",
    description:
    "El paciente índice falleció durante la investigación. "
        "Solicitar estudio postmortem para determinar causa y mecanismo de muerte.",
    icon: Icons.biotech,
    type: DecisionType.legal,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 2,
    moneyCost: 300,
    trustChange: 15,
    successRate: 100,

    result:
    "La autopsia es autorizada y se inicia el estudio médico-legal.",

    condition: (game) =>
    game.currentExpediente >= 4 &&
        game.flags.patientDead &&
        !game.flags.autopsyRequested,

    onSuccess: (game) {
      game.flags.autopsyRequested = true;
      game.flags.autopsyUnlocked = true;
    },
  ),

  "EXP4_AUTOPSY": Decision(
    id: "EXP4_AUTOPSY",
    expediente: 4,
    title: "Realizar autopsia",
    description:
    "Analizar los hallazgos postmortem y relacionarlos con los resultados toxicológicos.",
    icon: Icons.medical_information,
    type: DecisionType.legal,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 2,
    moneyCost: 400,
    trustChange: 20,
    successRate: 100,

    result:
    "Los hallazgos postmortem son compatibles con una intoxicación "
        "por una combinación de sustancias. La información permite "
        "comparar el fallecimiento con los casos posteriores.",

    evidence:
    "Hallazgos de autopsia médico-legal",

    condition: (game) =>
    game.flags.patientDead &&
        game.flags.autopsyRequested &&
        !game.flags.autopsyCompleted,

    onSuccess: (game) {
      game.flags.autopsyCompleted = true;
      game.flags.autopsyUnlocked = false;
    },
  ),

  "EXP4_AUTOPSY_REPORT": Decision(
    id: "EXP4_AUTOPSY_REPORT",
    expediente: 4,
    title: "Integrar dictamen de autopsia",
    description:
    "Relacionar los hallazgos postmortem con la evidencia toxicológica y clínica.",
    icon: Icons.description,
    type: DecisionType.legal,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 15,
    successRate: 100,

    result:
    "El dictamen permite establecer una relación entre el fallecimiento "
        "del paciente índice y el patrón de intoxicaciones investigado.",

    condition: (game) =>
    game.flags.patientDead &&
        game.flags.autopsyCompleted &&
        !game.flags.exp4Complete,

    onSuccess: (game) {
      game.flags.exp4Complete = true;
    },
  ),

  "EXP4_INTEGRATE_CASE": Decision(
    id: "EXP4_INTEGRATE_CASE",
    expediente: 4,
    title: "Integrar la reconstrucción médico-legal",
    description:
    "Relacionar la evidencia de la escena, los hallazgos toxicológicos "
        "y la información postmortem disponible.",
    icon: Icons.account_tree,
    type: DecisionType.legal,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 20,
    successRate: 100,

    result:
    "La integración de los hallazgos permite establecer una relación "
        "entre la escena, la distribución de sustancias y los casos de intoxicación. "
        "La investigación conduce hacia un almacén utilizado por la red.",

    condition: (game) =>
    game.flags.crimeSceneEvidenceFound &&
        game.flags.autopsyCompleted &&
        !game.flags.exp4Integrated,

    onSuccess: (game) {
      game.flags.exp4Integrated = true;
      game.flags.exp4Complete = true;
      game.flags.warehouseUnlocked = true;
    },

    nextNode: "EXP4_CLOSE",
  ),
};