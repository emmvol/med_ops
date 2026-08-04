import 'package:med_ops/models/round_manager.dart';

import 'team.dart';
import 'patient.dart';

class GameState {

  List<Team> teams;

  Patient patient;

  int currentTurn;

  int round;

  /// Acciones ya realizadas sobre el caso
  final Set<String> completedActions;

  final RoundManager roundManager;

  GameState({

    required this.teams,

    required this.patient,

    this.currentTurn = 0,

    this.round = 1,

    Set<String>? completedActions,

    RoundManager? roundManager,

  }) :
  completedActions = completedActions ?? {},
        roundManager = roundManager ?? RoundManager();

}