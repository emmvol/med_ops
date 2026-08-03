import 'team.dart';
import 'patient.dart';

class GameState {

  List<Team> teams;

  Patient patient;

  int currentTurn;

  int round;

  GameState({

    required this.teams,

    required this.patient,

    this.currentTurn = 0,

    this.round = 1,

  });

}