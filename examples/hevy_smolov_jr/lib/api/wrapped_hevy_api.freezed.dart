// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wrapped_hevy_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExerciseTemplatesResponse _$ExerciseTemplatesResponseFromJson(
    Map<String, dynamic> json) {
  return _ExerciseTemplatesResponse.fromJson(json);
}

/// @nodoc
mixin _$ExerciseTemplatesResponse {
  int get pageCount => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  List<Exercise> get exerciseTemplates => throw _privateConstructorUsedError;

  /// Serializes this ExerciseTemplatesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseTemplatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseTemplatesResponseCopyWith<ExerciseTemplatesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseTemplatesResponseCopyWith<$Res> {
  factory $ExerciseTemplatesResponseCopyWith(ExerciseTemplatesResponse value,
          $Res Function(ExerciseTemplatesResponse) then) =
      _$ExerciseTemplatesResponseCopyWithImpl<$Res, ExerciseTemplatesResponse>;
  @useResult
  $Res call({int pageCount, int page, List<Exercise> exerciseTemplates});
}

/// @nodoc
class _$ExerciseTemplatesResponseCopyWithImpl<$Res,
        $Val extends ExerciseTemplatesResponse>
    implements $ExerciseTemplatesResponseCopyWith<$Res> {
  _$ExerciseTemplatesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseTemplatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageCount = null,
    Object? page = null,
    Object? exerciseTemplates = null,
  }) {
    return _then(_value.copyWith(
      pageCount: null == pageCount
          ? _value.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseTemplates: null == exerciseTemplates
          ? _value.exerciseTemplates
          : exerciseTemplates // ignore: cast_nullable_to_non_nullable
              as List<Exercise>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseTemplatesResponseImplCopyWith<$Res>
    implements $ExerciseTemplatesResponseCopyWith<$Res> {
  factory _$$ExerciseTemplatesResponseImplCopyWith(
          _$ExerciseTemplatesResponseImpl value,
          $Res Function(_$ExerciseTemplatesResponseImpl) then) =
      __$$ExerciseTemplatesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int pageCount, int page, List<Exercise> exerciseTemplates});
}

/// @nodoc
class __$$ExerciseTemplatesResponseImplCopyWithImpl<$Res>
    extends _$ExerciseTemplatesResponseCopyWithImpl<$Res,
        _$ExerciseTemplatesResponseImpl>
    implements _$$ExerciseTemplatesResponseImplCopyWith<$Res> {
  __$$ExerciseTemplatesResponseImplCopyWithImpl(
      _$ExerciseTemplatesResponseImpl _value,
      $Res Function(_$ExerciseTemplatesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExerciseTemplatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageCount = null,
    Object? page = null,
    Object? exerciseTemplates = null,
  }) {
    return _then(_$ExerciseTemplatesResponseImpl(
      pageCount: null == pageCount
          ? _value.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseTemplates: null == exerciseTemplates
          ? _value._exerciseTemplates
          : exerciseTemplates // ignore: cast_nullable_to_non_nullable
              as List<Exercise>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseTemplatesResponseImpl implements _ExerciseTemplatesResponse {
  const _$ExerciseTemplatesResponseImpl(
      {required this.pageCount,
      required this.page,
      required final List<Exercise> exerciseTemplates})
      : _exerciseTemplates = exerciseTemplates;

  factory _$ExerciseTemplatesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseTemplatesResponseImplFromJson(json);

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

  @override
  String toString() {
    return 'ExerciseTemplatesResponse(pageCount: $pageCount, page: $page, exerciseTemplates: $exerciseTemplates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseTemplatesResponseImpl &&
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

  /// Create a copy of ExerciseTemplatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseTemplatesResponseImplCopyWith<_$ExerciseTemplatesResponseImpl>
      get copyWith => __$$ExerciseTemplatesResponseImplCopyWithImpl<
          _$ExerciseTemplatesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseTemplatesResponseImplToJson(
      this,
    );
  }
}

abstract class _ExerciseTemplatesResponse implements ExerciseTemplatesResponse {
  const factory _ExerciseTemplatesResponse(
          {required final int pageCount,
          required final int page,
          required final List<Exercise> exerciseTemplates}) =
      _$ExerciseTemplatesResponseImpl;

  factory _ExerciseTemplatesResponse.fromJson(Map<String, dynamic> json) =
      _$ExerciseTemplatesResponseImpl.fromJson;

  @override
  int get pageCount;
  @override
  int get page;
  @override
  List<Exercise> get exerciseTemplates;

  /// Create a copy of ExerciseTemplatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseTemplatesResponseImplCopyWith<_$ExerciseTemplatesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return _Exercise.fromJson(json);
}

/// @nodoc
mixin _$Exercise {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get primaryMuscleGroup => throw _privateConstructorUsedError;
  List<String> get secondaryMuscleGroups => throw _privateConstructorUsedError;
  String get equipment => throw _privateConstructorUsedError;
  bool get isCustom => throw _privateConstructorUsedError;

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseCopyWith<Exercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) then) =
      _$ExerciseCopyWithImpl<$Res, Exercise>;
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
class _$ExerciseCopyWithImpl<$Res, $Val extends Exercise>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      primaryMuscleGroup: null == primaryMuscleGroup
          ? _value.primaryMuscleGroup
          : primaryMuscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryMuscleGroups: null == secondaryMuscleGroups
          ? _value.secondaryMuscleGroups
          : secondaryMuscleGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      equipment: null == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseImplCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$$ExerciseImplCopyWith(
          _$ExerciseImpl value, $Res Function(_$ExerciseImpl) then) =
      __$$ExerciseImplCopyWithImpl<$Res>;
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
class __$$ExerciseImplCopyWithImpl<$Res>
    extends _$ExerciseCopyWithImpl<$Res, _$ExerciseImpl>
    implements _$$ExerciseImplCopyWith<$Res> {
  __$$ExerciseImplCopyWithImpl(
      _$ExerciseImpl _value, $Res Function(_$ExerciseImpl) _then)
      : super(_value, _then);

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
    return _then(_$ExerciseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      primaryMuscleGroup: null == primaryMuscleGroup
          ? _value.primaryMuscleGroup
          : primaryMuscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryMuscleGroups: null == secondaryMuscleGroups
          ? _value._secondaryMuscleGroups
          : secondaryMuscleGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      equipment: null == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseImpl implements _Exercise {
  const _$ExerciseImpl(
      {required this.id,
      required this.title,
      required this.type,
      required this.primaryMuscleGroup,
      required final List<String> secondaryMuscleGroups,
      required this.equipment,
      required this.isCustom})
      : _secondaryMuscleGroups = secondaryMuscleGroups;

  factory _$ExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseImplFromJson(json);

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

  @override
  String toString() {
    return 'Exercise(id: $id, title: $title, type: $type, primaryMuscleGroup: $primaryMuscleGroup, secondaryMuscleGroups: $secondaryMuscleGroups, equipment: $equipment, isCustom: $isCustom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseImpl &&
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

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      __$$ExerciseImplCopyWithImpl<_$ExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseImplToJson(
      this,
    );
  }
}

abstract class _Exercise implements Exercise {
  const factory _Exercise(
      {required final String id,
      required final String title,
      required final String type,
      required final String primaryMuscleGroup,
      required final List<String> secondaryMuscleGroups,
      required final String equipment,
      required final bool isCustom}) = _$ExerciseImpl;

  factory _Exercise.fromJson(Map<String, dynamic> json) =
      _$ExerciseImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get type;
  @override
  String get primaryMuscleGroup;
  @override
  List<String> get secondaryMuscleGroups;
  @override
  String get equipment;
  @override
  bool get isCustom;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineTemplate _$RoutineTemplateFromJson(Map<String, dynamic> json) {
  return _RoutineTemplate.fromJson(json);
}

/// @nodoc
mixin _$RoutineTemplate {
  String get title => throw _privateConstructorUsedError;
  List<RoutineTemplateExercise> get exercises =>
      throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get folderId => throw _privateConstructorUsedError;

  /// Serializes this RoutineTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineTemplateCopyWith<RoutineTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineTemplateCopyWith<$Res> {
  factory $RoutineTemplateCopyWith(
          RoutineTemplate value, $Res Function(RoutineTemplate) then) =
      _$RoutineTemplateCopyWithImpl<$Res, RoutineTemplate>;
  @useResult
  $Res call(
      {String title,
      List<RoutineTemplateExercise> exercises,
      String? notes,
      int? folderId});
}

/// @nodoc
class _$RoutineTemplateCopyWithImpl<$Res, $Val extends RoutineTemplate>
    implements $RoutineTemplateCopyWith<$Res> {
  _$RoutineTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      exercises: null == exercises
          ? _value.exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<RoutineTemplateExercise>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      folderId: freezed == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineTemplateImplCopyWith<$Res>
    implements $RoutineTemplateCopyWith<$Res> {
  factory _$$RoutineTemplateImplCopyWith(_$RoutineTemplateImpl value,
          $Res Function(_$RoutineTemplateImpl) then) =
      __$$RoutineTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      List<RoutineTemplateExercise> exercises,
      String? notes,
      int? folderId});
}

/// @nodoc
class __$$RoutineTemplateImplCopyWithImpl<$Res>
    extends _$RoutineTemplateCopyWithImpl<$Res, _$RoutineTemplateImpl>
    implements _$$RoutineTemplateImplCopyWith<$Res> {
  __$$RoutineTemplateImplCopyWithImpl(
      _$RoutineTemplateImpl _value, $Res Function(_$RoutineTemplateImpl) _then)
      : super(_value, _then);

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
    return _then(_$RoutineTemplateImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      exercises: null == exercises
          ? _value._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<RoutineTemplateExercise>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      folderId: freezed == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineTemplateImpl implements _RoutineTemplate {
  const _$RoutineTemplateImpl(
      {required this.title,
      required final List<RoutineTemplateExercise> exercises,
      this.notes,
      this.folderId})
      : _exercises = exercises;

  factory _$RoutineTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineTemplateImplFromJson(json);

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

  @override
  String toString() {
    return 'RoutineTemplate(title: $title, exercises: $exercises, notes: $notes, folderId: $folderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineTemplateImpl &&
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

  /// Create a copy of RoutineTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineTemplateImplCopyWith<_$RoutineTemplateImpl> get copyWith =>
      __$$RoutineTemplateImplCopyWithImpl<_$RoutineTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineTemplateImplToJson(
      this,
    );
  }
}

abstract class _RoutineTemplate implements RoutineTemplate {
  const factory _RoutineTemplate(
      {required final String title,
      required final List<RoutineTemplateExercise> exercises,
      final String? notes,
      final int? folderId}) = _$RoutineTemplateImpl;

  factory _RoutineTemplate.fromJson(Map<String, dynamic> json) =
      _$RoutineTemplateImpl.fromJson;

  @override
  String get title;
  @override
  List<RoutineTemplateExercise> get exercises;
  @override
  String? get notes;
  @override
  int? get folderId;

  /// Create a copy of RoutineTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineTemplateImplCopyWith<_$RoutineTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineTemplateExercise _$RoutineTemplateExerciseFromJson(
    Map<String, dynamic> json) {
  return _RoutineTemplateExercise.fromJson(json);
}

/// @nodoc
mixin _$RoutineTemplateExercise {
  String get exerciseTemplateId => throw _privateConstructorUsedError;
  List<RoutineTemplateSet> get sets => throw _privateConstructorUsedError;
  int? get supersetId => throw _privateConstructorUsedError;
  int? get restSeconds => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this RoutineTemplateExercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineTemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineTemplateExerciseCopyWith<RoutineTemplateExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineTemplateExerciseCopyWith<$Res> {
  factory $RoutineTemplateExerciseCopyWith(RoutineTemplateExercise value,
          $Res Function(RoutineTemplateExercise) then) =
      _$RoutineTemplateExerciseCopyWithImpl<$Res, RoutineTemplateExercise>;
  @useResult
  $Res call(
      {String exerciseTemplateId,
      List<RoutineTemplateSet> sets,
      int? supersetId,
      int? restSeconds,
      String? notes});
}

/// @nodoc
class _$RoutineTemplateExerciseCopyWithImpl<$Res,
        $Val extends RoutineTemplateExercise>
    implements $RoutineTemplateExerciseCopyWith<$Res> {
  _$RoutineTemplateExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      exerciseTemplateId: null == exerciseTemplateId
          ? _value.exerciseTemplateId
          : exerciseTemplateId // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<RoutineTemplateSet>,
      supersetId: freezed == supersetId
          ? _value.supersetId
          : supersetId // ignore: cast_nullable_to_non_nullable
              as int?,
      restSeconds: freezed == restSeconds
          ? _value.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineTemplateExerciseImplCopyWith<$Res>
    implements $RoutineTemplateExerciseCopyWith<$Res> {
  factory _$$RoutineTemplateExerciseImplCopyWith(
          _$RoutineTemplateExerciseImpl value,
          $Res Function(_$RoutineTemplateExerciseImpl) then) =
      __$$RoutineTemplateExerciseImplCopyWithImpl<$Res>;
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
class __$$RoutineTemplateExerciseImplCopyWithImpl<$Res>
    extends _$RoutineTemplateExerciseCopyWithImpl<$Res,
        _$RoutineTemplateExerciseImpl>
    implements _$$RoutineTemplateExerciseImplCopyWith<$Res> {
  __$$RoutineTemplateExerciseImplCopyWithImpl(
      _$RoutineTemplateExerciseImpl _value,
      $Res Function(_$RoutineTemplateExerciseImpl) _then)
      : super(_value, _then);

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
    return _then(_$RoutineTemplateExerciseImpl(
      exerciseTemplateId: null == exerciseTemplateId
          ? _value.exerciseTemplateId
          : exerciseTemplateId // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value._sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<RoutineTemplateSet>,
      supersetId: freezed == supersetId
          ? _value.supersetId
          : supersetId // ignore: cast_nullable_to_non_nullable
              as int?,
      restSeconds: freezed == restSeconds
          ? _value.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineTemplateExerciseImpl implements _RoutineTemplateExercise {
  const _$RoutineTemplateExerciseImpl(
      {required this.exerciseTemplateId,
      required final List<RoutineTemplateSet> sets,
      this.supersetId,
      this.restSeconds,
      this.notes})
      : _sets = sets;

  factory _$RoutineTemplateExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineTemplateExerciseImplFromJson(json);

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

  @override
  String toString() {
    return 'RoutineTemplateExercise(exerciseTemplateId: $exerciseTemplateId, sets: $sets, supersetId: $supersetId, restSeconds: $restSeconds, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineTemplateExerciseImpl &&
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

  /// Create a copy of RoutineTemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineTemplateExerciseImplCopyWith<_$RoutineTemplateExerciseImpl>
      get copyWith => __$$RoutineTemplateExerciseImplCopyWithImpl<
          _$RoutineTemplateExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineTemplateExerciseImplToJson(
      this,
    );
  }
}

abstract class _RoutineTemplateExercise implements RoutineTemplateExercise {
  const factory _RoutineTemplateExercise(
      {required final String exerciseTemplateId,
      required final List<RoutineTemplateSet> sets,
      final int? supersetId,
      final int? restSeconds,
      final String? notes}) = _$RoutineTemplateExerciseImpl;

  factory _RoutineTemplateExercise.fromJson(Map<String, dynamic> json) =
      _$RoutineTemplateExerciseImpl.fromJson;

  @override
  String get exerciseTemplateId;
  @override
  List<RoutineTemplateSet> get sets;
  @override
  int? get supersetId;
  @override
  int? get restSeconds;
  @override
  String? get notes;

  /// Create a copy of RoutineTemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineTemplateExerciseImplCopyWith<_$RoutineTemplateExerciseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RoutineTemplateSet _$RoutineTemplateSetFromJson(Map<String, dynamic> json) {
  return _RoutineTemplateSet.fromJson(json);
}

/// @nodoc
mixin _$RoutineTemplateSet {
  String get type => throw _privateConstructorUsedError;
  num? get weightKg => throw _privateConstructorUsedError;
  int? get reps => throw _privateConstructorUsedError;
  int? get distanceMeters => throw _privateConstructorUsedError;
  int? get durationSeconds => throw _privateConstructorUsedError;

  /// Serializes this RoutineTemplateSet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineTemplateSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineTemplateSetCopyWith<RoutineTemplateSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineTemplateSetCopyWith<$Res> {
  factory $RoutineTemplateSetCopyWith(
          RoutineTemplateSet value, $Res Function(RoutineTemplateSet) then) =
      _$RoutineTemplateSetCopyWithImpl<$Res, RoutineTemplateSet>;
  @useResult
  $Res call(
      {String type,
      num? weightKg,
      int? reps,
      int? distanceMeters,
      int? durationSeconds});
}

/// @nodoc
class _$RoutineTemplateSetCopyWithImpl<$Res, $Val extends RoutineTemplateSet>
    implements $RoutineTemplateSetCopyWith<$Res> {
  _$RoutineTemplateSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as num?,
      reps: freezed == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int?,
      distanceMeters: freezed == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      durationSeconds: freezed == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineTemplateSetImplCopyWith<$Res>
    implements $RoutineTemplateSetCopyWith<$Res> {
  factory _$$RoutineTemplateSetImplCopyWith(_$RoutineTemplateSetImpl value,
          $Res Function(_$RoutineTemplateSetImpl) then) =
      __$$RoutineTemplateSetImplCopyWithImpl<$Res>;
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
class __$$RoutineTemplateSetImplCopyWithImpl<$Res>
    extends _$RoutineTemplateSetCopyWithImpl<$Res, _$RoutineTemplateSetImpl>
    implements _$$RoutineTemplateSetImplCopyWith<$Res> {
  __$$RoutineTemplateSetImplCopyWithImpl(_$RoutineTemplateSetImpl _value,
      $Res Function(_$RoutineTemplateSetImpl) _then)
      : super(_value, _then);

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
    return _then(_$RoutineTemplateSetImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as num?,
      reps: freezed == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int?,
      distanceMeters: freezed == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      durationSeconds: freezed == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineTemplateSetImpl implements _RoutineTemplateSet {
  const _$RoutineTemplateSetImpl(
      {required this.type,
      this.weightKg,
      this.reps,
      this.distanceMeters,
      this.durationSeconds});

  factory _$RoutineTemplateSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineTemplateSetImplFromJson(json);

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

  @override
  String toString() {
    return 'RoutineTemplateSet._(type: $type, weightKg: $weightKg, reps: $reps, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineTemplateSetImpl &&
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

  /// Create a copy of RoutineTemplateSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineTemplateSetImplCopyWith<_$RoutineTemplateSetImpl> get copyWith =>
      __$$RoutineTemplateSetImplCopyWithImpl<_$RoutineTemplateSetImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineTemplateSetImplToJson(
      this,
    );
  }
}

abstract class _RoutineTemplateSet implements RoutineTemplateSet {
  const factory _RoutineTemplateSet(
      {required final String type,
      final num? weightKg,
      final int? reps,
      final int? distanceMeters,
      final int? durationSeconds}) = _$RoutineTemplateSetImpl;

  factory _RoutineTemplateSet.fromJson(Map<String, dynamic> json) =
      _$RoutineTemplateSetImpl.fromJson;

  @override
  String get type;
  @override
  num? get weightKg;
  @override
  int? get reps;
  @override
  int? get distanceMeters;
  @override
  int? get durationSeconds;

  /// Create a copy of RoutineTemplateSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineTemplateSetImplCopyWith<_$RoutineTemplateSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
