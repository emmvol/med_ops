// lib/services/finalizer.dart
import '../models/game_state.dart';

class FinalOutcome {
  final String endingId;
  final bool patientAlive;
  final String firstTrustTeam;
  final String firstMoneyTeam;
  final String firstEvidenceTeam;
  final Map<String, Map<String, int>> scoresByTeam;

  FinalOutcome({
    required this.endingId,
    required this.patientAlive,
    required this.firstTrustTeam,
    required this.firstMoneyTeam,
    required this.firstEvidenceTeam,
    required this.scoresByTeam,
  });
}

class Finalizer {
  /// Calcula el desenlace final y aplica pequeñas recompensas a los ganadores.
  static FinalOutcome computeFinalOutcome(GameState game) {
    final teams = [...game.teams];

    // Guardar puntajes por equipo para UI
    final scoresByTeam = <String, Map<String, int>>{};
    for (final t in teams) {
      scoresByTeam[t.name] = {
        'trust': t.trust,
        'money': t.money,
        'evidence': t.evidence.length,
      };
    }

    // Determinar primeros puestos
    teams.sort((a, b) => b.trust.compareTo(a.trust));
    final firstTrust = teams.first;

    teams.sort((a, b) => b.money.compareTo(a.money));
    final firstMoney = teams.first;

    teams.sort((a, b) => b.evidence.length.compareTo(a.evidence.length));
    final firstEvidence = teams.first;

    // Aplicar recompensas de reconocimiento (ligeras, no rompedoras)
    firstTrust.trust += 10;
    firstMoney.money += 200;

    // Determinar ending según flags
    final flags = game.flags;
    String endingId;

    if (!flags.omegaQuestionnaireCompleted) {
      // No respondieron el cuestionario final: la organización escapa
      endingId = 'ENDING_ESCAPE';
    } else {
      // Respondieron, verificar si encontraron la ubicación correcta
      if (!flags.omegaCorrectLocationFound) {
        endingId = 'ENDING_ESCAPE';
      } else {
        // Encontraron. Revisar método de entrada.
        if (!flags.omegaEntryBySpecialists) {
          // Entrar solos: riesgo de fracaso.
          endingId = flags.patientDead ? 'ENDING_BAD' : 'ENDING_MEDIUM';
        } else {
          // Entraron con equipo: mejor final
          endingId = flags.patientDead ? 'ENDING_MEDIUM' : 'ENDING_BEST';
        }
      }
    }

    return FinalOutcome(
      endingId: endingId,
      patientAlive: !flags.patientDead,
      firstTrustTeam: firstTrust.name,
      firstMoneyTeam: firstMoney.name,
      firstEvidenceTeam: firstEvidence.name,
      scoresByTeam: scoresByTeam,
    );
  }
}