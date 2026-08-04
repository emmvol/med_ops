import '../models/decision.dart';

final Map<String, Decision> decisions = {

  "LAB": Decision(

    id: "LAB",

    title: "Solicitar laboratorio",

    description: "Enviar muestras para análisis.",

    moneyCost: 300,

    trustChange: 15,

    result: "El laboratorio encuentra metabolitos compatibles con cocaína.",

    evidence: "Laboratorio positivo",

    nextNode: "LAB",

  ),

  "ABC": Decision(

    id: "ABC",

    title: "Evaluación primaria",

    description: "Realizar abordaje ABC.",

    moneyCost: 150,

    trustChange: 20,

    result: "El paciente queda estabilizado parcialmente.",

    nextNode: "PRIMARY",

  ),

  "BACKPACK": Decision(

    id: "BACKPACK",

    title: "Revisar pertenencias",

    description: "Inspeccionar mochila y ropa.",

    moneyCost: 0,

    trustChange: 5,

    result: "Encuentras un teléfono y un ticket.",

    evidence: "Teléfono celular",

    nextNode: "BACKPACK",

  ),

  "CONFIRM": Decision(

    id: "CONFIRM",

    title: "Análisis confirmatorio",

    description: "Confirmar la sustancia.",

    moneyCost: 400,

    trustChange: 10,

    result: "Se confirma cocaína adulterada.",

    nextNode: "CONFIRM",

  ),

};