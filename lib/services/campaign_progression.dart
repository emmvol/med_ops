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

      case 1:
        return true;

      case 2:
        return game.flags.evalExp1IntegrationCompleted;

      case 3:
        return game.flags.evalExp2IntegrationCompleted;

      case 4:
        return game.flags.evalExp3IntegrationCompleted;

      case 5:
        return game.flags.evalExp4IntegrationCompleted;

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