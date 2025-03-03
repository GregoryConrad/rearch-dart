import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hevy_smolov_jr/api/raw_hevy_api.dart';
import 'package:rearch/rearch.dart';

part 'wrapped_hevy_api.g.dart';
part 'wrapped_hevy_api.freezed.dart';

// NOTE: The stuff here is all pretty trivial--just API wrappers.
// ignore_for_file: public_member_api_docs

@freezed
sealed class ExerciseTemplatesResponse with _$ExerciseTemplatesResponse {
  const factory ExerciseTemplatesResponse({
    required int pageCount,
    required int page,
    required List<Exercise> exerciseTemplates,
  }) = _ExerciseTemplatesResponse;

  factory ExerciseTemplatesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExerciseTemplatesResponseFromJson(json);
}

@freezed
sealed class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String title,
    required String type,
    required String primaryMuscleGroup,
    required List<String> secondaryMuscleGroups,
    required String equipment,
    required bool isCustom,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}

final Capsule<Future<List<Exercise>>> exercisesCapsule = capsule((use) async {
  final get = use(apiGetAction);

  final exercises = <Exercise>[];
  var pageCount = 1;
  for (var page = 1; page <= pageCount; ++page) {
    final responseJson = await get(
      path: '/v1/exercise_templates',
      queryParams: {
        'page': page.toString(),
        'pageSize': '100', // NOTE: maximum allowed value according to docs
      },
    );
    final response = ExerciseTemplatesResponse.fromJson(responseJson);
    pageCount = response.pageCount;
    exercises.addAll(response.exerciseTemplates);
  }

  return exercises;
});

final Capsule<Future<int> Function({required String folderName})>
    createRoutineFolderAction = capsule((use) {
  final post = use(apiPostAction);
  return ({required String folderName}) async {
    final response = await post(
      path: '/v1/routine_folders',
      jsonBody: {
        'routine_folder': {
          'title': folderName,
        },
      },
    );
    return (response['routine_folder'] as Map)['id'] as int;
  };
});

@freezed
sealed class RoutineTemplate with _$RoutineTemplate {
  const factory RoutineTemplate({
    required String title,
    required List<RoutineTemplateExercise> exercises,
    String? notes,
    int? folderId,
  }) = _RoutineTemplate;

  factory RoutineTemplate.fromJson(Map<String, dynamic> json) =>
      _$RoutineTemplateFromJson(json);
}

@freezed
sealed class RoutineTemplateExercise with _$RoutineTemplateExercise {
  const factory RoutineTemplateExercise({
    required String exerciseTemplateId,
    required List<RoutineTemplateSet> sets,
    int? supersetId,
    int? restSeconds,
    String? notes,
  }) = _RoutineTemplateExercise;

  factory RoutineTemplateExercise.fromJson(Map<String, dynamic> json) =>
      _$RoutineTemplateExerciseFromJson(json);
}

@freezed
sealed class RoutineTemplateSet with _$RoutineTemplateSet {
  const factory RoutineTemplateSet._({
    required String type,
    num? weightKg,
    int? reps,
    int? distanceMeters,
    int? durationSeconds,
  }) = _RoutineTemplateSet;

  factory RoutineTemplateSet.fromJson(Map<String, dynamic> json) =>
      _$RoutineTemplateSetFromJson(json);

  factory RoutineTemplateSet.normal({
    num? weightKg,
    int? reps,
    int? distanceMeters,
    int? durationSeconds,
  }) {
    return RoutineTemplateSet._(
      type: 'normal',
      weightKg: weightKg,
      reps: reps,
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
    );
  }

  factory RoutineTemplateSet.warmup({
    num? weightKg,
    int? reps,
    int? distanceMeters,
    int? durationSeconds,
  }) {
    return RoutineTemplateSet._(
      type: 'warmup',
      weightKg: weightKg,
      reps: reps,
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
    );
  }

  factory RoutineTemplateSet.failure({
    num? weightKg,
    int? reps,
    int? distanceMeters,
    int? durationSeconds,
  }) {
    return RoutineTemplateSet._(
      type: 'failure',
      weightKg: weightKg,
      reps: reps,
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
    );
  }

  factory RoutineTemplateSet.dropset({
    num? weightKg,
    int? reps,
    int? distanceMeters,
    int? durationSeconds,
  }) {
    return RoutineTemplateSet._(
      type: 'dropset',
      weightKg: weightKg,
      reps: reps,
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
    );
  }
}

final Capsule<Future<void> Function(RoutineTemplate)> createRoutineAction =
    capsule((use) {
  final post = use(apiPostAction);
  return (RoutineTemplate routine) {
    return post(
      path: '/v1/routines',
      jsonBody: {'routine': routine.toJson()},
    );
  };
});

final Capsule<
    Future<void> Function({
      required String programName,
      required List<RoutineTemplate> routines,
    })> createProgramAction = capsule((use) {
  final createFolder = use(createRoutineFolderAction);
  final createRoutine = use(createRoutineAction);

  return ({
    required String programName,
    required List<RoutineTemplate> routines,
  }) async {
    final folderId = await createFolder(folderName: programName);
    for (final routine in routines) {
      await createRoutine(routine.copyWith(folderId: folderId));
    }
  };
});
