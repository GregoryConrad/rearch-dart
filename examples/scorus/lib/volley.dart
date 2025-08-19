import 'package:rearch/rearch.dart';
import 'package:scorus/game_management.dart';
import 'package:scorus/score.dart';
import 'package:scorus/serving_player.dart';

/// An action capsule that when invoked indicates team 1 won a volley.
void Function() team1WonVolleyAction(CapsuleHandle use) => use.volleyWinner(
  thisTeam: Team.team1,
  teamWithPossesion: use(teamWithPossesionManager).teamWithPossesion,
  incrementThisTeamScore: use(team1ScoreManager).incrementScore,
  giveServeToOtherTeamNextPlayer: use(
    team2ServingPlayerManager,
  ).giveServeToNextPlayer,
  otherTeamServingPlayer: use(team2ServingPlayerManager).servingPlayer,
  givePossesionToNextTeam: use(
    teamWithPossesionManager,
  ).givePossesionToNextTeam,
);

/// An action capsule that when invoked indicates team 2 won a volley.
void Function() team2WonVolleyAction(CapsuleHandle use) => use.volleyWinner(
  thisTeam: Team.team2,
  teamWithPossesion: use(teamWithPossesionManager).teamWithPossesion,
  incrementThisTeamScore: use(team2ScoreManager).incrementScore,
  giveServeToOtherTeamNextPlayer: use(
    team1ServingPlayerManager,
  ).giveServeToNextPlayer,
  otherTeamServingPlayer: use(team1ServingPlayerManager).servingPlayer,
  givePossesionToNextTeam: use(
    teamWithPossesionManager,
  ).givePossesionToNextTeam,
);

extension on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
  void Function() volleyWinner({
    required Team thisTeam,
    required Team teamWithPossesion,
    required void Function() incrementThisTeamScore,
    required void Function() giveServeToOtherTeamNextPlayer,
    required ServingPlayer otherTeamServingPlayer,
    required void Function() givePossesionToNextTeam,
  }) {
    final runTxn = use.transactionRunner();
    return () => runTxn(() {
      if (teamWithPossesion == thisTeam) {
        incrementThisTeamScore();
      } else {
        giveServeToOtherTeamNextPlayer();
        if (otherTeamServingPlayer == ServingPlayer.player2) {
          givePossesionToNextTeam();
        }
      }
    });
  }
}
