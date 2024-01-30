import 'package:rearch/rearch.dart';
import 'package:scorus/score.dart';
import 'package:scorus/serving_player.dart';

/// Represents a team.
enum Team {
  /// The first team.
  team1,

  /// The second team.
  team2,
}

/// Provides [next].
extension NextTeam on Team {
  /// Returns the next [Team] up for possesion.
  Team get next => switch (this) {
        Team.team1 => Team.team2,
        Team.team2 => Team.team1,
      };
}

/// Manages the current team with possesion.
({
  Team teamWithPossesion,
  void Function() givePossesionToNextTeam,
  void Function() resetTeamWithPossesion,
}) teamWithPossesionManager(CapsuleHandle use) {
  const startingTeam = Team.team1;
  final (team, setTeam) = use.state(startingTeam);
  return (
    teamWithPossesion: team,
    givePossesionToNextTeam: () => setTeam(team.next),
    resetTeamWithPossesion: () => setTeam(startingTeam),
  );
}

/// Returns which team and which player on that team is serving.
(Team, ServingPlayer) currServingTeamAndPlayerCapsule(CapsuleHandle use) {
  final teamWithPossesion = use(teamWithPossesionManager).teamWithPossesion;
  final servingPlayerOnTeamWithPossesion = switch (teamWithPossesion) {
    Team.team1 => use(team1ServingPlayerManager).servingPlayer,
    Team.team2 => use(team2ServingPlayerManager).servingPlayer,
  };
  return (teamWithPossesion, servingPlayerOnTeamWithPossesion);
}

/// Action capsule that returns a function to reset the game.
void Function() resetGameAction(CapsuleHandle use) {
  final resets = [
    use(team1ScoreManager).resetScore,
    use(team2ScoreManager).resetScore,
    use(team1ServingPlayerManager).resetServingPlayer,
    use(team2ServingPlayerManager).resetServingPlayer,
    use(teamWithPossesionManager).resetTeamWithPossesion,
  ];
  final runTxn = use.transactionRunner();
  return () => runTxn(() {
        for (final reset in resets) {
          reset();
        }
      });
}
