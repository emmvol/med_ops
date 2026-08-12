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
    title: "Llegar a la zona cero",
    description:
    "El aire en este lugar es pesado, cargado con un olor metálico y químico que se pega a la garganta. "
        "El silencio solo es interrumpido por el aleteo de las cintas policiales amarillas. "
        "Aquí, la fiesta se convirtió en una pesadilla silenciosa.",
    icon: Icons.location_on,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "La zona está parcialmente acordonada. Hay objetos personales esparcidos: "
        "zapatos perdidos en la huida y vasos rotos que aún conservan el rastro de la 'mezcla'. "
        "Los investigadores te miran esperando una dirección.",

    condition: (game) =>
    game.flags.crimeSceneUnlocked &&
        !game.flags.crimeSceneVisited,

    onSuccess: (game) {
      game.flags.crimeSceneVisited = true;
    },
  ),

  // ============================================================
  // DOCUMENTACIÓN
  // ============================================================

  "EXP4_DOCUMENT_SCENE": Decision(
    id: "EXP4_DOCUMENT_SCENE",
    expediente: 4,
    title: "Documentar el horror",
    description:
    "Registrar fotográficamente la posición de los cuerpos (ahora marcados con tiza) y "
        "la extraña disposición de los muebles. Hay marcas de uñas en las paredes que "
        "sugieren un pánico indescriptible antes del colapso.",
    icon: Icons.camera_alt,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 50,
    trustChange: 8,
    successRate: 100,

    result:
    "Cada fotografía es un recordatorio de la fragilidad humana. "
        "La documentación revela que las víctimas intentaron alejarse de un punto central "
        "en la habitación, como si huyeran de algo que solo ellas veían.",

    condition: (game) =>
    game.flags.crimeSceneVisited &&
        !game.flags.crimeSceneDocumented,

    onSuccess: (game) {
      game.flags.crimeSceneDocumented = true;
    },
  ),

  // ============================================================
  // INSPECCIÓN
  // ============================================================

  "EXP4_INSPECT_SCENE": Decision(
    id: "EXP4_INSPECT_SCENE",
    expediente: 4,
    title: "Inspeccionar los restos",
    description:
    "Buscar entre los escombros y las pertenencias abandonadas. Debajo de una mesa volcada "
        "hay una fotografía familiar manchada de fluidos biológicos y restos de una sustancia "
        "cristalina que no coincide con las muestras del hospital.",
    icon: Icons.search,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 2,
    moneyCost: 100,
    trustChange: 10,
    successRate: 100,

    result:
    "La inspección confirma que este lugar no fue solo un sitio de consumo, "
        "sino un campo de pruebas. Los indicios sugieren que los distribuidores "
        "observaron los efectos desde una distancia segura antes de limpiar parte de la escena.",

    condition: (game) =>
    game.flags.crimeSceneDocumented &&
        !game.flags.crimeSceneInspected,

    onSuccess: (game) {
      game.flags.crimeSceneInspected = true;
    },
  ),

  // ============================================================
  // EVIDENCIA
  // ============================================================

  "EXP4_RECOVER_EVIDENCE": Decision(
    id: "EXP4_RECOVER_EVIDENCE",
    expediente: 4,
    title: "Recuperar diario de la víctima",
    description:
    "Identificar y asegurar un pequeño cuaderno encontrado en el suelo. Sus páginas están "
        "arrugadas y contienen notas frenéticas sobre una 'puerta roja' y el 'aliento de la Quimera'. "
        "Es el testimonio final de alguien que sabía que no saldría de aquí.",
    icon: Icons.inventory_2,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 12,
    successRate: 100,

    result:
    "El diario menciona entregas regulares provenientes de una zona industrial cercana. "
        "La evidencia vincula directamente este escenario de muerte con una red de logística organizada.",

    evidence: "Diario de la víctima (Escena del Crimen)",

    condition: (game) =>
    game.flags.crimeSceneInspected &&
        !game.flags.crimeSceneEvidenceFound,

    onSuccess: (game) {
      game.flags.crimeSceneEvidenceFound = true;
    },
  ),

  // ============================================================
  // ALMACÉN (CONEXIÓN)
  // ============================================================

  "EXP4_IDENTIFY_WAREHOUSE": Decision(
    id: "EXP4_IDENTIFY_WAREHOUSE",
    expediente: 4,
    title: "Localizar el origen (Almacén)",
    description:
    "Cruzar los datos del diario con los registros de GPS de los vehículos policiales "
        "que patrullaron la zona la noche de la fiesta. Todos los hilos conducen a un "
        "viejo almacén de suministros químicos en las afueras.",
    icon: Icons.warehouse,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 15,
    successRate: 100,

    result:
    "La policía autoriza el despliegue hacia el almacén. "
        "Has identificado el corazón de la red Quimera. El aire se siente más frío al "
        "entender la escala de la operación.",

    condition: (game) =>
    game.flags.crimeSceneEvidenceFound &&
        !game.flags.warehouseUnlocked,

    onSuccess: (game) {
      game.flags.warehouseUnlocked = true;
      game.flags.exp4Integrated = true;
      game.flags.exp4Complete = true;
    },
  ),

  // ============================================================
  // CIERRE E INTEGRACIÓN IV
  // ============================================================

  "EXP4_CLOSE": Decision(
    id: "EXP4_CLOSE",
    expediente: 4,
    title: "Concluir reconstrucción de la escena",
    description:
    "Abandonar el lugar y dejar que los equipos forenses terminen. "
        "Es hora de integrar los hallazgos médicos y de campo para iniciar el asalto final.",
    icon: Icons.fact_check,
    type: DecisionType.investigation,
    location: Location.crimeScene,
    repeat: DecisionRepeat.once,
    apCost: 0,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "Iniciando evaluación de integración médico-legal del Expediente IV...",

    // VINCULACIÓN CON EL CUESTIONARIO
    evaluationId: "EVAL_EXP4_INTEGRATION",

    condition: (game) =>
    game.flags.exp4Complete &&
        !game.completedEvaluations.contains("EVAL_EXP4_INTEGRATION"),
  ),
};