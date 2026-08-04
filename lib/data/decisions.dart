import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';

final Map<String, Decision> decisions = {

  "ABC": Decision(

    id: "ABC",

    title: "Evaluación primaria",

    description: "Realizar abordaje ABC y estabilizar al paciente.",

    icon: Icons.health_and_safety,

    type: DecisionType.medical,

    duration: 1,

    moneyCost: 150,

    trustChange: 20,

    result: "La vía aérea queda asegurada y el paciente mejora parcialmente.",

    nextNode: "PRIMARY",

    successRate: 95,

    failResult: "La estabilización fue insuficiente.",

    failNode: "START",

  ),

  "LAB": Decision(

    id: "LAB",

    title: "Solicitar laboratorio",

    description: "Enviar muestras para análisis toxicológico.",

    icon: Icons.science,

    type: DecisionType.investigation,

    duration: 1,

    moneyCost: 300,

    trustChange: 15,

    result: "El laboratorio detecta metabolitos compatibles con cocaína.",

    evidence: "Laboratorio positivo",

    nextNode: "LAB",

    successRate: 100,

  ),

  "BACKPACK": Decision(

    id: "BACKPACK",

    title: "Revisar pertenencias",

    description: "Inspeccionar mochila y objetos personales.",

    icon: Icons.backpack,

    type: DecisionType.investigation,

    duration: 1,

    moneyCost: 0,

    trustChange: 5,

    result: "Encuentras un teléfono celular y un ticket.",

    evidence: "Teléfono celular",

    nextNode: "BACKPACK",

    successRate: 100,

  ),

  "CONFIRM": Decision(

    id: "CONFIRM",

    title: "Análisis confirmatorio",

    description: "Solicitar confirmación por laboratorio especializado.",

    icon: Icons.biotech,

    type: DecisionType.investigation,

    duration: 2,

    moneyCost: 400,

    trustChange: 10,

    result: "Se confirma cocaína adulterada con una sustancia desconocida.",

    evidence: "Informe confirmatorio",

    nextNode: "CONFIRM",

    successRate: 95,

    failResult: "La muestra fue insuficiente para confirmar el resultado.",

    failNode: "LAB",

  ),

};