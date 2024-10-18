import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:hevy_smolov_jr/api/wrapped_hevy_api.dart';
import 'package:hevy_smolov_jr/smolov_jr_config/config.dart';
import 'package:rearch/experimental.dart';
import 'package:rearch/rearch.dart';

/// Displays the exercise selection step contents.
// TODO(GregoryConrad): add exercise search feature
// - exercise search is based on levenshtein distance across words
// - remove the subtitle/note in the main.dart Steps list
class ExerciseSelectionStep extends RearchConsumer {
  /// Displays the exercise selection step contents.
  const ExerciseSelectionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final exercisesFuture = use(_curatedExercisesCapsule);
    final exercises = use.future(exercisesFuture);
    return switch (exercises) {
      AsyncLoading<List<Exercise>>() =>
        const Center(child: CircularProgressIndicator()),
      AsyncError<List<Exercise>>(:final error) => Text(
          '${error.runtimeType} encountered while loading your exercises; '
          'try checking your API key and/or refreshing the page.\n'
          '$error',
        ),
      AsyncData<List<Exercise>>(:final data) =>
        _CuratedExercisePicker(curatedExercises: data),
    };
  }
}

class _CuratedExercisePicker extends RearchConsumer {
  const _CuratedExercisePicker({required this.curatedExercises});
  final List<Exercise> curatedExercises;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final smolovJrConfig = ScopedSmolovJrConfig.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final exercise in curatedExercises)
            ChoiceChip(
              label: Text(exercise.title),
              selected: smolovJrConfig.value.exercise == exercise,
              onSelected: (selected) {
                smolovJrConfig.value =
                    smolovJrConfig.value.copyWith(exercise: exercise);
              },
            ),
        ],
      ),
    );
  }
}

final Capsule<List<String>> _curatedExerciseNamesCapsule = capsule((use) {
  return const [
    'Squat (Barbell)',
    'Bench Press (Barbell)',
    'Deadlift (Barbell)',
    'Pull Up (Weighted)',
    'Chin Up (Weighted)',
  ];
});

/// Pre-selected exercises from the entire exercise list,
/// including SBD and Weighted Pull/Chin Up.
final Capsule<Future<List<Exercise>>> _curatedExercisesCapsule =
    capsule((use) async {
  final curatedExerciseNames = use(_curatedExerciseNamesCapsule);
  final exercises = await use(exercisesCapsule);
  return curatedExerciseNames
      .map((name) => exercises.where((e) => e.title == name).firstOrNull)
      .whereType<Exercise>()
      .toList();
});

/// Provides a mechanism to search for exercises based on a provided query.
// final Capsule<Future<List<Exercise>> Function(String query)>
//     _searchExercisesAction = capsule((use) {
//   final exercisesFuture = use(exercisesCapsule);
//   return (query) async {
//     return exercisesFuture;
//   };
// });
