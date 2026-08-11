import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';
import '../models/location.dart';

final Map<String, Decision> hospitalExpediente2Decisions = {

  // ============================================================
  // PACIENTE SECUNDARIO
  // ============================================================

  "EXP2_RECEIVE_PATIENT": Decision(
    id: "EXP2_RECEIVE_PATIENT",
    expediente: 2,
    title: "Recibir nuevo paciente",
    description:
    "Ingresa un paciente de aproximadamente 24 años procedente de la misma zona donde fue localizado el paciente índice.",
    icon: Icons.emergency,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    // El costo se paga al iniciar la atención del paciente.
    apCost: 1,

    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "El paciente presenta diaforesis, taquicardia, hipertensión, midriasis y agitación psicomotriz. Refiere haber consumido una sustancia durante una fiesta.",

    condition: (game) =>
    !game.flags.secondaryPatientArrived &&
        !game.flags.patientDead,

    onSuccess: (game) {
      game.flags.secondaryPatientArrived = true;
    },

    nextNode: "EXP2_SECONDARY_MANAGEMENT",
  ),

  // ============================================================
  // MANEJO DEL PACIENTE SECUNDARIO
  // ============================================================

  "EXP2_SECONDARY_MANAGEMENT": Decision(
    id: "EXP2_SECONDARY_MANAGEMENT",
    expediente: 2,
    title: "Manejo del síndrome tóxico",
    description:
    "TA 150/70 mmHg, FC 128 lpm, diaforesis, midriasis y agitación psicomotriz. ¿Cuál es la conducta inicial más adecuada?",
    icon: Icons.medical_services,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 0,
    moneyCost: 100,
    trustChange: 10,
    successRate: 100,

    result:
    "Se inicia monitorización, reducción de estímulos y tratamiento sintomático. La frecuencia cardiaca y la agitación disminuyen progresivamente.",

    condition: (game) =>
    game.flags.secondaryPatientArrived &&
        !game.flags.secondaryPatientResolved &&
        !game.flags.patientDead,

    onSuccess: (game) {
      game.flags.secondaryPatientResolved = true;
      game.flags.secondaryVitalsTaken = true;
    },

    nextNode: "EXP2_SECONDARY_REASSESSMENT",
  ),

  // ============================================================
  // REVALORACIÓN
  // ============================================================

  "EXP2_SECONDARY_REASSESSMENT": Decision(
    id: "EXP2_SECONDARY_REASSESSMENT",
    expediente: 2,
    title: "Revalorar al paciente",
    description:
    "Después del manejo inicial, reevaluar estado neurológico, signos vitales y evolución clínica.",
    icon: Icons.monitor_heart,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 0,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "El paciente presenta mejoría clínica. Durante la entrevista refiere que otras personas que consumieron la misma sustancia también comenzaron a presentar síntomas.",

    condition: (game) =>
    game.flags.secondaryPatientResolved &&
        !game.flags.secondaryReassessed,

    onSuccess: (game) {
      game.flags.secondaryReassessed = true;
    },

    nextNode: "EXP2_SPECIAL_PATIENT",
  ),

  // ============================================================
  // PACIENTE GRAVE
  // ============================================================

  "EXP2_SPECIAL_PATIENT": Decision(
    id: "EXP2_SPECIAL_PATIENT",
    expediente: 2,
    title: "Atender paciente grave",
    description:
    "Ingresa otro paciente del mismo grupo. Presenta alteración del estado de conciencia, hipertermia y deterioro progresivo.",
    icon: Icons.personal_injury,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    result:
    "El paciente presenta deterioro neurológico, hipertermia y alteraciones autonómicas. Sus acompañantes refieren que varias personas consumieron la misma sustancia.",

    condition: (game) =>
    game.flags.secondaryReassessed &&
        !game.flags.specialPatientArrived,

    onSuccess: (game) {
      game.flags.specialPatientArrived = true;
    },

    nextNode: "EXP2_SPECIAL_MANAGEMENT",
  ),

  // ============================================================
  // PACIENTE GRAVE — DECISIÓN CRÍTICA
  // ============================================================

  "EXP2_SPECIAL_MANAGEMENT": Decision(
    id: "EXP2_SPECIAL_MANAGEMENT",
    expediente: 2,
    title: "Priorizar manejo del paciente grave",
    description:
    "El paciente presenta hipertermia, alteración del estado de conciencia y deterioro progresivo. Selecciona la intervención prioritaria.",
    icon: Icons.monitor_heart,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 0,
    moneyCost: 200,
    trustChange: 15,
    successRate: 100,

    result:
    "El paciente responde al manejo inicial y queda bajo vigilancia estrecha. Antes de mejorar, refiere que la sustancia fue entregada por una persona a quien llamaban únicamente \"Quimera\".",

    condition: (game) =>
    game.flags.specialPatientArrived &&
        !game.flags.specialPatientResolved &&
        !game.flags.patientDead,

    onSuccess: (game) {
      game.flags.specialPatientResolved = true;
      game.flags.knowsAlias = true;
    },

    evidence: "Referencia al nombre \"Quimera\"",

    nextNode: "EXP2_CASE_REVIEW",
  ),

  "EXP2_PATIENT_ALCOHOL": Decision(
    id: "EXP2_PATIENT_ALCOHOL",
    expediente: 2,
    title: "Ingresar paciente • Alcohol",
    description:
    "Ingresa un paciente con alteración del estado de conciencia "
        "posterior a consumo importante de alcohol.",
    icon: Icons.local_bar,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,

    evaluationId: "MINI_CASE_ALCOHOL",

    result:
    "El paciente requiere valoración por posible intoxicación etílica.",

    condition: (game) =>
    !game.flags.patientAlcoholEvaluated &&
        !game.flags.patientDead,

    onSuccess: (game) {
      game.flags.patientAlcoholEvaluated = true;
    },
  ),

  "DEC_OPEN_MINI_OPIOIDS": Decision(
    id: "DEC_OPEN_MINI_OPIOIDS",
    expediente: 2,
    title: "Solicitar mini-caso opioides",
    description: "Abrir evaluación rápida sobre sospecha de opioides.",
    icon: Icons.local_hospital,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 0,
    successRate: 100,
    result: "Se ha abierto el mini-caso de opioides.",
    evaluationId: "MINI_CASE_OPIOIDS",
  ),

  // ============================================================
  // REVISIÓN DEL CASO
  // ============================================================

  "EXP2_CASE_REVIEW": Decision(
    id: "EXP2_CASE_REVIEW",
    expediente: 2,
    title: "Integrar los hallazgos",
    description:
    "Comparar la evolución de los pacientes y determinar si existe un patrón común.",
    icon: Icons.fact_check,
    type: DecisionType.investigation,
    location: Location.hospital,
    repeat: DecisionRepeat.once,

    apCost: 0,
    moneyCost: 0,
    trustChange: 8,
    successRate: 100,

    result:
    "Los pacientes presentan cuadros compatibles con una exposición común. La información reunida justifica ampliar la investigación y solicitar colaboración policial.",

    condition: (game) =>
    game.flags.specialPatientResolved &&
        !game.flags.exp2HospitalReviewComplete,

    onSuccess: (game) {
      game.flags.exp2HospitalReviewComplete = true;
    },

    nextNode: "CALL_POLICE",
  ),
};