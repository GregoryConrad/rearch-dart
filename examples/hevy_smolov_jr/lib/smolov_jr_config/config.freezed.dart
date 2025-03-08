// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SmolovJrConfig {
  /// 1rm _without_ bodyweight included, in case this is a body weight lift
  Exercise? get exercise;
  num get oneRepMax;
  num get bodyWeight;
  int? get restSeconds;
  num get increment;
  WeightUnit get unit;

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SmolovJrConfigCopyWith<SmolovJrConfig> get copyWith =>
      _$SmolovJrConfigCopyWithImpl<SmolovJrConfig>(
          this as SmolovJrConfig, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SmolovJrConfig &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.oneRepMax, oneRepMax) ||
                other.oneRepMax == oneRepMax) &&
            (identical(other.bodyWeight, bodyWeight) ||
                other.bodyWeight == bodyWeight) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.increment, increment) ||
                other.increment == increment) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise, oneRepMax, bodyWeight,
      restSeconds, increment, unit);

  @override
  String toString() {
    return 'SmolovJrConfig(exercise: $exercise, oneRepMax: $oneRepMax, bodyWeight: $bodyWeight, restSeconds: $restSeconds, increment: $increment, unit: $unit)';
  }
}

/// @nodoc
abstract mixin class $SmolovJrConfigCopyWith<$Res> {
  factory $SmolovJrConfigCopyWith(
          SmolovJrConfig value, $Res Function(SmolovJrConfig) _then) =
      _$SmolovJrConfigCopyWithImpl;
  @useResult
  $Res call(
      {Exercise? exercise,
      num oneRepMax,
      num bodyWeight,
      int? restSeconds,
      num increment,
      WeightUnit unit});

  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class _$SmolovJrConfigCopyWithImpl<$Res>
    implements $SmolovJrConfigCopyWith<$Res> {
  _$SmolovJrConfigCopyWithImpl(this._self, this._then);

  final SmolovJrConfig _self;
  final $Res Function(SmolovJrConfig) _then;

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercise = freezed,
    Object? oneRepMax = null,
    Object? bodyWeight = null,
    Object? restSeconds = freezed,
    Object? increment = null,
    Object? unit = null,
  }) {
    return _then(_self.copyWith(
      exercise: freezed == exercise
          ? _self.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as Exercise?,
      oneRepMax: null == oneRepMax
          ? _self.oneRepMax
          : oneRepMax // ignore: cast_nullable_to_non_nullable
              as num,
      bodyWeight: null == bodyWeight
          ? _self.bodyWeight
          : bodyWeight // ignore: cast_nullable_to_non_nullable
              as num,
      restSeconds: freezed == restSeconds
          ? _self.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      increment: null == increment
          ? _self.increment
          : increment // ignore: cast_nullable_to_non_nullable
              as num,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as WeightUnit,
    ));
  }

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res>? get exercise {
    if (_self.exercise == null) {
      return null;
    }

    return $ExerciseCopyWith<$Res>(_self.exercise!, (value) {
      return _then(_self.copyWith(exercise: value));
    });
  }
}

/// @nodoc

class _SmolovJrConfig implements SmolovJrConfig {
  const _SmolovJrConfig(
      {required this.exercise,
      required this.oneRepMax,
      required this.bodyWeight,
      required this.restSeconds,
      required this.increment,
      required this.unit});

  /// 1rm _without_ bodyweight included, in case this is a body weight lift
  @override
  final Exercise? exercise;
  @override
  final num oneRepMax;
  @override
  final num bodyWeight;
  @override
  final int? restSeconds;
  @override
  final num increment;
  @override
  final WeightUnit unit;

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SmolovJrConfigCopyWith<_SmolovJrConfig> get copyWith =>
      __$SmolovJrConfigCopyWithImpl<_SmolovJrConfig>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SmolovJrConfig &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.oneRepMax, oneRepMax) ||
                other.oneRepMax == oneRepMax) &&
            (identical(other.bodyWeight, bodyWeight) ||
                other.bodyWeight == bodyWeight) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.increment, increment) ||
                other.increment == increment) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise, oneRepMax, bodyWeight,
      restSeconds, increment, unit);

  @override
  String toString() {
    return 'SmolovJrConfig(exercise: $exercise, oneRepMax: $oneRepMax, bodyWeight: $bodyWeight, restSeconds: $restSeconds, increment: $increment, unit: $unit)';
  }
}

/// @nodoc
abstract mixin class _$SmolovJrConfigCopyWith<$Res>
    implements $SmolovJrConfigCopyWith<$Res> {
  factory _$SmolovJrConfigCopyWith(
          _SmolovJrConfig value, $Res Function(_SmolovJrConfig) _then) =
      __$SmolovJrConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Exercise? exercise,
      num oneRepMax,
      num bodyWeight,
      int? restSeconds,
      num increment,
      WeightUnit unit});

  @override
  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class __$SmolovJrConfigCopyWithImpl<$Res>
    implements _$SmolovJrConfigCopyWith<$Res> {
  __$SmolovJrConfigCopyWithImpl(this._self, this._then);

  final _SmolovJrConfig _self;
  final $Res Function(_SmolovJrConfig) _then;

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? exercise = freezed,
    Object? oneRepMax = null,
    Object? bodyWeight = null,
    Object? restSeconds = freezed,
    Object? increment = null,
    Object? unit = null,
  }) {
    return _then(_SmolovJrConfig(
      exercise: freezed == exercise
          ? _self.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as Exercise?,
      oneRepMax: null == oneRepMax
          ? _self.oneRepMax
          : oneRepMax // ignore: cast_nullable_to_non_nullable
              as num,
      bodyWeight: null == bodyWeight
          ? _self.bodyWeight
          : bodyWeight // ignore: cast_nullable_to_non_nullable
              as num,
      restSeconds: freezed == restSeconds
          ? _self.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      increment: null == increment
          ? _self.increment
          : increment // ignore: cast_nullable_to_non_nullable
              as num,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as WeightUnit,
    ));
  }

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res>? get exercise {
    if (_self.exercise == null) {
      return null;
    }

    return $ExerciseCopyWith<$Res>(_self.exercise!, (value) {
      return _then(_self.copyWith(exercise: value));
    });
  }
}

// dart format on
