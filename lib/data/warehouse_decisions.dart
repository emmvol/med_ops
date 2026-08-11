import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';
import '../models/location.dart';

final Map<String, Decision> warehouseDecisions = {

  // ============================================================
  // INGRESO
  // ============================================================

  "EXP5_ENTER_WAREHOUSE": Decision(
    id: "EXP5_ENTER_WAREHOUSE",
    expediente: 5,
    title: "Ingresar al almacén",
    description:
    "Acceder al inmueble identificado durante la investigación.",
    icon: Icons.warehouse,
    type: DecisionType.legal,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "El inmueble presenta características compatibles con un punto "
        "de almacenamiento y distribución.",

    condition: (game) =>
    game.flags.warehouseUnlocked &&
        !game.flags.warehouseVisited,

    onSuccess: (game) {
      game.flags.warehouseVisited = true;
    },

    nextNode: "EXP5_INSPECT_WAREHOUSE",
  ),

  // ============================================================
  // INSPECCIÓN
  // ============================================================

  "EXP5_INSPECT_WAREHOUSE": Decision(
    id: "EXP5_INSPECT_WAREHOUSE",
    expediente: 5,
    title: "Inspeccionar el almacén",
    description:
    "Realizar una búsqueda dirigida para localizar evidencia de la "
        "cadena de distribución.",
    icon: Icons.search,
    type: DecisionType.investigation,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 2,
    moneyCost: 150,
    trustChange: 10,
    successRate: 100,

    result:
    "La inspección revela documentación, materiales y registros que "
        "permiten reconstruir parcialmente la distribución de sustancias.",

    condition: (game) =>
    game.flags.warehouseVisited &&
        !game.flags.warehouseInspected,

    onSuccess: (game) {
      game.flags.warehouseInspected = true;
    },

    nextNode: "EXP5_FIND_DISTRIBUTION_EVIDENCE",
  ),

  // ============================================================
  // EVIDENCIA
  // ============================================================

  "EXP5_FIND_DISTRIBUTION_EVIDENCE": Decision(
    id: "EXP5_FIND_DISTRIBUTION_EVIDENCE",
    expediente: 5,
    title: "Asegurar evidencia de distribución",
    description:
    "Identificar los elementos que permitan establecer cómo operaba la red.",
    icon: Icons.inventory,
    type: DecisionType.investigation,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 15,
    successRate: 100,

    result:
    "Los registros permiten relacionar distintos puntos de distribución "
        "y establecer que los casos investigados formaban parte de una misma cadena.",

    evidence: "Registros de distribución",

    condition: (game) =>
    game.flags.warehouseInspected &&
        !game.flags.distributionEvidenceFound,

    onSuccess: (game) {
      game.flags.distributionEvidenceFound = true;
    },

    nextNode: "EXP5_IDENTIFY_NETWORK",
  ),

  // ============================================================
  // RED QUIMERA
  // ============================================================

  "EXP5_IDENTIFY_NETWORK": Decision(
    id: "EXP5_IDENTIFY_NETWORK",
    expediente: 5,
    title: "Reconstruir la cadena de distribución",
    description:
    "Relacionar los registros obtenidos con la información reunida durante "
        "los expedientes anteriores.",
    icon: Icons.account_tree,
    type: DecisionType.investigation,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 20,
    successRate: 100,

    result:
    "La información permite establecer que las intoxicaciones estaban "
        "relacionadas con una misma cadena de distribución. El nombre "
        "\"Quimera\" deja de ser únicamente un alias y pasa a representar "
        "una estructura organizada.",

    condition: (game) =>
    game.flags.distributionEvidenceFound &&
        !game.flags.quimeraNetworkIdentified,

    onSuccess: (game) {
      game.flags.quimeraNetworkIdentified = true;
    },

    nextNode: "EXP5_SECURE_FINAL_EVIDENCE",
  ),

  // ============================================================
  // EVIDENCIA FINAL
  // ============================================================

  "EXP5_SECURE_FINAL_EVIDENCE": Decision(
    id: "EXP5_SECURE_FINAL_EVIDENCE",
    expediente: 5,
    title: "Asegurar evidencia final",
    description:
    "Completar el aseguramiento de los elementos fundamentales para "
        "la investigación médico-legal.",
    icon: Icons.gavel,
    type: DecisionType.legal,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 20,
    successRate: 100,

    result:
    "La evidencia fundamental queda asegurada y es entregada a las "
        "autoridades correspondientes. La investigación puede pasar a su resolución.",

    condition: (game) =>
    game.flags.quimeraNetworkIdentified &&
        !game.flags.finalEvidenceSecured,

    onSuccess: (game) {
      game.flags.finalEvidenceSecured = true;
    },

    nextNode: "EXP5_FINAL_REVIEW",
  ),

  // ============================================================
  // FINAL
  // ============================================================

  "EXP5_FINAL_REVIEW": Decision(
    id: "EXP5_FINAL_REVIEW",
    expediente: 5,
    title: "Cerrar la investigación",
    description:
    "Integrar los hallazgos clínicos, toxicológicos y médico-legales.",
    icon: Icons.fact_check,
    type: DecisionType.legal,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 0,
    moneyCost: 0,
    trustChange: 10,
    successRate: 100,

    result:
    "La investigación ha establecido una relación entre los casos de "
        "intoxicación y la red identificada como Quimera.",

    condition: (game) =>
    game.flags.exp5Complete,

    onSuccess: (game) {
      game.flags.campaignComplete = true;
      game.flags.exp5Complete = true;
    },
  ),
};