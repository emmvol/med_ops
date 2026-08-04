class RoundManager {

  int round = 1;

  int currentTeam = 0;

  void nextTurn(int totalTeams){

    currentTeam++;

    if(currentTeam >= totalTeams){

      currentTeam = 0;

      round++;

    }

  }

}