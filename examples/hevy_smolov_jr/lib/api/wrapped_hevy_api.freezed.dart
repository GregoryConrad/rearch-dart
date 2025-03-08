// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wrapped_hevy_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseTemplatesResponse {
  int get pageCount;
  int get page;
  List<Exercise> get exerciseTemplates;

  /// Create a copy of ExerciseTemplatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExerciseTemplatesResponseCopyWith<ExerciseTemplatesResponse> get copyWith =>
      _$ExerciseTemplatesResponseCopyWithImpl<ExerciseTemplatesResponse>(
          this as ExerciseTemplatesResponse, _$identity);

  /// Serializes this ExerciseTemplatesResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExerciseTemplatesResponse &&
            (identical(other.pageCount, pageCount) ||
                other.pageCount == pageCount) &&
            (identical(other.page, page) || other.page == page) &&
            const DeepCollectionEquality()
                .equals(other.exerciseTemplates, exerciseTemplates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pageCount, page,
      const DeepCollectionEquality().hash(exerciseTemplates));

  @override
  String toString() {
    return 'ExerciseTemplatesResponse(pageCount: $pageCount, page: $page, exerciseTemplates: $exerciseTemplates)';
  }
}

/// @nodoc
abstract mixin class $ExerciseTemplatesResponseCopyWith<$Res> {
  factory $ExerciseTemplatesResponseCopyWith(ExerciseTemplatesResponse value,
          $Res Function(ExerciseTemplatesResponse) _then) =
      _$ExerciseTemplatesResponseCopyWithImpl;
  @useResult
  $Res call({int pageCount, int page, List<Exercise> exerciseTemplates});
}

/// @nodoc
class _$ExerciseTemplatesResponseCopyWithImpl<$Res>
    implements $ExerciseTemplatesResponseCopyWith<$Res> {
  _$ExerciseTemplatesResponseCopyWithImpl(this._self, this._then);

  final ExerciseTemplatesResponse _self;
  final $Res Function(ExerciseTemplatesResponse) _then;

  /// Create a copy of ExerciseTemplatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageCount = null,
    Object? page = null,
    Object? exerciseTemplates = null,
  }) {
    return _then(_self.copyWith(
      pageCount: null == pageCount
          ? _self.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseTemplates: null == exerciseTemplates
          ? _self.exerciseTemplates
          : exerciseTemplates // ignore: cast_nullable_to_non_nullable
              as List<Exercise>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ExerciseTemplatesResponse implements ExerciseTemplatesResponse {
  const _ExerciseTemplatesResponse(
      {required this.pageCount,
      required this.page,
      required final List<Exercise> exerciseTemplates})
      : _exerciseTemplates = exerciseTemplates;
  factory _ExerciseTemplatesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExerciseTemplatesResponseFromJson(json);

  @override
  final int pageCount;
  @override
  final int page;
  final List<Exercise> _exerciseTemplates;
  @override
  List<Exercise> get exerciseTemplates {
    if (_exerciseTemplates is EqualUnmodifiableListView)
      return _exerciseTemplates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exerciseTemplates);
  }

  /// Create a copy of ExerciseTemplatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExerciseTemplatesResponseCopyWith<_ExerciseTemplatesResponse>
      get copyWith =>
          __$ExerciseTemplatesResponseCopyWithImpl<_ExerciseTemplatesResponse>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExerciseTemplatesResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExerciseTemplatesResponse &&
            (identical(other.pageCount, pageCount) ||
                other.pageCount == pageCount) &&
            (identical(other.page, page) || other.page == page) &&
            const DeepCollectionEquality()
                .equals(other._exerciseTemplates, _exerciseTemplates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pageCount, page,
      const DeepCollectionEquality().hash(_exerciseTemplates));

  @override
  String toString() {
    return 'ExerciseTemplatesResponse(pageCount: $pageCount, page: $page, exerciseTemplates: $exerciseTemplates)';
  }
}

/// @nodoc
abstract mixin class _$ExerciseTemplatesResponseCopyWith<$Res>
    implements $ExerciseTemplatesResponseCopyWith<$Res> {
  factory _$ExerciseTemplatesResponseCopyWith(_ExerciseTemplatesResponse value,
          $Res Function(_ExerciseTemplatesResponse) _then) =
      __$ExerciseTemplatesResponseCopyWithImpl;
  @override
  @useResult
  $Res call({int pageCount, int page, List<Exercise> exerciseTemplates});
}

/// @nodoc
class __$ExerciseTemplatesResponseCopyWithImpl<$Res>
    implements _$ExerciseTemplatesResponseCopyWith<$Res> {
  __$ExerciseTemplatesResponseCopyWithImpl(this._self, this._then);

  final _ExerciseTemplatesResponse _self;
  final $Res Function(_ExerciseTemplatesResponse) _then;

  /// Create a copy of ExerciseTemplatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pageCount = null,
    Object? page = null,
    Object? exerciseTemplates = null,
  }) {
    return _then(_ExerciseTemplatesResponse(
      pageCount: null == pageCount
          ? _self.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseTemplates: null == exerciseTemplates
          ? _self._exerciseTemplates
          : exerciseTemplates // ignore: cast_nullable_to_non_nullable
              as List<Exercise>,
    ));
  }
}

