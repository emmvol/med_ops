import 'package:med_ops/models/round_manager.dart';

import 'patient.dart';
import 'team.dart';

class GameState {

  List<Team> teams;

  Patient patient;

  /// Acciones ya realizadas globalmente
  final Set<String> completedActions;

  final RoundManager roundManager;

  GameState({

    required this.teams,
    required this.patient,

    Set<String>? completedActions,
    RoundManager? roundManager,

  })  : completedActions = completedActions ?? {},
        roundManager = roundManager ?? RoundManager();

}