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
    title: "Asaltar el almacén industrial",
    description:
    "El metal de la persiana cede con un estruendo. El interior es un laberinto de estantes, sombras y un penetrante olor a cloro y productos químicos. "
        "El equipo de asalto asegura la entrada mientras el aire se siente gélido.",
    icon: Icons.security,
    type: DecisionType.legal,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "El inmueble es mucho más grande de lo que sugerían los planos externos. "
        "Hay maquinaria de ventilación zumbando con fuerza, ocultando otros sonidos en el interior.",

    condition: (game) =>
    game.flags.warehouseUnlocked &&
        !game.flags.warehouseVisited,

    onSuccess: (game) {
      game.flags.warehouseVisited = true;
    },
  ),

  // ============================================================
  // LABORATORIO DE PRUEBAS (CRUELDAD)
  // ============================================================

  "EXP5_INSPECT_CRUELTY": Decision(
    id: "EXP5_INSPECT_CRUELTY",
    expediente: 5,
    title: "Investigar zona de 'ensayos'",
    description:
    "En una sección apartada, encuentras mesas con correas de sujeción, monitores cardíacos y registros médicos de 'sujetos'. "
        "Quimera no solo distribuía sustancias; realizaba pruebas de letalidad en seres humanos para perfeccionar sus mezclas.",
    icon: Icons.biotech,
    type: DecisionType.investigation,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 2,
    moneyCost: 150,
    trustChange: 10,
    successRate: 100,

    result:
    "Documentas una crueldad sistemática. Encuentras bitácoras donde se anotaba el tiempo de colapso de las víctimas. "
        "La evidencia física aquí es irrefutable y devastadora.",

    condition: (game) =>
    game.flags.warehouseVisited &&
        !game.flags.warehouseInspected,

    onSuccess: (game) {
      game.flags.warehouseInspected = true;
    },
  ),

  // ============================================================
  // EVIDENCIA DE OMEGA (PISTAS)
  // ============================================================

  "EXP5_DECRYPT_LOGS": Decision(
    id: "EXP5_DECRYPT_LOGS",
    expediente: 5,
    title: "Analizar bitácoras del servidor",
    description:
    "Acceder a un terminal oculto tras una pila de cajas. Las bitácoras mencionan al 'Equipo Omega' "
        "y contienen una nota inquietante: 'Supervisión final desde el sector de mantenimiento... tras el metal rojo'.",
    icon: Icons.terminal,
    type: DecisionType.investigation,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 15,
    successRate: 100,

    result:
    "Los registros sugieren que la cúpula de Quimera no ha abandonado el edificio. "
        "Están monitoreando la escena desde una ubicación no registrada en los planos comerciales.",

    evidence: "Registros de ubicación interna Omega",

    condition: (game) =>
    game.flags.warehouseInspected &&
        !game.flags.distributionEvidenceFound,

    onSuccess: (game) {
      game.flags.distributionEvidenceFound = true;
    },
  ),

  // ============================================================
  // RECONSTRUCCIÓN FINAL
  // ============================================================

  "EXP5_FIND_OMEGA_ENTRANCE": Decision(
    id: "EXP5_FIND_OMEGA_ENTRANCE",
    expediente: 5,
    title: "Detectar discrepancia arquitectónica",
    description:
    "Al cotejar los planos del servidor con la estructura física del almacén, notas un vacío de 60 metros cuadrados "
        "en el sector de mantenimiento que no tiene puertas visibles desde el pasillo.",
    icon: Icons.grid_view,
    type: DecisionType.investigation,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 20,
    successRate: 100,

    result:
    "La sospecha se confirma: hay una sección blindada oculta. "
        "El Equipo Omega está en este mismo edificio, atrincherado en una habitación de pánico.",

    condition: (game) =>
    game.flags.distributionEvidenceFound &&
        !game.flags.quimeraNetworkIdentified,

    onSuccess: (game) {
      game.flags.quimeraNetworkIdentified = true;
    },
  ),

  // ============================================================
  // PREPARACIÓN FINAL
  // ============================================================

  "EXP5_PREPARE_FINAL_ASSAULT": Decision(
    id: "EXP5_PREPARE_FINAL_ASSAULT",
    expediente: 5,
    title: "Asegurar evidencia y preparar asalto",
    description:
    "Toda la evidencia de la red Quimera ha sido asegurada. Los líderes han sido localizados. "
        "Solo queda un paso para desarticular la organización por completo.",
    icon: Icons.gavel,
    type: DecisionType.legal,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 20,
    successRate: 100,

    result:
    "El perímetro está sellado. El equipo espera tu decisión final sobre cómo proceder contra el núcleo de Omega.",

    condition: (game) =>
    game.flags.quimeraNetworkIdentified &&
        !game.flags.finalEvidenceSecured,

    onSuccess: (game) {
      game.flags.finalEvidenceSecured = true;
      // Esto desbloqueará el Cuestionario Omega en el motor
    },
  ),

  // ============================================================
  // EJECUCIÓN OMEGA (DISPARADOR DEL FINAL)
  // ============================================================

  "EXP5_FINAL_REVIEW": Decision(
    id: "EXP5_FINAL_REVIEW",
    expediente: 5,
    title: "EJECUTAR OPERACIÓN OMEGA",
    description:
    "Es el momento de la verdad. Debes identificar la ubicación exacta de los líderes "
        "y decidir el método de entrada. Un error aquí permitirá que Quimera escape para siempre.",
    icon: Icons.flag,
    type: DecisionType.legal,
    location: Location.warehouse,
    repeat: DecisionRepeat.once,
    apCost: 0,
    moneyCost: 0,
    trustChange: 10,
    successRate: 100,

    result:
    "Iniciando fase final de resolución...",

    evaluationId: "EVAL_OMEGA_FINAL", // Cuestionario final

    condition: (game) =>
    game.flags.finalEvidenceSecured &&
        !game.flags.omegaQuestionnaireCompleted,

    onSuccess: (game) {
      // La lógica de flags finales se maneja en el executeEvaluation del motor
    },
  ),
};