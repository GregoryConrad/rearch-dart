import 'package:rearch/rearch.dart';

/// Defines what a score management [Capsule] can do.
typedef ScoreManager = ({
  int score,
  void Function() incrementScore,
  void Function() resetScore,
});

/// Manages the score for the first team.
ScoreManager team1ScoreManager(CapsuleHandle use) => use.teamScore();

/// Manages the score for the second team.
ScoreManager team2ScoreManager(CapsuleHandle use) => use.teamScore();

extension on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
  ScoreManager teamScore() {
    final (score, setScore) = use.state(0);
    return (
      score: score,
      incrementScore: () => setScore(score + 1),
      resetScore: () => setScore(0),
    );
  }
}