/// @nodoc
mixin _$Exercise {
  String get id;
  String get title;
  String get type;
  String get primaryMuscleGroup;
  List<String> get secondaryMuscleGroups;
  String get equipment;
  bool get isCustom;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<Exercise> get copyWith =>
      _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Exercise &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.primaryMuscleGroup, primaryMuscleGroup) ||
                other.primaryMuscleGroup == primaryMuscleGroup) &&
            const DeepCollectionEquality()
                .equals(other.secondaryMuscleGroups, secondaryMuscleGroups) &&
            (identical(other.equipment, equipment) ||
                other.equipment == equipment) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      type,
      primaryMuscleGroup,
      const DeepCollectionEquality().hash(secondaryMuscleGroups),
      equipment,
      isCustom);

  @override
  String toString() {
    return 'Exercise(id: $id, title: $title, type: $type, primaryMuscleGroup: $primaryMuscleGroup, secondaryMuscleGroups: $secondaryMuscleGroups, equipment: $equipment, isCustom: $isCustom)';
  }
}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) =
      _$ExerciseCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String type,
      String primaryMuscleGroup,
      List<String> secondaryMuscleGroups,
      String equipment,
      bool isCustom});
}

/// @nodoc
class _$ExerciseCopyWithImpl<$Res> implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? primaryMuscleGroup = null,
    Object? secondaryMuscleGroups = null,
    Object? equipment = null,
    Object? isCustom = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      primaryMuscleGroup: null == primaryMuscleGroup
          ? _self.primaryMuscleGroup
          : primaryMuscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryMuscleGroups: null == secondaryMuscleGroups
          ? _self.secondaryMuscleGroups
          : secondaryMuscleGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      equipment: null == equipment
          ? _self.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String,
      isCustom: null == isCustom
          ? _self.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Exercise implements Exercise {
  const _Exercise(
      {required this.id,
      required this.title,
      required this.type,
      required this.primaryMuscleGroup,
      required final List<String> secondaryMuscleGroups,
      required this.equipment,
      required this.isCustom})
      : _secondaryMuscleGroups = secondaryMuscleGroups;
  factory _Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String type;
  @override
  final String primaryMuscleGroup;
  final List<String> _secondaryMuscleGroups;
  @override
  List<String> get secondaryMuscleGroups {
    if (_secondaryMuscleGroups is EqualUnmodifiableListView)
      return _secondaryMuscleGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryMuscleGroups);
  }

  @override
  final String equipment;
  @override
  final bool isCustom;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExerciseCopyWith<_Exercise> get copyWith =>
      __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExerciseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Exercise &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.primaryMuscleGroup, primaryMuscleGroup) ||
                other.primaryMuscleGroup == primaryMuscleGroup) &&
            const DeepCollectionEquality()
                .equals(other._secondaryMuscleGroups, _secondaryMuscleGroups) &&
            (identical(other.equipment, equipment) ||
                other.equipment == equipment) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      type,
      primaryMuscleGroup,
      const DeepCollectionEquality().hash(_secondaryMuscleGroups),
      equipment,
      isCustom);

  @override
  String toString() {
    return 'Exercise(id: $id, title: $title, type: $type, primaryMuscleGroup: $primaryMuscleGroup, secondaryMuscleGroups: $secondaryMuscleGroups, equipment: $equipment, isCustom: $isCustom)';
  }
}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) =
      __$ExerciseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String type,
      String primaryMuscleGroup,
      List<String> secondaryMuscleGroups,
      String equipment,
      bool isCustom});
}

