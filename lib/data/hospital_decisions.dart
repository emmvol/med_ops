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
    "Realizar valoración inicial y establecer el estado hemodinámico y neurológico.",
    icon: Icons.monitor_heart,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 6,
    successRate: 100,

    result:
    "Se documenta taquicardia, hipertensión, hipertermia y midriasis. "
        "El paciente permanece inestable.",

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
    title: "Evaluación primaria ABC",
    description:
    "Priorizar vía aérea, respiración y circulación ante el estado crítico.",
    icon: Icons.health_and_safety,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 2,
    moneyCost: 100,
    trustChange: 15,
    successRate: 95,

    result:
    "Se corrigen alteraciones inmediatas y el paciente presenta "
        "una mejoría clínica significativa.",

    failResult:
    "La valoración inicial no consigue corregir completamente "
        "el deterioro del paciente.",

    condition: (game) =>
    !game.flags.patientDead &&
        !game.flags.ivAccessObtained,

    onSuccess: (game) {
      game.patient.modifyStability(18);
    },

    onFail: (game) {
      game.patient.modifyStability(-5);
    },
  ),

  "GLUCOSE": Decision(
    id: "GLUCOSE",
    expediente: 1,
    title: "Medir glucosa",
    description:
    "Descartar hipoglucemia como causa o factor contribuyente del deterioro.",
    icon: Icons.bloodtype,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 30,
    trustChange: 4,
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
    "Evaluar las alteraciones cardiovasculares asociadas al cuadro tóxico.",
    icon: Icons.favorite,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 2,
    moneyCost: 180,
    trustChange: 10,
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
  // INVESTIGACIÓN
  // ============================================================

  "SEARCH_BODY": Decision(
    id: "SEARCH_BODY",
    expediente: 1,
    title: "Explorar pertenencias inmediatas",
    description:
    "Buscar objetos que puedan aportar información sobre el origen del caso.",
    icon: Icons.search,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "Se encuentra una pulsera fluorescente asociada con una fiesta clandestina.",

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
    "Inspeccionar las pertenencias del paciente respetando la documentación médico-legal.",
    icon: Icons.backpack,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 2,
    moneyCost: 0,
    trustChange: 10,
    successRate: 100,

    result:
    "Se encuentra un teléfono celular y un ticket relacionado con una fiesta.",

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
    title: "Entrevistar a paramédicos",
    description:
    "Reconstruir las condiciones en que el paciente fue localizado.",
    icon: Icons.local_hospital,
    type: DecisionType.interview,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 7,
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
  // TOXICOLOGÍA
  // ============================================================

  "LAB": Decision(
    id: "LAB",
    expediente: 1,
    title: "Solicitar tamiz toxicológico",
    description:
    "Enviar muestras para identificar sustancias potencialmente relacionadas con el cuadro.",
    icon: Icons.science,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 2,
    moneyCost: 250,
    trustChange: 14,
    successRate: 100,

    result:
    "El tamiz toxicológico resulta positivo para cocaína y otras sustancias.",

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
    title: "Análisis toxicológico confirmatorio",
    description:
    "Realizar un estudio especializado para caracterizar la mezcla encontrada.",
    icon: Icons.biotech,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 2,
    moneyCost: 400,
    trustChange: 18,
    successRate: 95,

    result:
    "El análisis confirma la presencia de una mezcla de sustancias.",

    failResult:
    "La muestra resulta insuficiente para establecer una conclusión definitiva.",

    evidence: "Análisis toxicológico confirmatorio",

    condition: (game) =>
    game.flags.labRequested &&
        !game.flags.labConfirmed &&
        !game.flags.patientDead,

    onSuccess: (game) {
      game.flags.labConfirmed = true;
      game.flags.laboratoryCompleted = true;
    },
  ),

  // ============================================================
  // POLICÍA
  // ============================================================

  "CALL_POLICE": Decision(
    id: "CALL_POLICE",
    expediente: 1,
    title: "Contactar a la policía",
    description:
    "Solicitar colaboración oficial ante la sospecha de una intoxicación relacionada con otros casos.",
    icon: Icons.local_police,
    type: DecisionType.legal,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 12,
    successRate: 100,

    result:
    "La policía acepta colaborar y abre una línea de investigación.",

    condition: (game) =>
    !game.flags.policeCalled &&
        !game.flags.patientDead,

    onSuccess: (game) {
      game.flags.policeCalled = true;
      game.flags.policeTrust = true;
    },
  ),

  // ============================================================
  // TRATAMIENTO
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
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 40,
    trustChange: 8,
    successRate: 92,

    result:
    "La oxigenación mejora y el paciente presenta recuperación parcial.",

    failResult:
    "La respuesta al manejo es insuficiente.",

    condition: (game) =>
    !game.flags.patientDead &&
        !game.flags.airwaySecured,

    onSuccess: (game) {
      game.patient.modifyStability(20);
    },

    onFail: (game) {
      game.patient.modifyStability(-5);
    },
  ),

  "IV_FLUIDS": Decision(
    id: "IV_FLUIDS",
    expediente: 1,
    title: "Canalizar vía intravenosa",
    description:
    "Obtener acceso venoso y proporcionar soporte intravenoso.",
    icon: Icons.water_drop,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 80,
    trustChange: 7,
    successRate: 90,

    result:
    "Se obtiene acceso venoso y el paciente presenta mejoría hemodinámica.",

    failResult:
    "No se consigue un acceso venoso adecuado.",

    condition: (game) =>
    !game.flags.ivAccessObtained &&
        !game.flags.patientDead,

    onSuccess: (game) {
      game.flags.ivAccessObtained = true;
      game.patient.modifyStability(15);
    },

    onFail: (game) {
      game.patient.modifyStability(-2);
    },
  ),

  "CONTROL_AGITATION": Decision(
    id: "CONTROL_AGITATION",
    expediente: 1,
    title: "Controlar hiperestimulación",
    description:
    "Realizar manejo farmacológico y monitorización neurológica.",
    icon: Icons.medication,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 120,
    trustChange: 10,
    successRate: 88,

    result:
    "La hiperestimulación disminuye y el paciente tolera mejor el manejo.",

    failResult:
    "La hiperestimulación persiste y el estado clínico empeora.",

    condition: (game) =>
    !game.flags.agitationControlled &&
        !game.flags.patientDead &&
        game.patient.stability > 0,

    onSuccess: (game) {
      game.flags.agitationControlled = true;
      game.patient.modifyStability(25);
    },

    onFail: (game) {
      game.patient.modifyStability(-6);
    },
  ),

  "ADVANCED_AIRWAY": Decision(
    id: "ADVANCED_AIRWAY",
    expediente: 1,
    title: "Manejo avanzado de vía aérea",
    description:
    "Asegurar la vía aérea ante deterioro neurológico o respiratorio.",
    icon: Icons.airline_seat_flat,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 2,
    moneyCost: 300,
    trustChange: 18,
    successRate: 82,

    result:
    "La vía aérea queda asegurada y el paciente recupera estabilidad.",

    failResult:
    "El procedimiento no consigue controlar el deterioro.",

    condition: (game) =>
    !game.flags.airwaySecured &&
        !game.flags.patientDead &&
        game.patient.stability <= 35,

    onSuccess: (game) {
      game.flags.airwaySecured = true;
      game.patient.modifyStability(35);
    },

    onFail: (game) {
      game.patient.modifyStability(-4);
    },
  ),

  // ============================================================
  // DECISIÓN ECONÓMICA
  // ============================================================

  "OUTSOURCE_TO_EXTERNAL_LAB": Decision(
    id: "OUTSOURCE_TO_EXTERNAL_LAB",
    expediente: 1,
    title: "Enviar muestra a laboratorio externo",
    description:
    "Reducir el gasto hospitalario utilizando un laboratorio externo. "
        "La opción permite recuperar recursos, pero disminuye el control institucional sobre el caso.",
    icon: Icons.business,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: -150,
    trustChange: -8,
    successRate: 100,

    result:
    "El laboratorio externo acepta procesar la muestra. "
        "El hospital recupera recursos, aunque la decisión genera cuestionamientos sobre el manejo del caso.",

    condition: (game) =>
    !game.flags.labRequested &&
        !game.flags.patientDead,

    onSuccess: (game) {
      game.flags.labRequested = true;
    },
  ),

  // ============================================================
  // CIERRE EXPEDIENTE 1
  // ============================================================

  "EXP1_CLOSE": Decision(
    id: "EXP1_CLOSE",
    expediente: 1,
    title: "Integrar expediente inicial",
    description:
    "Integrar la información clínica, toxicológica y médico-legal disponible.",
    icon: Icons.fact_check,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 8,
    successRate: 100,

    result:
    "El expediente inicial queda integrado. "
        "Los hallazgos permiten ampliar la investigación a otros casos.",

    condition: (game) =>
    !game.flags.exp1Complete &&
        !game.flags.patientDead &&
        (
            game.flags.vitalsTaken &&
                (
                    game.flags.labRequested ||
                        game.flags.policeCalled
                )
        ),

    onSuccess: (game) {
      game.flags.exp1Complete = true;
    },
  ),
};