import 'package:rearch/rearch.dart';

/// Represents the currently serving player.
enum ServingPlayer {
  /// Player #1.
  player1,

  /// Player #2.
  player2,
}

/// Provides [next].
extension NextPlayer on ServingPlayer {
  /// Returns the next [ServingPlayer] in the serving order.
  ServingPlayer get next => switch (this) {
        ServingPlayer.player1 => ServingPlayer.player2,
        ServingPlayer.player2 => ServingPlayer.player1,
      };
}

/// Represents what a [ServingPlayer] manager should be able to do.
typedef ServingPlayerManager = ({
  ServingPlayer servingPlayer,
  void Function() giveServeToNextPlayer,
  void Function() resetServingPlayer,
});

/// Manages the [ServingPlayer] for the first team.
ServingPlayerManager team1ServingPlayerManager(CapsuleHandle use) =>
    use.servingPlayer(startingPlayer: ServingPlayer.player2);

/// Manages the [ServingPlayer] for the second team.
ServingPlayerManager team2ServingPlayerManager(CapsuleHandle use) =>
    use.servingPlayer(startingPlayer: ServingPlayer.player1);

extension on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
  ServingPlayerManager servingPlayer({required ServingPlayer startingPlayer}) {
    final (servingPlayer, setServingPlayer) = use.state(startingPlayer);
    return (
      servingPlayer: servingPlayer,
      giveServeToNextPlayer: () => setServingPlayer(servingPlayer.next),
      resetServingPlayer: () => setServingPlayer(startingPlayer),
    );
  }
}
