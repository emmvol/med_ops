import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';
import '../models/location.dart';

final Map<String, Decision> hospitalExpediente2Decisions = {

  // ============================================================
  // MINICASO • ALCOHOL
  // ============================================================

  "EXP2_OPEN_MINI_ALCOHOL": Decision(
    id: "EXP2_OPEN_MINI_ALCOHOL",
    expediente: 2,
    title: "Evaluar intoxicación por alcohol",
    description:
    "Valorar a un paciente con alteración del estado de conciencia "
        "posterior a consumo importante de alcohol.",
    icon: Icons.local_bar,
    type: DecisionType.medical,
    location: Location.hospital,

    // IMPORTANTE: ya no es repetible desde la decisión.
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 0,
    successRate: 100,

    result:
    "Se ha abierto el minicaso de intoxicación por alcohol.",

    evaluationId: "MINI_CASE_ALCOHOL",

    condition: (game) =>
    !game.flags.miniCaseAlcoholComplete,
  ),

  // ============================================================
  // MINICASO • COCAÍNA
  // ============================================================

  "EXP2_OPEN_MINI_COCAINE": Decision(
    id: "EXP2_OPEN_MINI_COCAINE",
    expediente: 2,
    title: "Evaluar intoxicación por cocaína",
    description:
    "Valorar a un paciente con agitación, diaforesis, "
        "midriasis, taquicardia e hipertensión posterior al "
        "consumo de una sustancia estimulante.",
    icon: Icons.bolt,
    type: DecisionType.medical,
    location: Location.hospital,

    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 0,
    successRate: 100,

    result:
    "Se ha abierto el minicaso de intoxicación por cocaína.",

    evaluationId: "MINI_CASE_COCAINE",

    condition: (game) =>
    !game.flags.miniCaseCocaineComplete,
  ),

  // ============================================================
  // MINICASO • CANNABIS
  // ============================================================

  "EXP2_OPEN_MINI_CANNABIS": Decision(
    id: "EXP2_OPEN_MINI_CANNABIS",
    expediente: 2,
    title: "Evaluar intoxicación por cannabis",
    description:
    "Valorar a un paciente con ansiedad, alteración de la "
        "percepción y taquicardia posterior al consumo de cannabis.",
    icon: Icons.grass,
    type: DecisionType.medical,
    location: Location.hospital,

    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 0,
    successRate: 100,

    result:
    "Se ha abierto el minicaso de intoxicación por cannabis.",

    evaluationId: "MINI_CASE_CANNABIS",

    condition: (game) =>
    !game.flags.miniCaseCannabisComplete,
  ),

  // ============================================================
  // MINICASO • ALUCINÓGENOS
  // ============================================================

  "EXP2_OPEN_MINI_HALLUCINOGENS": Decision(
    id: "EXP2_OPEN_MINI_HALLUCINOGENS",
    expediente: 2,
    title: "Evaluar intoxicación por alucinógenos",
    description:
    "Valorar a un paciente con alteraciones perceptivas, "
        "alucinaciones, ansiedad y midriasis después del consumo "
        "de una sustancia.",
    icon: Icons.visibility,
    type: DecisionType.medical,
    location: Location.hospital,

    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 0,
    successRate: 100,

    result:
    "Se ha abierto el minicaso de intoxicación por alucinógenos.",

    evaluationId: "MINI_CASE_HALLUCINOGENS",

    condition: (game) =>
    !game.flags.miniCaseHallucinogensComplete,
  ),

  // ============================================================
  // MINICASO • OPIOIDES
  // ============================================================

  "EXP2_OPEN_MINI_OPIOIDS": Decision(
    id: "EXP2_OPEN_MINI_OPIOIDS",
    expediente: 2,
    title: "Evaluar intoxicación por opioides",
    description:
    "Valorar a un paciente con alteración del estado de conciencia, "
        "miosis y depresión respiratoria posterior al consumo de una sustancia.",
    icon: Icons.local_hospital,
    type: DecisionType.medical,
    location: Location.hospital,

    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 0,
    successRate: 100,

    result:
    "Se ha abierto el minicaso de intoxicación por opioides.",

    evaluationId: "MINI_CASE_OPIOIDS",

    condition: (game) =>
    !game.flags.miniCaseOpioidsComplete,
  ),

  // ============================================================
  // MINICASO • BENZODIACEPINAS
  // ============================================================

  "EXP2_OPEN_MINI_BENZOS": Decision(
    id: "EXP2_OPEN_MINI_BENZOS",
    expediente: 2,
    title: "Evaluar intoxicación por benzodiacepinas",
    description:
    "Valorar a un paciente con somnolencia y depresión del "
        "sistema nervioso central posterior al consumo de fármacos.",
    icon: Icons.medication,
    type: DecisionType.medical,
    location: Location.hospital,

    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 0,
    successRate: 100,

    result:
    "Se ha abierto el minicaso de intoxicación por benzodiacepinas.",

    evaluationId: "MINI_CASE_BENZOS",

    condition: (game) =>
    !game.flags.miniCaseBenzosComplete,
  ),

  // ============================================================
  // MINICASO • POLISUSTANCIAS
  // ============================================================

  "EXP2_OPEN_MINI_POLY": Decision(
    id: "EXP2_OPEN_MINI_POLY",
    expediente: 2,
    title: "Evaluar intoxicación por polisustancias",
    description:
    "Valorar a un paciente con signos clínicos mixtos "
        "compatibles con exposición a múltiples sustancias.",
    icon: Icons.warning_amber,
    type: DecisionType.medical,
    location: Location.hospital,

    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 0,
    successRate: 100,

    result:
    "Se ha abierto el minicaso de intoxicación por polisustancias.",

    evaluationId: "MINI_CASE_POLY",

    condition: (game) =>
    !game.flags.miniCasePolyComplete,
  ),

  "EXP2_OPEN_INTEGRATION": Decision(
    id: "EXP2_OPEN_INTEGRATION",
    expediente: 2,
    title: "Integrar los casos clínicos",
    description:
    "Comparar los hallazgos de los pacientes y determinar "
        "si la información reunida permite establecer una línea "
        "de investigación común.",
    icon: Icons.fact_check,
    type: DecisionType.investigation,
    location: Location.hospital,

    repeat: DecisionRepeat.once,

    apCost: 0,
    moneyCost: 0,
    trustChange: 0,
    successRate: 100,

    result:
    "Se ha abierto la evaluación de integración del expediente.",

    evaluationId: "EVAL_EXP2_INTEGRATION",

    condition: (game) =>
    game.flags.miniCaseAlcoholComplete &&
        game.flags.miniCaseCocaineComplete &&
        game.flags.miniCaseCannabisComplete &&
        game.flags.miniCaseHallucinogensComplete &&
        game.flags.miniCaseOpioidsComplete &&
        game.flags.miniCaseBenzosComplete &&
        game.flags.miniCasePolyComplete &&
        !game.flags.exp2HospitalReviewComplete,
  ),
};