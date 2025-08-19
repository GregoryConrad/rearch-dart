import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:scorus/game_management.dart';
import 'package:scorus/score.dart';
import 'package:scorus/serving_player.dart';
import 'package:scorus/volley.dart';

// NOTE: this is simple example code
// ignore_for_file: public_member_api_docs

void main() {
  runApp(const ScorusApp());
}

class ScorusApp extends StatelessWidget {
  const ScorusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const RearchBootstrapper(
      child: MaterialApp(home: ScorusBody()),
    );
  }
}

class ScorusBody extends RearchConsumer {
  const ScorusBody({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final scoreTextStyle = Theme.of(context).textTheme.displayLarge;
    final (servingTeam, servingPlayer) = use(currServingTeamAndPlayerCapsule);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scorus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: use(resetGameAction),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: use(team1WonVolleyAction),
              child: Stack(
                children: [
                  ColoredBox(
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        '${use(team1ScoreManager).score}',
                        style: scoreTextStyle,
                      ),
                    ),
                  ),
                  if (servingTeam == Team.team1)
                    ServingPlayerCard(
                      servingPlayer: servingPlayer,
                      anchorOnTop: true,
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: use(team2WonVolleyAction),
              child: Stack(
                children: [
                  ColoredBox(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        '${use(team2ScoreManager).score}',
                        style: scoreTextStyle,
                      ),
                    ),
                  ),
                  if (servingTeam == Team.team2)
                    ServingPlayerCard(
                      servingPlayer: servingPlayer,
                      anchorOnTop: false,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServingPlayerCard extends StatelessWidget {
  const ServingPlayerCard({
    required this.servingPlayer,
    required this.anchorOnTop,
    super.key,
  });

  final ServingPlayer servingPlayer;
  final bool anchorOnTop;

  @override
  Widget build(BuildContext context) {
    final servingPlayerNumber = switch (servingPlayer) {
      ServingPlayer.player1 => 1,
      ServingPlayer.player2 => 2,
    };
    return Positioned(
      left: 0,
      right: 0,
      top: anchorOnTop ? 32 : null,
      bottom: anchorOnTop ? null : 32,
      child: Center(
        child: Card(
          color: Colors.white.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Player $servingPlayerNumber serving',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
      ),
    );
  }
}
