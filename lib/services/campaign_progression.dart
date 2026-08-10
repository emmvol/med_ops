import '../models/game_state.dart';

class CampaignProgression {

  // ============================================================
  // SIGUIENTE EXPEDIENTE REALMENTE DISPONIBLE
  // ============================================================

  static int getNextExpediente(GameState game) {

    if (!game.flags.exp1Complete) {
      return 1;
    }

    if (!canStartExpediente(game, 2)) {
      return 2;
    }

    if (!canStartExpediente(game, 3)) {
      return 3;
    }

    if (!canStartExpediente(game, 4)) {
      return 4;
    }

    if (!canStartExpediente(game, 5)) {
      return 5;
    }

    return 6;
  }

  // ============================================================
  // ¿PUEDE INICIAR EL EXPEDIENTE?
  // ============================================================

  static bool canStartExpediente(
      GameState game,
      int expediente,
      ) {

    switch (expediente) {

    // --------------------------------------------------------
    // EXPEDIENTE 1
    // --------------------------------------------------------

      case 1:
        return true;

    // --------------------------------------------------------
    // EXPEDIENTE 2
    // --------------------------------------------------------

      case 2:
        return game.flags.exp1Complete;

    // --------------------------------------------------------
    // EXPEDIENTE 3
    // --------------------------------------------------------
    // NO basta con encontrar evidencia.
    // Debe haberse completado la revisión hospitalaria
    // y HABER IDENTIFICADO FORMALMENTE el domicilio.

      case 3:
        return game.flags.exp2HospitalReviewComplete &&
            game.flags.raveHouseIdentified &&
            game.flags.raveHouseUnlocked;

    // --------------------------------------------------------
    // EXPEDIENTE 4
    // --------------------------------------------------------
    // La escena solo puede iniciar después de integrar
    // formalmente el expediente 3.

      case 4:
        return game.flags.exp3Complete &&
            game.flags.crimeSceneUnlocked;

    // --------------------------------------------------------
    // EXPEDIENTE 5
    // --------------------------------------------------------
    // El almacén solo aparece después de completar
    // la integración médico-legal del expediente 4.

      case 5:
        return game.flags.exp4Complete &&
            game.flags.warehouseUnlocked;

      default:
        return false;
    }
  }

  // ============================================================
  // CAMPAÑA TERMINADA
  // ============================================================

  static bool isCampaignComplete(GameState game) {
    return game.flags.exp5Complete;
  }
}