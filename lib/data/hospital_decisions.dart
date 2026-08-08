import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';
import '../models/location.dart';

final Map<String, Decision> hospitalDecisions = {

  // ============================================================
  // VALORACIÓN INICIAL
  // ============================================================

  "VITALS": Decision(
    id: "VITALS",
    expediente: 1,
    title: "Valorar signos vitales",
    description:
    "Registrar signos vitales completos y reevaluar al paciente.",
    icon: Icons.monitor_heart,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,
    result:
    "Se documentan taquicardia, hipertensión, hipertermia y midriasis.",
    condition: (game) =>
    !game.flags.vitalsTaken &&
        !game.flags.patientDead,
    onSuccess: (game) {
      game.flags.vitalsTaken = true;
    },
  ),

  "ABC": Decision(
    id: "ABC",
    expediente: 1,
    title: "Evaluación primaria",
    description:
    "Realizar abordaje ABC y corregir las alteraciones inmediatas.",
    icon: Icons.health_and_safety,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.untilSuccess,
    apCost: 1,
    moneyCost: 150,
    trustChange: 20,
    successRate: 95,
    result:
    "El paciente responde favorablemente a las maniobras iniciales.",
    failResult:
    "No se logra estabilizar completamente al paciente.",
    condition: (game) =>
    !game.flags.patientDead &&
        game.patient.stability > 20,
    onSuccess: (game) {
      game.patient.modifyStability(15);
    },
    onFail: (game) {
      game.patient.modifyStability(-15);
    },
  ),

  "GLUCOSE": Decision(
    id: "GLUCOSE",
    expediente: 1,
    title: "Medir glucosa",
    description:
    "Realizar glucemia capilar.",
    icon: Icons.bloodtype,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 50,
    trustChange: 5,
    successRate: 100,
    result:
    "La glucosa se encuentra dentro de parámetros normales.",
    condition: (game) =>
    !game.flags.glucoseChecked &&
        !game.flags.patientDead,
    onSuccess: (game) {
      game.flags.glucoseChecked = true;
    },
  ),

  "ECG": Decision(
    id: "ECG",
    expediente: 1,
    title: "Solicitar ECG",
    description:
    "Buscar alteraciones cardíacas.",
    icon: Icons.favorite,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 2,
    moneyCost: 250,
    trustChange: 8,
    successRate: 100,
    result:
    "El ECG muestra taquicardia sinusal sin otras alteraciones relevantes.",
    condition: (game) =>
    !game.flags.ecgPerformed &&
        !game.flags.patientDead,
    onSuccess: (game) {
      game.flags.ecgPerformed = true;
    },
  ),

  // ============================================================
  // INVESTIGACIÓN DEL PACIENTE
  // ============================================================

  "SEARCH_BODY": Decision(
    id: "SEARCH_BODY",
    expediente: 1,
    title: "Explorar al paciente",
    description:
    "Buscar objetos ocultos entre la ropa y pertenencias inmediatas.",
    icon: Icons.search,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 4,
    successRate: 100,
    result:
    "Encuentras una pulsera fluorescente asociada con un rave.",
    evidence: "Pulsera fluorescente",
    condition: (game) =>
    !game.flags.raveBraceletFound &&
        !game.flags.patientDead,
    onSuccess: (game) {
      game.flags.raveBraceletFound = true;
    },
  ),

  "BACKPACK": Decision(
    id: "BACKPACK",
    expediente: 1,
    title: "Revisar mochila",
    description:
    "Inspeccionar las pertenencias del paciente.",
    icon: Icons.backpack,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,
    result:
    "Encuentras un teléfono y un ticket de acceso.",
    evidence: "Teléfono celular",
    condition: (game) =>
    !game.flags.foundPhone &&
        !game.flags.patientDead,
    onSuccess: (game) {
      game.flags.foundPhone = true;
      game.flags.raveDiscovered = true;
    },
  ),

  "QUESTION_PARAMEDICS": Decision(
    id: "QUESTION_PARAMEDICS",
    expediente: 1,
    title: "Interrogar paramédicos",
    description:
    "Preguntar cómo encontraron al paciente y qué observaron en la escena.",
    icon: Icons.local_hospital,
    type: DecisionType.interview,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 6,
    successRate: 100,
    result:
    "Los paramédicos describen otras víctimas con manifestaciones diferentes.",
    condition: (game) =>
    !game.flags.paramedicsInterviewed &&
        !game.flags.patientDead,
    onSuccess: (game) {
      game.flags.paramedicsInterviewed = true;
    },
  ),

  // ============================================================
  // LABORATORIO
  // ============================================================

  "LAB": Decision(
    id: "LAB",
    expediente: 1,
    title: "Solicitar laboratorio",
    description:
    "Enviar muestras para análisis toxicológico.",
    icon: Icons.science,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 2,
    moneyCost: 300,
    trustChange: 15,
    successRate: 100,
    result:
    "El tamiz toxicológico resulta positivo para cocaína.",
    evidence: "Tamiz toxicológico",
    condition: (game) =>
    !game.flags.labRequested &&
        !game.flags.patientDead,
    onSuccess: (game) {
      game.flags.labRequested = true;
    },
  ),

  "CONFIRM": Decision(
    id: "CONFIRM",
    expediente: 1,
    title: "Análisis confirmatorio",
    description:
    "Solicitar análisis especializado de la muestra.",
    icon: Icons.biotech,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.untilSuccess,
    apCost: 2,
    moneyCost: 400,
    trustChange: 10,
    successRate: 95,
    result:
    "El análisis confirma una mezcla de sustancias.",
    failResult:
    "La muestra fue insuficiente para confirmar el resultado.",
    evidence: "Análisis confirmatorio",
    condition: (game) =>
    game.flags.labRequested &&
        !game.flags.labConfirmed &&
        !game.flags.patientDead,
    onSuccess: (game) {
      game.flags.labConfirmed = true;
    },
  ),

  // ============================================================
  // CONTACTO POLICIAL
  // ============================================================

  "CALL_POLICE": Decision(
    id: "CALL_POLICE",
    expediente: 1,
    title: "Contactar a la policía",
    description:
    "Solicitar colaboración oficial e informar sobre el caso.",
    icon: Icons.local_police,
    type: DecisionType.legal,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 10,
    successRate: 100,
    result:
    "La policía acepta colaborar con el hospital.",
    condition: (game) =>
    !game.flags.policeCalled &&
        !game.flags.patientDead,
    onSuccess: (game) {
      game.flags.policeCalled = true;
      game.flags.policeTrust = true;
    },
  ),

  // ============================================================
  // MANEJO TERAPÉUTICO
  // ============================================================

  "OXYGEN": Decision(
    id: "OXYGEN",
    expediente: 1,
    title: "Administrar oxígeno",
    description:
    "Proporcionar oxigenoterapia y reevaluar la respuesta clínica.",
    icon: Icons.air,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.untilSuccess,
    apCost: 1,
    moneyCost: 50,
    trustChange: 8,
    successRate: 90,
    result:
    "La oxigenación mejora y el estado clínico se estabiliza parcialmente.",
    failResult:
    "La oxigenoterapia no consigue corregir el deterioro.",
    condition: (game) =>
    !game.flags.patientDead &&
        game.patient.stability > 20 &&
        game.patient.stability <= 70,
    onSuccess: (game) {
      game.patient.modifyStability(10);
    },
    onFail: (game) {
      game.patient.modifyStability(-10);
    },
  ),

  "IV_FLUIDS": Decision(
    id: "IV_FLUIDS",
    expediente: 1,
    title: "Canalizar vía intravenosa",
    description:
    "Obtener acceso venoso y administrar solución intravenosa.",
    icon: Icons.water_drop,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.untilSuccess,
    apCost: 1,
    moneyCost: 100,
    trustChange: 8,
    successRate: 90,
    result:
    "Se obtiene acceso venoso y el paciente responde favorablemente.",
    failResult:
    "No se consigue un acceso venoso adecuado.",
    condition: (game) =>
    !game.flags.ivAccessObtained &&
        !game.flags.patientDead &&
        game.patient.stability <= 80,
    onSuccess: (game) {
      game.flags.ivAccessObtained = true;
      game.patient.modifyStability(8);
    },
    onFail: (game) {
      game.patient.modifyStability(-5);
    },
  ),

  "CONTROL_AGITATION": Decision(
    id: "CONTROL_AGITATION",
    expediente: 1,
    title: "Controlar hiperestimulación",
    description:
    "Realizar manejo farmacológico y monitorización del estado neurológico.",
    icon: Icons.medication,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.untilSuccess,
    apCost: 1,
    moneyCost: 150,
    trustChange: 8,
    successRate: 85,
    result:
    "La hiperestimulación disminuye y el paciente tolera mejor el manejo.",
    failResult:
    "El paciente continúa hiperestimulado y su estado clínico empeora.",
    condition: (game) =>
    !game.flags.patientDead &&
        game.patient.stability > 20 &&
        game.patient.stability <= 60,
    onSuccess: (game) {
      game.flags.agitationControlled = true;
      game.patient.modifyStability(12);
    },
    onFail: (game) {
      game.patient.modifyStability(-10);
    },
  ),

  "ADVANCED_AIRWAY": Decision(
    id: "ADVANCED_AIRWAY",
    expediente: 1,
    title: "Manejo avanzado de la vía aérea",
    description:
    "Realizar manejo avanzado de la vía aérea ante deterioro clínico.",
    icon: Icons.airline_seat_flat,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.untilSuccess,
    apCost: 2,
    moneyCost: 300,
    trustChange: 15,
    successRate: 80,
    result:
    "Se asegura la vía aérea y el paciente comienza a recuperar estabilidad.",
    failResult:
    "El intento de manejo avanzado de la vía aérea fracasa y el paciente se deteriora.",
    condition: (game) =>
    !game.flags.patientDead &&
        game.patient.stability > 0 &&
        game.patient.stability <= 20,
    onSuccess: (game) {
      game.flags.airwaySecured = true;
      game.patient.modifyStability(20);
    },
    onFail: (game) {
      game.patient.modifyStability(-15);
    },
  ),

  // ============================================================
  // MONITORIZACIÓN
  // ============================================================

  "OBSERVE": Decision(
    id: "OBSERVE",
    expediente: 1,
    title: "Observación clínica",
    description:
    "Monitorizar continuamente la evolución del paciente.",
    icon: Icons.visibility,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.repeatable,
    apCost: 1,
    moneyCost: 0,
    trustChange: -2,
    successRate: 100,
    result:
    "El paciente permanece bajo vigilancia sin cambios importantes.",
    condition: (game) =>
    !game.flags.patientDead,
    onSuccess: (game) {
      game.patient.modifyStability(2);
    },
  ),
};