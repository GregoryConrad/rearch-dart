// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SmolovJrConfig {
  /// 1rm _without_ bodyweight included, in case this is a body weight lift
  Exercise? get exercise => throw _privateConstructorUsedError;
  num get oneRepMax => throw _privateConstructorUsedError;
  num get bodyWeight => throw _privateConstructorUsedError;
  int? get restSeconds => throw _privateConstructorUsedError;
  num get increment => throw _privateConstructorUsedError;
  WeightUnit get unit => throw _privateConstructorUsedError;

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmolovJrConfigCopyWith<SmolovJrConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmolovJrConfigCopyWith<$Res> {
  factory $SmolovJrConfigCopyWith(
          SmolovJrConfig value, $Res Function(SmolovJrConfig) then) =
      _$SmolovJrConfigCopyWithImpl<$Res, SmolovJrConfig>;
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
class _$SmolovJrConfigCopyWithImpl<$Res, $Val extends SmolovJrConfig>
    implements $SmolovJrConfigCopyWith<$Res> {
  _$SmolovJrConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      exercise: freezed == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as Exercise?,
      oneRepMax: null == oneRepMax
          ? _value.oneRepMax
          : oneRepMax // ignore: cast_nullable_to_non_nullable
              as num,
      bodyWeight: null == bodyWeight
          ? _value.bodyWeight
          : bodyWeight // ignore: cast_nullable_to_non_nullable
              as num,
      restSeconds: freezed == restSeconds
          ? _value.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      increment: null == increment
          ? _value.increment
          : increment // ignore: cast_nullable_to_non_nullable
              as num,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as WeightUnit,
    ) as $Val);
  }

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res>? get exercise {
    if (_value.exercise == null) {
      return null;
    }

    return $ExerciseCopyWith<$Res>(_value.exercise!, (value) {
      return _then(_value.copyWith(exercise: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SmolovJrConfigImplCopyWith<$Res>
    implements $SmolovJrConfigCopyWith<$Res> {
  factory _$$SmolovJrConfigImplCopyWith(_$SmolovJrConfigImpl value,
          $Res Function(_$SmolovJrConfigImpl) then) =
      __$$SmolovJrConfigImplCopyWithImpl<$Res>;
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
class __$$SmolovJrConfigImplCopyWithImpl<$Res>
    extends _$SmolovJrConfigCopyWithImpl<$Res, _$SmolovJrConfigImpl>
    implements _$$SmolovJrConfigImplCopyWith<$Res> {
  __$$SmolovJrConfigImplCopyWithImpl(
      _$SmolovJrConfigImpl _value, $Res Function(_$SmolovJrConfigImpl) _then)
      : super(_value, _then);

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
    return _then(_$SmolovJrConfigImpl(
      exercise: freezed == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as Exercise?,
      oneRepMax: null == oneRepMax
          ? _value.oneRepMax
          : oneRepMax // ignore: cast_nullable_to_non_nullable
              as num,
      bodyWeight: null == bodyWeight
          ? _value.bodyWeight
          : bodyWeight // ignore: cast_nullable_to_non_nullable
              as num,
      restSeconds: freezed == restSeconds
          ? _value.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      increment: null == increment
          ? _value.increment
          : increment // ignore: cast_nullable_to_non_nullable
              as num,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as WeightUnit,
    ));
  }
}

/// @nodoc

class _$SmolovJrConfigImpl implements _SmolovJrConfig {
  const _$SmolovJrConfigImpl(
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

  @override
  String toString() {
    return 'SmolovJrConfig(exercise: $exercise, oneRepMax: $oneRepMax, bodyWeight: $bodyWeight, restSeconds: $restSeconds, increment: $increment, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmolovJrConfigImpl &&
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

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmolovJrConfigImplCopyWith<_$SmolovJrConfigImpl> get copyWith =>
      __$$SmolovJrConfigImplCopyWithImpl<_$SmolovJrConfigImpl>(
          this, _$identity);
}

abstract class _SmolovJrConfig implements SmolovJrConfig {
  const factory _SmolovJrConfig(
      {required final Exercise? exercise,
      required final num oneRepMax,
      required final num bodyWeight,
      required final int? restSeconds,
      required final num increment,
      required final WeightUnit unit}) = _$SmolovJrConfigImpl;

  /// 1rm _without_ bodyweight included, in case this is a body weight lift
  @override
  Exercise? get exercise;
  @override
  num get oneRepMax;
  @override
  num get bodyWeight;
  @override
  int? get restSeconds;
  @override
  num get increment;
  @override
  WeightUnit get unit;

  /// Create a copy of SmolovJrConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmolovJrConfigImplCopyWith<_$SmolovJrConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
