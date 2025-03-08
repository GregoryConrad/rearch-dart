// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapped_hevy_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseTemplatesResponse _$ExerciseTemplatesResponseFromJson(
        Map<String, dynamic> json) =>
    _ExerciseTemplatesResponse(
      pageCount: (json['page_count'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      exerciseTemplates: (json['exercise_templates'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExerciseTemplatesResponseToJson(
        _ExerciseTemplatesResponse instance) =>
    <String, dynamic>{
      'page_count': instance.pageCount,
      'page': instance.page,
      'exercise_templates': instance.exerciseTemplates,
    };

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      primaryMuscleGroup: json['primary_muscle_group'] as String,
      secondaryMuscleGroups: (json['secondary_muscle_groups'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      equipment: json['equipment'] as String,
      isCustom: json['is_custom'] as bool,
    );

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'primary_muscle_group': instance.primaryMuscleGroup,
      'secondary_muscle_groups': instance.secondaryMuscleGroups,
      'equipment': instance.equipment,
      'is_custom': instance.isCustom,
    };

_RoutineTemplate _$RoutineTemplateFromJson(Map<String, dynamic> json) =>
    _RoutineTemplate(
      title: json['title'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) =>
              RoutineTemplateExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      folderId: (json['folder_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RoutineTemplateToJson(_RoutineTemplate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'exercises': instance.exercises,
      'notes': instance.notes,
      'folder_id': instance.folderId,
    };

_RoutineTemplateExercise _$RoutineTemplateExerciseFromJson(
        Map<String, dynamic> json) =>
    _RoutineTemplateExercise(
      exerciseTemplateId: json['exercise_template_id'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => RoutineTemplateSet.fromJson(e as Map<String, dynamic>))
          .toList(),
      supersetId: (json['superset_id'] as num?)?.toInt(),
      restSeconds: (json['rest_seconds'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RoutineTemplateExerciseToJson(
        _RoutineTemplateExercise instance) =>
    <String, dynamic>{
      'exercise_template_id': instance.exerciseTemplateId,
      'sets': instance.sets,
      'superset_id': instance.supersetId,
      'rest_seconds': instance.restSeconds,
      'notes': instance.notes,
    };

_RoutineTemplateSet _$RoutineTemplateSetFromJson(Map<String, dynamic> json) =>
    _RoutineTemplateSet(
      type: json['type'] as String,
      weightKg: json['weight_kg'] as num?,
      reps: (json['reps'] as num?)?.toInt(),
      distanceMeters: (json['distance_meters'] as num?)?.toInt(),
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RoutineTemplateSetToJson(_RoutineTemplateSet instance) =>
    <String, dynamic>{
      'type': instance.type,
      'weight_kg': instance.weightKg,
      'reps': instance.reps,
      'distance_meters': instance.distanceMeters,
      'duration_seconds': instance.durationSeconds,
    };