/// @nodoc
class __$ExerciseCopyWithImpl<$Res> implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? primaryMuscleGroup = null,
    Object? secondaryMuscleGroups = null,
    Object? equipment = null,
    Object? isCustom = null,
  }) {
    return _then(_Exercise(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      primaryMuscleGroup: null == primaryMuscleGroup
          ? _self.primaryMuscleGroup
          : primaryMuscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryMuscleGroups: null == secondaryMuscleGroups
          ? _self._secondaryMuscleGroups
          : secondaryMuscleGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      equipment: null == equipment
          ? _self.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String,
      isCustom: null == isCustom
          ? _self.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$RoutineTemplate {
  String get title;
  List<RoutineTemplateExercise> get exercises;
  String? get notes;
  int? get folderId;

  /// Create a copy of RoutineTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoutineTemplateCopyWith<RoutineTemplate> get copyWith =>
      _$RoutineTemplateCopyWithImpl<RoutineTemplate>(
          this as RoutineTemplate, _$identity);

  /// Serializes this RoutineTemplate to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoutineTemplate &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other.exercises, exercises) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title,
      const DeepCollectionEquality().hash(exercises), notes, folderId);

  @override
  String toString() {
    return 'RoutineTemplate(title: $title, exercises: $exercises, notes: $notes, folderId: $folderId)';
  }
}

/// @nodoc
abstract mixin class $RoutineTemplateCopyWith<$Res> {
  factory $RoutineTemplateCopyWith(
          RoutineTemplate value, $Res Function(RoutineTemplate) _then) =
      _$RoutineTemplateCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      List<RoutineTemplateExercise> exercises,
      String? notes,
      int? folderId});
}

/// @nodoc
class _$RoutineTemplateCopyWithImpl<$Res>
    implements $RoutineTemplateCopyWith<$Res> {
  _$RoutineTemplateCopyWithImpl(this._self, this._then);

  final RoutineTemplate _self;
  final $Res Function(RoutineTemplate) _then;

  /// Create a copy of RoutineTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? exercises = null,
    Object? notes = freezed,
    Object? folderId = freezed,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      exercises: null == exercises
          ? _self.exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<RoutineTemplateExercise>,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      folderId: freezed == folderId
          ? _self.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RoutineTemplate implements RoutineTemplate {
  const _RoutineTemplate(
      {required this.title,
      required final List<RoutineTemplateExercise> exercises,
      this.notes,
      this.folderId})
      : _exercises = exercises;
  factory _RoutineTemplate.fromJson(Map<String, dynamic> json) =>
      _$RoutineTemplateFromJson(json);

  @override
  final String title;
  final List<RoutineTemplateExercise> _exercises;
  @override
  List<RoutineTemplateExercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  final String? notes;
  @override
  final int? folderId;

  /// Create a copy of RoutineTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoutineTemplateCopyWith<_RoutineTemplate> get copyWith =>
      __$RoutineTemplateCopyWithImpl<_RoutineTemplate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RoutineTemplateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoutineTemplate &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other._exercises, _exercises) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title,
      const DeepCollectionEquality().hash(_exercises), notes, folderId);

  @override
  String toString() {
    return 'RoutineTemplate(title: $title, exercises: $exercises, notes: $notes, folderId: $folderId)';
  }
}

/// @nodoc
abstract mixin class _$RoutineTemplateCopyWith<$Res>
    implements $RoutineTemplateCopyWith<$Res> {
  factory _$RoutineTemplateCopyWith(
          _RoutineTemplate value, $Res Function(_RoutineTemplate) _then) =
      __$RoutineTemplateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String title,
      List<RoutineTemplateExercise> exercises,
      String? notes,
      int? folderId});
}

