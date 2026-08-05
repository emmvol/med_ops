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

    apCost: 1,

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

    apCost: 2,

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

    apCost: 1,

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

    apCost: 2,

    moneyCost: 400,

    trustChange: 10,

    result: "Se confirma cocaína adulterada con una sustancia desconocida.",

    evidence: "Informe confirmatorio",

    nextNode: "CONFIRM",

    successRate: 95,

    failResult: "La muestra fue insuficiente para confirmar el resultado.",

    failNode: "LAB",

  ),

  "VITALS": Decision(
    id: "VITALS",
    title: "Valorar signos vitales",
    description: "Registrar signos vitales completos.",
    icon: Icons.monitor_heart,
    type: DecisionType.medical,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    result: "Se detecta taquicardia, hipertensión y midriasis.",
    nextNode: "VITALS",
  ),

  "GLUCOSE": Decision(
    id: "GLUCOSE",
    title: "Medir glucosa",
    description: "Realizar glucemia capilar.",
    icon: Icons.bloodtype,
    type: DecisionType.medical,
    apCost: 1,
    moneyCost: 50,
    trustChange: 5,
    result: "La glucosa se encuentra dentro de parámetros normales.",
    nextNode: "PRIMARY",
  ),

  "ECG": Decision(
    id: "ECG",
    title: "Solicitar ECG",
    description: "Buscar alteraciones cardíacas.",
    icon: Icons.favorite,
    type: DecisionType.medical,
    apCost: 2,
    moneyCost: 250,
    trustChange: 8,
    result: "El ECG muestra taquicardia sinusal.",
    nextNode: "ECG",
  ),

  "SEARCH_BODY": Decision(
    id: "SEARCH_BODY",
    title: "Explorar ropa del paciente",
    description: "Buscar objetos ocultos.",
    icon: Icons.search,
    type: DecisionType.investigation,
    apCost: 1,
    moneyCost: 0,
    trustChange: 4,
    result: "Encuentras un encendedor, dinero y una pulsera fluorescente.",
    evidence: "Pulsera del rave",
    nextNode: "BODY_SEARCH",
  ),

  "QUESTION_PARAMEDICS": Decision(
    id: "QUESTION_PARAMEDICS",
    title: "Interrogar paramédicos",
    description: "Preguntar cómo encontraron al paciente.",
    icon: Icons.local_hospital,
    type: DecisionType.interview,
    apCost: 1,
    moneyCost: 0,
    trustChange: 6,
    result: "Mencionan que había otras tres víctimas en la misma zona.",
    nextNode: "PARAMEDICS",
  ),

  "CALL_POLICE": Decision(
    id: "CALL_POLICE",
    title: "Contactar a la policía",
    description: "Solicitar apoyo e información.",
    icon: Icons.local_police,
    type: DecisionType.legal,
    apCost: 1,
    moneyCost: 0,
    trustChange: 10,
    result: "La policía abre colaboración con el hospital.",
    nextNode: "POLICE",
  ),

  "OBSERVE": Decision(
    id: "OBSERVE",
    title: "Observación clínica",
    description: "Esperar evolución clínica.",
    icon: Icons.visibility,
    type: DecisionType.medical,
    apCost: 1,
    moneyCost: 0,
    trustChange: -2,
    result: "El paciente permanece estable durante algunos minutos.",
    nextNode: "PRIMARY",
  ),

};