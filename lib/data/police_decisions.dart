import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';
import '../models/location.dart';

final Map<String, Decision> policeDecisions = {

  // ============================================================
  // EXPEDIENTE 2 — COMISARÍA
  // INVESTIGACIÓN DE LA FIESTA
  // ============================================================

  "POLICE_BRIEFING": Decision(
    id: "POLICE_BRIEFING",
    expediente: 2,
    title: "Presentar el caso",
    description:
    "Informar a los agentes sobre el paciente índice, las demás intoxicaciones y la posible relación con una fiesta.",
    icon: Icons.local_police,
    type: DecisionType.legal,
    location: Location.police,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 5,
    successRate: 100,
    result:
    "Los agentes relacionan el caso con un evento realizado recientemente y ofrecen acceso a los testigos identificados.",
    condition: (game) =>
    game.flags.policeCalled &&
        game.flags.policeTrust,
  ),

  // ============================================================
  // TESTIGO
  // ============================================================

  "POLICE_WITNESS": Decision(
    id: "POLICE_WITNESS",
    expediente: 2,
    title: "Interrogar al testigo",
    description:
    "Obtener información sobre la fiesta, los asistentes y las personas que permanecieron en el lugar.",
    icon: Icons.record_voice_over,
    type: DecisionType.interview,
    location: Location.police,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: 0,
    trustChange: 8,
    successRate: 100,
    result:
    "El testigo confirma que varias personas comenzaron a presentar síntomas durante la fiesta y señala el domicilio donde permanecieron algunos asistentes.",
    evidence: "Declaración de testigo",
    condition: (game) =>
    game.flags.policeCalled &&
        !game.flags.witnessInterviewed,
    onSuccess: (game) {
      game.flags.witnessInterviewed = true;
      game.flags.raveHouseSuspected = true;
    },
    nextNode: "EXP2_RAVE_HOUSE_LEAD",
  ),

  // ============================================================
  // TELÉFONO
  // ============================================================

  "POLICE_TRACK_PHONE": Decision(
    id: "POLICE_TRACK_PHONE",
    expediente: 2,
    title: "Rastrear teléfono",
    description:
    "Solicitar la localización del teléfono encontrado entre las pertenencias del paciente índice.",
    icon: Icons.phone_android,
    type: DecisionType.investigation,
    location: Location.police,
    repeat: DecisionRepeat.once,
    apCost: 2,
    moneyCost: 100,
    trustChange: 10,
    successRate: 100,
    result:
    "La última ubicación registrada sitúa el teléfono cerca del domicilio donde se realizó la fiesta.",
    evidence: "Localización del teléfono",
    condition: (game) =>
    game.flags.foundPhone &&
        !game.flags.phoneTracked,
    onSuccess: (game) {
      game.flags.phoneTracked = true;
      game.flags.raveHouseSuspected = true;
    },
    nextNode: "EXP2_RAVE_HOUSE_LEAD",
  ),

  // ============================================================
  // ORGANIZADOR
  // ============================================================

  "POLICE_ORGANIZER": Decision(
    id: "POLICE_ORGANIZER",
    expediente: 2,
    title: "Interrogar al organizador",
    description:
    "Cuestionar al presunto organizador sobre los asistentes, las sustancias disponibles y lo ocurrido durante la fiesta.",
    icon: Icons.gavel,
    type: DecisionType.interview,
    location: Location.police,
    repeat: DecisionRepeat.once,
    apCost: 2,
    moneyCost: 0,
    trustChange: 10,
    successRate: 100,
    result:
    "El organizador proporciona información contradictoria, pero confirma que varias personas permanecieron en el domicilio después de que comenzaron las intoxicaciones.",
    evidence: "Declaración del organizador",
    condition: (game) =>
    game.flags.witnessInterviewed &&
        !game.flags.organizerInterviewed,
    onSuccess: (game) {
      game.flags.organizerInterviewed = true;
      game.flags.raveHouseSuspected = true;
    },
    nextNode: "EXP2_RAVE_HOUSE_LEAD",
  ),

  "POLICE_CORRELATE_EVIDENCE": Decision(
    id: "POLICE_CORRELATE_EVIDENCE",
    expediente: 2,
    title: "Correlacionar información",
    description:
    "Comparar la declaración del testigo, la localización del teléfono y la información obtenida del organizador.",
    icon: Icons.account_tree,
    type: DecisionType.investigation,
    location: Location.police,
    repeat: DecisionRepeat.once,

    apCost: 1,
    moneyCost: 0,
    trustChange: 12,
    successRate: 100,

    result:
    "Las declaraciones y los registros de localización coinciden en un mismo domicilio. La policía autoriza la investigación del inmueble.",

    condition: (game) =>
    game.flags.witnessInterviewed &&
        game.flags.phoneTracked &&
        game.flags.organizerInterviewed &&
        !game.flags.raveHouseIdentified,

    onSuccess: (game) {
      game.flags.raveHouseIdentified = true;
      // Desbloquear evaluación integradora del expediente 2
      if (!game.unlockedEvaluations.contains("EVAL_EXP2_INTEGRATION")) {
        game.unlockedEvaluations.add("EVAL_EXP2_INTEGRATION");
      }
    },
  ),

  "DEC_PAY_BRIBE_ACCESS": Decision(
    id: "DEC_PAY_BRIBE_ACCESS",
    expediente: 3,
    title: "Pagar soborno para acceso",
    description: "Pagar por acceso a evidencia privada (gana rapidez, pierde reputación).",
    icon: Icons.monetization_on,
    type: DecisionType.investigation,
    location: Location.police,
    repeat: DecisionRepeat.once,
    apCost: 1,
    moneyCost: -200, // convención del repo: negativo puede significar ingreso/beneficio
    trustChange: -15,
    successRate: 90,
    result: "Se obtuvo acceso rápido, pero la reputación del equipo disminuyó.",
  ),
};