/// @nodoc
class __$RoutineTemplateCopyWithImpl<$Res>
    implements _$RoutineTemplateCopyWith<$Res> {
  __$RoutineTemplateCopyWithImpl(this._self, this._then);

  final _RoutineTemplate _self;
  final $Res Function(_RoutineTemplate) _then;

  /// Create a copy of RoutineTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? exercises = null,
    Object? notes = freezed,
    Object? folderId = freezed,
  }) {
    return _then(_RoutineTemplate(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      exercises: null == exercises
          ? _self._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<RoutineTemplateExercise>,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      folderId: freezed == folderId
          ? _self.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$RoutineTemplateExercise {
  String get exerciseTemplateId;
  List<RoutineTemplateSet> get sets;
  int? get supersetId;
  int? get restSeconds;
  String? get notes;

  /// Create a copy of RoutineTemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoutineTemplateExerciseCopyWith<RoutineTemplateExercise> get copyWith =>
      _$RoutineTemplateExerciseCopyWithImpl<RoutineTemplateExercise>(
          this as RoutineTemplateExercise, _$identity);

  /// Serializes this RoutineTemplateExercise to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoutineTemplateExercise &&
            (identical(other.exerciseTemplateId, exerciseTemplateId) ||
                other.exerciseTemplateId == exerciseTemplateId) &&
            const DeepCollectionEquality().equals(other.sets, sets) &&
            (identical(other.supersetId, supersetId) ||
                other.supersetId == supersetId) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      exerciseTemplateId,
      const DeepCollectionEquality().hash(sets),
      supersetId,
      restSeconds,
      notes);

  @override
  String toString() {
    return 'RoutineTemplateExercise(exerciseTemplateId: $exerciseTemplateId, sets: $sets, supersetId: $supersetId, restSeconds: $restSeconds, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class $RoutineTemplateExerciseCopyWith<$Res> {
  factory $RoutineTemplateExerciseCopyWith(RoutineTemplateExercise value,
          $Res Function(RoutineTemplateExercise) _then) =
      _$RoutineTemplateExerciseCopyWithImpl;
  @useResult
  $Res call(
      {String exerciseTemplateId,
      List<RoutineTemplateSet> sets,
      int? supersetId,
      int? restSeconds,
      String? notes});
}

/// @nodoc
class _$RoutineTemplateExerciseCopyWithImpl<$Res>
    implements $RoutineTemplateExerciseCopyWith<$Res> {
  _$RoutineTemplateExerciseCopyWithImpl(this._self, this._then);

  final RoutineTemplateExercise _self;
  final $Res Function(RoutineTemplateExercise) _then;

  /// Create a copy of RoutineTemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseTemplateId = null,
    Object? sets = null,
    Object? supersetId = freezed,
    Object? restSeconds = freezed,
    Object? notes = freezed,
  }) {
    return _then(_self.copyWith(
      exerciseTemplateId: null == exerciseTemplateId
          ? _self.exerciseTemplateId
          : exerciseTemplateId // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _self.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<RoutineTemplateSet>,
      supersetId: freezed == supersetId
          ? _self.supersetId
          : supersetId // ignore: cast_nullable_to_non_nullable
              as int?,
      restSeconds: freezed == restSeconds
          ? _self.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RoutineTemplateExercise implements RoutineTemplateExercise {
  const _RoutineTemplateExercise(
      {required this.exerciseTemplateId,
      required final List<RoutineTemplateSet> sets,
      this.supersetId,
      this.restSeconds,
      this.notes})
      : _sets = sets;
  factory _RoutineTemplateExercise.fromJson(Map<String, dynamic> json) =>
      _$RoutineTemplateExerciseFromJson(json);

  @override
  final String exerciseTemplateId;
  final List<RoutineTemplateSet> _sets;
  @override
  List<RoutineTemplateSet> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  final int? supersetId;
  @override
  final int? restSeconds;
  @override
  final String? notes;

  /// Create a copy of RoutineTemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoutineTemplateExerciseCopyWith<_RoutineTemplateExercise> get copyWith =>
      __$RoutineTemplateExerciseCopyWithImpl<_RoutineTemplateExercise>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RoutineTemplateExerciseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoutineTemplateExercise &&
            (identical(other.exerciseTemplateId, exerciseTemplateId) ||
                other.exerciseTemplateId == exerciseTemplateId) &&
            const DeepCollectionEquality().equals(other._sets, _sets) &&
            (identical(other.supersetId, supersetId) ||
                other.supersetId == supersetId) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      exerciseTemplateId,
      const DeepCollectionEquality().hash(_sets),
      supersetId,
      restSeconds,
      notes);

  @override
  String toString() {
    return 'RoutineTemplateExercise(exerciseTemplateId: $exerciseTemplateId, sets: $sets, supersetId: $supersetId, restSeconds: $restSeconds, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class _$RoutineTemplateExerciseCopyWith<$Res>
    implements $RoutineTemplateExerciseCopyWith<$Res> {
  factory _$RoutineTemplateExerciseCopyWith(_RoutineTemplateExercise value,
          $Res Function(_RoutineTemplateExercise) _then) =
      __$RoutineTemplateExerciseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String exerciseTemplateId,
      List<RoutineTemplateSet> sets,
      int? supersetId,
      int? restSeconds,
      String? notes});
}

/// @nodoc
class __$RoutineTemplateExerciseCopyWithImpl<$Res>
    implements _$RoutineTemplateExerciseCopyWith<$Res> {
  __$RoutineTemplateExerciseCopyWithImpl(this._self, this._then);

  final _RoutineTemplateExercise _self;
  final $Res Function(_RoutineTemplateExercise) _then;

  /// Create a copy of RoutineTemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? exerciseTemplateId = null,
    Object? sets = null,
    Object? supersetId = freezed,
    Object? restSeconds = freezed,
    Object? notes = freezed,
  }) {
    return _then(_RoutineTemplateExercise(
      exerciseTemplateId: null == exerciseTemplateId
          ? _self.exerciseTemplateId
          : exerciseTemplateId // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _self._sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<RoutineTemplateSet>,
      supersetId: freezed == supersetId
          ? _self.supersetId
          : supersetId // ignore: cast_nullable_to_non_nullable
              as int?,
      restSeconds: freezed == restSeconds
          ? _self.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$RoutineTemplateSet {
  String get type;
  num? get weightKg;
  int? get reps;
  int? get distanceMeters;
  int? get durationSeconds;

  /// Create a copy of RoutineTemplateSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoutineTemplateSetCopyWith<RoutineTemplateSet> get copyWith =>
      _$RoutineTemplateSetCopyWithImpl<RoutineTemplateSet>(
          this as RoutineTemplateSet, _$identity);

  /// Serializes this RoutineTemplateSet to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoutineTemplateSet &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, weightKg, reps, distanceMeters, durationSeconds);

  @override
  String toString() {
    return 'RoutineTemplateSet(type: $type, weightKg: $weightKg, reps: $reps, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds)';
  }
}

/// @nodoc
abstract mixin class $RoutineTemplateSetCopyWith<$Res> {
  factory $RoutineTemplateSetCopyWith(
          RoutineTemplateSet value, $Res Function(RoutineTemplateSet) _then) =
      _$RoutineTemplateSetCopyWithImpl;
  @useResult
  $Res call(
      {String type,
      num? weightKg,
      int? reps,
      int? distanceMeters,
      int? durationSeconds});
}

/// @nodoc
class _$RoutineTemplateSetCopyWithImpl<$Res>
    implements $RoutineTemplateSetCopyWith<$Res> {
  _$RoutineTemplateSetCopyWithImpl(this._self, this._then);

  final RoutineTemplateSet _self;
  final $Res Function(RoutineTemplateSet) _then;

  /// Create a copy of RoutineTemplateSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? weightKg = freezed,
    Object? reps = freezed,
    Object? distanceMeters = freezed,
    Object? durationSeconds = freezed,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: freezed == weightKg
          ? _self.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as num?,
      reps: freezed == reps
          ? _self.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int?,
      distanceMeters: freezed == distanceMeters
          ? _self.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      durationSeconds: freezed == durationSeconds
          ? _self.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RoutineTemplateSet implements RoutineTemplateSet {
  const _RoutineTemplateSet(
      {required this.type,
      this.weightKg,
      this.reps,
      this.distanceMeters,
      this.durationSeconds});
  factory _RoutineTemplateSet.fromJson(Map<String, dynamic> json) =>
      _$RoutineTemplateSetFromJson(json);

  @override
  final String type;
  @override
  final num? weightKg;
  @override
  final int? reps;
  @override
  final int? distanceMeters;
  @override
  final int? durationSeconds;

  /// Create a copy of RoutineTemplateSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoutineTemplateSetCopyWith<_RoutineTemplateSet> get copyWith =>
      __$RoutineTemplateSetCopyWithImpl<_RoutineTemplateSet>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RoutineTemplateSetToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoutineTemplateSet &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, weightKg, reps, distanceMeters, durationSeconds);

  @override
  String toString() {
    return 'RoutineTemplateSet._(type: $type, weightKg: $weightKg, reps: $reps, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds)';
  }
}

/// @nodoc
abstract mixin class _$RoutineTemplateSetCopyWith<$Res>
    implements $RoutineTemplateSetCopyWith<$Res> {
  factory _$RoutineTemplateSetCopyWith(
          _RoutineTemplateSet value, $Res Function(_RoutineTemplateSet) _then) =
      __$RoutineTemplateSetCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String type,
      num? weightKg,
      int? reps,
      int? distanceMeters,
      int? durationSeconds});
}

/// @nodoc
class __$RoutineTemplateSetCopyWithImpl<$Res>
    implements _$RoutineTemplateSetCopyWith<$Res> {
  __$RoutineTemplateSetCopyWithImpl(this._self, this._then);

  final _RoutineTemplateSet _self;
  final $Res Function(_RoutineTemplateSet) _then;

  /// Create a copy of RoutineTemplateSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? weightKg = freezed,
    Object? reps = freezed,
    Object? distanceMeters = freezed,
    Object? durationSeconds = freezed,
  }) {
    return _then(_RoutineTemplateSet(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: freezed == weightKg
          ? _self.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as num?,
      reps: freezed == reps
          ? _self.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int?,
      distanceMeters: freezed == distanceMeters
          ? _self.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      durationSeconds: freezed == durationSeconds
          ? _self.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
