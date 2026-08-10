import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';
import '../models/location.dart';

final Map<String, Decision> raveHouseDecisions = {

  // ============================================================
  // INGRESO
  // ============================================================

  "EXP3_ENTER_RAVE_HOUSE": Decision(
    id: "EXP3_ENTER_RAVE_HOUSE",
    expediente: 3,
    title: "Ingresar al domicilio",
    description:
    "La policía permite el ingreso al domicilio relacionado con la fiesta. "
        "El inmueble permanece bajo resguardo mientras se realiza la inspección.",
    icon: Icons.home,
    type: DecisionType.investigation,
    location: Location.raveHouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "El inmueble conserva señales de una reunión reciente. "
        "Hay objetos abandonados y signos de que varias personas estuvieron presentes.",

    condition: (game) =>
    game.flags.raveHouseUnlocked &&
        !game.flags.raveHouseVisited,

    onSuccess: (game) {
      game.flags.raveHouseVisited = true;
    },

    nextNode: "EXP3_INSPECT_RAVE_HOUSE",
  ),

  // ============================================================
  // INSPECCIÓN
  // ============================================================

  "EXP3_INSPECT_RAVE_HOUSE": Decision(
    id: "EXP3_INSPECT_RAVE_HOUSE",
    expediente: 3,
    title: "Inspeccionar el inmueble",
    description:
    "Realizar una inspección inicial del lugar y documentar los elementos "
        "que puedan relacionarse con las intoxicaciones.",
    icon: Icons.search,
    type: DecisionType.investigation,
    location: Location.raveHouse,
    repeat: DecisionRepeat.once,
    apCost: 2,
    moneyCost: 100,
    trustChange: 8,
    successRate: 100,

    result:
    "La distribución del inmueble permite reconstruir parcialmente la fiesta. "
        "Se identifican restos de consumo y un espacio utilizado para almacenar objetos.",

    condition: (game) =>
    game.flags.raveHouseVisited &&
        !game.flags.raveHouseInspected,

    onSuccess: (game) {
      game.flags.raveHouseInspected = true;
    },

    nextNode: "EXP3_FIND_EVIDENCE",
  ),

  // ============================================================
  // EVIDENCIA PRINCIPAL
  // ============================================================

  "EXP3_FIND_EVIDENCE": Decision(
    id: "EXP3_FIND_EVIDENCE",
    expediente: 3,
    title: "Localizar evidencia relevante",
    description:
    "Concentrar la búsqueda en los elementos que puedan establecer una relación "
        "entre el domicilio y las intoxicaciones.",
    icon: Icons.find_in_page,
    type: DecisionType.investigation,
    location: Location.raveHouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 10,
    successRate: 100,

    result:
    "Se localiza un elemento que vincula el domicilio con la distribución "
        "de sustancias durante la fiesta.",

    evidence: "Elemento vinculado a la distribución",

    condition: (game) =>
    game.flags.raveHouseInspected &&
        !game.flags.raveHouseEvidenceFound,

    onSuccess: (game) {
      game.flags.raveHouseEvidenceFound = true;
    },

    nextNode: "EXP3_RECONSTRUCT_EVENT",
  ),

  // ============================================================
  // RECONSTRUCCIÓN
  // ============================================================

  "EXP3_RECONSTRUCT_EVENT": Decision(
    id: "EXP3_RECONSTRUCT_EVENT",
    expediente: 3,
    title: "Reconstruir los hechos",
    description:
    "Relacionar los hallazgos del domicilio con los testimonios obtenidos "
        "durante la investigación policial.",
    icon: Icons.account_tree,
    type: DecisionType.investigation,
    location: Location.raveHouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 10,
    successRate: 100,

    result:
    "La reconstrucción sugiere que la intoxicación no ocurrió únicamente "
        "durante la fiesta. Una segunda ubicación habría sido utilizada después "
        "del evento.",

    condition: (game) =>
    game.flags.raveHouseEvidenceFound &&
        !game.flags.raveHouseReconstructed,

    onSuccess: (game) {
      game.flags.raveHouseReconstructed = true;
      game.flags.crimeSceneLeadFound = true;
      game.flags.crimeSceneUnlocked = true;
      game.flags.exp3Complete = true;
    },

    nextNode: "EXP3_CLOSE",
  ),

  // ============================================================
  // CIERRE
  // ============================================================

  "EXP3_CLOSE": Decision(
    id: "EXP3_CLOSE",
    expediente: 3,
    title: "Concluir inspección",
    description:
    "Integrar los hallazgos obtenidos en el domicilio.",
    icon: Icons.fact_check,
    type: DecisionType.investigation,
    location: Location.raveHouse,
    repeat: DecisionRepeat.once,
    apCost: 0,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "La investigación conduce a una nueva ubicación relacionada con el caso. "
        "La escena deberá ser examinada antes de continuar.",

    condition: (game) =>
    game.flags.exp3Complete,
  ),

  "EXP3_IDENTIFY_CRIME_SCENE": Decision(
    id: "EXP3_IDENTIFY_CRIME_SCENE",
    expediente: 3,
    title: "Identificar la siguiente escena",
    description:
    "Integrar la evidencia obtenida en el domicilio y determinar "
        "qué lugar debe investigarse a continuación.",
    icon: Icons.account_tree,
    type: DecisionType.investigation,
    location: Location.raveHouse,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 15,
    successRate: 100,

    result:
    "La evidencia y la reconstrucción de los hechos permiten "
        "identificar una segunda ubicación relacionada con la distribución "
        "de sustancias. La escena queda autorizada para investigación.",

    condition: (game) =>
    game.flags.raveHouseReconstructed &&
        !game.flags.crimeSceneUnlocked,

    onSuccess: (game) {
      game.flags.crimeSceneLeadFound = true;
      game.flags.crimeSceneUnlocked = true;
      game.flags.exp3Complete = true;
    },

    nextNode: "EXP3_CLOSE",
  ),
};