import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';
import '../models/location.dart';

final Map<String, Decision> crimeSceneDecisions = {

  // ============================================================
  // LLEGADA
  // ============================================================

  "EXP4_ENTER_CRIME_SCENE": Decision(
    id: "EXP4_ENTER_CRIME_SCENE",
    expediente: 4,
    title: "Llegar a la escena",
    description:
    "Acudir al lugar identificado durante la investigación del domicilio.",
    icon: Icons.location_on,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "La zona se encuentra parcialmente acordonada. "
        "Los investigadores solicitan documentar cualquier hallazgo antes de manipularlo.",

    condition: (game) =>
    game.flags.crimeSceneUnlocked &&
        !game.flags.crimeSceneVisited,

    onSuccess: (game) {
      game.flags.crimeSceneVisited = true;
    },

    nextNode: "EXP4_DOCUMENT_SCENE",
  ),

  // ============================================================
  // DOCUMENTACIÓN
  // ============================================================

  "EXP4_DOCUMENT_SCENE": Decision(
    id: "EXP4_DOCUMENT_SCENE",
    expediente: 4,
    title: "Documentar la escena",
    description:
    "Registrar las condiciones generales del lugar antes de realizar una búsqueda.",
    icon: Icons.camera_alt,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 50,
    trustChange: 8,
    successRate: 100,

    result:
    "La escena queda documentada y se establece una referencia para interpretar "
        "la posición y relación de los objetos encontrados.",

    condition: (game) =>
    game.flags.crimeSceneVisited &&
        !game.flags.crimeSceneDocumented,

    onSuccess: (game) {
      game.flags.crimeSceneDocumented = true;
    },

    nextNode: "EXP4_INSPECT_SCENE",
  ),

  // ============================================================
  // INSPECCIÓN
  // ============================================================

  "EXP4_INSPECT_SCENE": Decision(
    id: "EXP4_INSPECT_SCENE",
    expediente: 4,
    title: "Inspeccionar la escena",
    description:
    "Buscar elementos que permitan determinar qué ocurrió después de la fiesta.",
    icon: Icons.search,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 2,
    moneyCost: 100,
    trustChange: 10,
    successRate: 100,

    result:
    "La inspección revela indicios de que el lugar fue utilizado para realizar "
        "una actividad posterior relacionada con la distribución de sustancias.",

    condition: (game) =>
    game.flags.crimeSceneDocumented &&
        !game.flags.crimeSceneInspected,

    onSuccess: (game) {
      game.flags.crimeSceneInspected = true;
    },

    nextNode: "EXP4_RECOVER_EVIDENCE",
  ),

  // ============================================================
  // EVIDENCIA
  // ============================================================

  "EXP4_RECOVER_EVIDENCE": Decision(
    id: "EXP4_RECOVER_EVIDENCE",
    expediente: 4,
    title: "Recuperar evidencia relevante",
    description:
    "Identificar y asegurar el elemento con mayor valor para la investigación.",
    icon: Icons.inventory_2,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 12,
    successRate: 100,

    result:
    "Se recupera evidencia que permite relacionar la escena con una instalación "
        "utilizada para almacenar y distribuir sustancias.",

    evidence: "Evidencia de distribución",

    condition: (game) =>
    game.flags.crimeSceneInspected &&
        !game.flags.crimeSceneEvidenceFound,

    onSuccess: (game) {
      game.flags.crimeSceneEvidenceFound = true;
    },

    nextNode: "EXP4_IDENTIFY_WAREHOUSE",
  ),

  // ============================================================
  // ALMACÉN
  // ============================================================

  "EXP4_IDENTIFY_WAREHOUSE": Decision(
    id: "EXP4_IDENTIFY_WAREHOUSE",
    expediente: 4,
    title: "Identificar la siguiente ubicación",
    description:
    "Analizar la evidencia recuperada y determinar qué lugar debe investigarse.",
    icon: Icons.warehouse,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 15,
    successRate: 100,

    result:
    "La evidencia apunta a un almacén utilizado como punto de almacenamiento "
        "y distribución. La policía autoriza la intervención.",

    condition: (game) =>
    game.flags.crimeSceneEvidenceFound &&
        !game.flags.warehouseUnlocked,

    onSuccess: (game) {
      game.flags.exp4Integrated = true;
      game.flags.exp4Complete = true;
      game.flags.warehouseUnlocked = true;
    },

    nextNode: "EXP4_CLOSE",
  ),

  // ============================================================
  // CIERRE
  // ============================================================

  "EXP4_CLOSE": Decision(
    id: "EXP4_CLOSE",
    expediente: 4,
    title: "Cerrar investigación de la escena",
    description:
    "Integrar la información obtenida y preparar el siguiente operativo.",
    icon: Icons.fact_check,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 0,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "La reconstrucción médico-legal establece una relación entre "
        "los pacientes, la escena investigada y la cadena de distribución. "
        "La siguiente fase será intervenir el almacén identificado.",

    condition: (game) =>
    game.flags.exp4Integrated,
  ),
};