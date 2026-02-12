// NOTE: we're only using experimental APIs from this repo
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hevy_smolov_jr/api/wrapped_hevy_api.dart';
import 'package:hevy_smolov_jr/smolov_jr_config/config.dart';
import 'package:rearch/experimental.dart';
import 'package:rearch/rearch.dart';

/// Displays the exercise selection step contents.
class ExerciseSelectionStep extends RearchConsumer {
  /// Displays the exercise selection step contents.
  const ExerciseSelectionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final exercisesFuture = use(_curatedExercisesCapsule);
    final exercises = use.future(exercisesFuture);
    return switch (exercises) {
      AsyncLoading<List<Exercise>>() => const Center(
        child: CircularProgressIndicator(),
      ),
      AsyncError<List<Exercise>>(:final error) => Text(
        'Error encountered while loading your exercises; '
        'try checking your API key and/or refreshing the page.\n'
        '$error',
      ),
      AsyncData<List<Exercise>>(:final data) => Column(
        children: [
          const _AllExercisePicker(),
          const SizedBox(height: 16),
          _CuratedExercisePicker(curatedExercises: data),
        ],
      ),
    };
  }
}

class _CuratedExercisePicker extends StatelessWidget {
  const _CuratedExercisePicker({required this.curatedExercises});
  final List<Exercise> curatedExercises;

  @override
  Widget build(BuildContext context) {
    final smolovJrConfig = SmolovJrConfigInjection.of(context);
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
              onSelected: (selected) => smolovJrConfig.updateWith(
                (config) => config.copyWith(exercise: exercise),
              ),
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
final Capsule<Future<List<Exercise>>> _curatedExercisesCapsule = capsule((
  use,
) async {
  final curatedExerciseNames = use(_curatedExerciseNamesCapsule);
  final exercises = await use(exercisesCapsule);
  return curatedExerciseNames
      .map((name) => exercises.where((e) => e.title == name).firstOrNull)
      .nonNulls
      .toList();
});

class _AllExercisePicker extends RearchConsumer {
  const _AllExercisePicker();

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final searchExercises = use(_searchExercisesAction);
    final smolovJrConfig = SmolovJrConfigInjection.of(context);
    return SearchAnchor.bar(
      barHintText: 'Search for an exercise...',
      viewConstraints: const BoxConstraints(maxHeight: 464),
      suggestionsBuilder: (context, controller) async {
        final exercises = await searchExercises(controller.text);
        return [
          for (final exercise in exercises)
            ListTile(
              title: Text(exercise.title),
              subtitle: Text(exercise.primaryMuscleGroup.replaceAll('_', ' ')),
              onTap: () {
                controller.closeView(exercise.title);
                smolovJrConfig.updateWith(
                  (config) => config.copyWith(exercise: exercise),
                );
              },
            ),
        ];
      },
    );
  }
}

/// Provides a mechanism to search for exercises based on a provided query.
final Capsule<Future<List<Exercise>> Function(String query)>
_searchExercisesAction = capsule((use) {
  final exercisesFuture = use(exercisesCapsule);
  return (query) async {
    final exercises = await exercisesFuture;
    if (query == '') return exercises;
    return extractAllSorted(
      query: query,
      cutoff: 50,
      choices: exercises,
      getter: (e) => e.title,
    ).map((result) => result.choice).toList();
  };
});
