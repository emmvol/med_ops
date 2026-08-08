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
    "Ingresa un paciente procedente de la misma zona donde fue localizado el paciente índice.",
    icon: Icons.emergency,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,
    result:
    "El paciente presenta diaforesis, taquicardia, hipertensión, midriasis y agitación. Refiere haber consumido una sustancia durante una fiesta.",
    condition: (game) =>
    !game.flags.secondaryPatientArrived,
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
    title: "Manejo inicial",
    description:
    "El paciente presenta TA 150/70 mmHg, FC elevada, diaforesis, midriasis y agitación. ¿Cuál es el manejo inicial?",
    icon: Icons.medical_services,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 0,
    moneyCost: 100,
    trustChange: 10,
    successRate: 100,
    result:
    "Se inicia monitorización, control del ambiente y tratamiento sintomático. El paciente mejora progresivamente.",
    condition: (game) =>
    game.flags.secondaryPatientArrived &&
        !game.flags.secondaryPatientResolved,
    onSuccess: (game) {
      game.flags.secondaryVitalsTaken = true;
      game.flags.secondaryPatientResolved = true;
      game.flags.raveHouseSuspected = true;
    },
    evidence: "Manifestaciones compatibles con intoxicación por estimulantes",
    nextNode: "EXP2_SPECIAL_PATIENT",
  ),

  // ============================================================
  // PACIENTE ESPECIAL
  // ============================================================

  "EXP2_SPECIAL_PATIENT": Decision(
    id: "EXP2_SPECIAL_PATIENT",
    expediente: 2,
    title: "Atender a otro paciente",
    description:
    "Ingresa un segundo paciente del mismo grupo. Presenta alteración del estado de conciencia y signos de intoxicación más grave.",
    icon: Icons.personal_injury,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,
    result:
    "El paciente presenta deterioro neurológico, hipertermia y alteraciones autonómicas. Sus acompañantes mencionan que todos consumieron la misma sustancia.",
    condition: (game) =>
    game.flags.secondaryPatientResolved &&
        !game.flags.specialPatientArrived,
    onSuccess: (game) {
      game.flags.specialPatientArrived = true;
    },
    nextNode: "EXP2_SPECIAL_MANAGEMENT",
  ),

  // ============================================================
  // DECISIÓN CLÍNICA ESPECIAL
  // ============================================================

  "EXP2_SPECIAL_MANAGEMENT": Decision(
    id: "EXP2_SPECIAL_MANAGEMENT",
    expediente: 2,
    title: "Manejo del paciente grave",
    description:
    "El paciente presenta hipertermia, alteración del estado de conciencia y deterioro progresivo. Seleccionar la intervención prioritaria.",
    icon: Icons.monitor_heart,
    type: DecisionType.medical,
    location: Location.hospital,
    repeat: DecisionRepeat.once,
    apCost: 0,
    moneyCost: 200,
    trustChange: 15,
    successRate: 100,
    result:
    "El paciente responde al manejo y queda bajo vigilancia. Antes de mejorar menciona que la sustancia fue entregada por una persona a quien llamaban únicamente 'Quimera'.",
    condition: (game) =>
    game.flags.specialPatientArrived &&
        !game.flags.specialPatientResolved,
    onSuccess: (game) {
      game.flags.specialPatientResolved = true;
      game.flags.knowsAlias = true;
      game.flags.raveHouseSuspected = true;
    },
    evidence: "Referencia al nombre 'Quimera'",
    nextNode: "EXP2_RAVE_HOUSE_LEAD",
  ),
};