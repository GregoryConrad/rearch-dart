import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scorus/game_management.dart';
import 'package:scorus/main.dart';
import 'package:scorus/serving_player.dart';

void main() {
  testWidgets('score and serving player updates', (tester) async {
    Future<void> executeVolley({
      required Finder volleyWinner,
      required int team1Score,
      required int team2Score,
      required Team servingTeam,
      required ServingPlayer servingPlayer,
    }) async {
      await tester.tap(volleyWinner);
      await tester.pumpAndSettle();
      assertScores(team1Score: team1Score, team2Score: team2Score);
      assertServe(servingTeam, servingPlayer);
    }

    await tester.pumpWidget(const ScorusApp());
    assertScores(team1Score: 0, team2Score: 0);
    assertServe(Team.team1, ServingPlayer.player2);

    await executeVolley(
      volleyWinner: team1Stack,
      team1Score: 1,
      team2Score: 0,
      servingTeam: Team.team1,
      servingPlayer: ServingPlayer.player2,
    );
    await executeVolley(
      volleyWinner: team2Stack,
      team1Score: 1,
      team2Score: 0,
      servingTeam: Team.team2,
      servingPlayer: ServingPlayer.player1,
    );
    await executeVolley(
      volleyWinner: team1Stack,
      team1Score: 1,
      team2Score: 0,
      servingTeam: Team.team2,
      servingPlayer: ServingPlayer.player2,
    );
    await executeVolley(
      volleyWinner: team1Stack,
      team1Score: 1,
      team2Score: 0,
      servingTeam: Team.team1,
      servingPlayer: ServingPlayer.player1,
    );
    await executeVolley(
      volleyWinner: team2Stack,
      team1Score: 1,
      team2Score: 0,
      servingTeam: Team.team1,
      servingPlayer: ServingPlayer.player2,
    );
    await executeVolley(
      volleyWinner: team2Stack,
      team1Score: 1,
      team2Score: 0,
      servingTeam: Team.team2,
      servingPlayer: ServingPlayer.player1,
    );
    await executeVolley(
      volleyWinner: team2Stack,
      team1Score: 1,
      team2Score: 1,
      servingTeam: Team.team2,
      servingPlayer: ServingPlayer.player1,
    );
    await executeVolley(
      volleyWinner: team2Stack,
      team1Score: 1,
      team2Score: 2,
      servingTeam: Team.team2,
      servingPlayer: ServingPlayer.player1,
    );
    await executeVolley(
      volleyWinner: team1Stack,
      team1Score: 1,
      team2Score: 2,
      servingTeam: Team.team2,
      servingPlayer: ServingPlayer.player2,
    );

    // Reset game
    await tester.tap(find.byIcon(Icons.restart_alt_rounded));
    await tester.pumpAndSettle();
    assertScores(team1Score: 0, team2Score: 0);
    assertServe(Team.team1, ServingPlayer.player2);

    await executeVolley(
      volleyWinner: team1Stack,
      team1Score: 1,
      team2Score: 0,
      servingTeam: Team.team1,
      servingPlayer: ServingPlayer.player2,
    );
    await executeVolley(
      volleyWinner: team1Stack,
      team1Score: 2,
      team2Score: 0,
      servingTeam: Team.team1,
      servingPlayer: ServingPlayer.player2,
    );
    await executeVolley(
      volleyWinner: team2Stack,
      team1Score: 2,
      team2Score: 0,
      servingTeam: Team.team2,
      servingPlayer: ServingPlayer.player1,
    );
  });
}

final Finder team1Stack = find.byWidgetPredicate(
  (widget) =>
      widget is Stack &&
      widget.children.any(
        (child) => child is ColoredBox && child.color == Colors.red,
      ),
);
final Finder team2Stack = find.byWidgetPredicate(
  (widget) =>
      widget is Stack &&
      widget.children.any(
        (child) => child is ColoredBox && child.color == Colors.blue,
      ),
);

void assertServe(Team team, ServingPlayer player) {
  final (servingTeam, otherTeam) = switch (team) {
    Team.team1 => (team1Stack, team2Stack),
    Team.team2 => (team2Stack, team1Stack),
  };

  expect(
    find.descendant(
      of: servingTeam,
      matching: find.text('Player ${player.index + 1} serving'),
    ),
    findsOneWidget,
  );
  expect(
    find.descendant(
      of: otherTeam,
      matching: find.textContaining('serving'),
    ),
    findsNothing,
  );
}

void assertScores({required int team1Score, required int team2Score}) {
  expect(
    find.descendant(of: team1Stack, matching: find.text('$team1Score')),
    findsOneWidget,
  );
  expect(
    find.descendant(of: team2Stack, matching: find.text('$team2Score')),
    findsOneWidget,
  );
}
