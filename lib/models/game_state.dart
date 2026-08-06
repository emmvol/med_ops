import 'package:med_ops/models/round_manager.dart';

import 'game_flags.dart';
import 'patient.dart';
import 'team.dart';

class GameState {

  List<Team> teams;

  Patient patient;

  /// Acciones ya realizadas globalmente
  final Set<String> completedActions;

  final RoundManager roundManager;

  final GameFlags flags;

  int currentExpediente = 1;

  GameState({

    required this.teams,
    required this.patient,

    Set<String>? completedActions,
    RoundManager? roundManager,
    GameFlags? flags,

  })  : completedActions = completedActions ?? {},
        flags = flags ?? GameFlags(),
        roundManager = roundManager ?? RoundManager();

}