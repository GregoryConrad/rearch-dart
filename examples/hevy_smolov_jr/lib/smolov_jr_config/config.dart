// NOTE: we're only using experimental APIs from this repo
// ignore_for_file: experimental_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_rearch/experimental.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hevy_smolov_jr/api/wrapped_hevy_api.dart';
import 'package:rearch/rearch.dart';

part 'config.freezed.dart';

/// Represents the valid weight units.
enum WeightUnit {
  /// The pound weight unit.
  lb,

  /// The kilogram weight unit.
  kg,
}

extension on WeightUnit {
  num toKg(num amount) {
    return switch (this) {
      WeightUnit.lb => amount * 0.45359237,
      WeightUnit.kg => amount,
    };
  }
}

/// Represents the necessary config for the Smolov Jr program.
@freezed
sealed class SmolovJrConfig with _$SmolovJrConfig {
  /// Creates a [SmolovJrConfig].
  const factory SmolovJrConfig({
    /// 1rm _without_ bodyweight included, in case this is a body weight lift
    required Exercise? exercise,
    required num oneRepMax,
    required num bodyWeight,
    required int? restSeconds,
    required num increment,
    required WeightUnit unit,
  }) = _SmolovJrConfig;

  /// Creates the initial [SmolovJrConfig].
  factory SmolovJrConfig.initial() {
    return const SmolovJrConfig(
      exercise: null,
      oneRepMax: 100,
      bodyWeight: 100,
      restSeconds: 3 * 60,
      increment: 5,
      unit: WeightUnit.lb,
    );
  }
}

/// Provides several convenience functions on the [SmolovJrConfig].
extension SmolovJrConfigConvenience on SmolovJrConfig {
  /// If [exercise] is set, and it's a bodyweight-based exercise, returns true,
  /// false otherwise.
  bool get isBodyWeight =>
      exercise != null && exercise!.type.contains('bodyweight');

  /// Creates a Smolov Jr for Hevy using this [SmolovJrConfig].
  ({String programName, List<RoutineTemplate> routines}) toProgram() {
    if (exercise == null) throw StateError('No exercise selected');
    final totalOneRepMax = isBodyWeight ? (bodyWeight + oneRepMax) : oneRepMax;

    final smolovJrDays = [
      (day: 'Monday', sets: 6, reps: 6, starting1rmPercent: 0.70),
      (day: 'Wednesday', sets: 7, reps: 5, starting1rmPercent: 0.75),
      (day: 'Friday', sets: 8, reps: 4, starting1rmPercent: 0.80),
      (day: 'Saturday', sets: 10, reps: 3, starting1rmPercent: 0.85),
    ];

    final routines = <RoutineTemplate>[];
    for (final week in Iterable.generate(3, (i) => i + 1)) {
      for (final (:day, :sets, :reps, :starting1rmPercent) in smolovJrDays) {
        final weightIncrement = (week - 1) * increment;
        final totalWeight =
            starting1rmPercent * totalOneRepMax + weightIncrement;
        final weight = isBodyWeight ? (totalWeight - bodyWeight) : totalWeight;

        routines.add(
          RoutineTemplate(
            title: 'Week $week — $day',
            notes: '${sets}x$reps @ ${weight.toStringAsFixed(2)} ${unit.name}',
            exercises: [
              RoutineTemplateExercise(
                exerciseTemplateId: exercise!.id,
                restSeconds: restSeconds,
                notes: isBodyWeight
                    ? 'Calculated weight assumes a body weight of $bodyWeight; '
                          'adjust your set weight up/down accordingly.'
                    : null,
                sets: List.generate(
                  sets,
                  (_) => RoutineTemplateSet.normal(
                    reps: reps,
                    weightKg: unit.toKg(weight).toDouble(),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    return (
      programName: 'Smolov Jr for ${exercise!.title}',
      routines: routines,
    );
  }
}

/// Provides the current [SmolovJrConfig] to descendants in the [Widget] tree.
class SmolovJrConfigInjection
    extends
        RearchInjection<SmolovJrConfigInjection, ValueWrapper<SmolovJrConfig>> {
  /// Provides the current [SmolovJrConfig] to descendants in the [Widget] tree.
  const SmolovJrConfigInjection({required super.child, super.key});

  @override
  ValueWrapper<SmolovJrConfig> build(BuildContext context, WidgetHandle use) {
    return use.lazyData(SmolovJrConfig.initial);
  }

  /// Provides the current [SmolovJrConfig] to descendants in the [Widget] tree.
  static ValueWrapper<SmolovJrConfig> of(BuildContext context) {
    return RearchInjection.of<
      SmolovJrConfigInjection,
      ValueWrapper<SmolovJrConfig>
    >(context);
  }
}
