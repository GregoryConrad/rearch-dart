import 'package:meta/meta.dart';

/// Represents an optional value of type [T].
///
/// An [Option] is either:
/// - [Some], which contains a value of type [T]
/// - [None], which does not contain a value
///
/// Adapted from Rust's `Option`, see more here:
/// https://doc.rust-lang.org/std/option/index.html
@immutable
sealed class Option<T> {
  /// Base constructor for [Option]s.
  const Option();

  /// Shortcut for [Some.new].
  const factory Option.some(T value) = Some;

  /// Shortcut for [None.new].
  const factory Option.none() = None;
}

/// An [Option] that has a [value].
@immutable
final class Some<T> extends Option<T> {
  /// Creates an [Option] with the associated immutable [value].
  const Some(this.value);

  /// The immutable [value] associated with this [Option].
  final T value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is Some<T> && other.value == value;

  @override
  String toString() => 'Some(value: $value)';
}

/// An [Option] that does not have a value.
@immutable
final class None<T> extends Option<T> {
  /// Creates an [Option] that does not have a value.
  const None();

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => other is None<T>;

  @override
  String toString() => 'None()';
}

/// Convenience methods for handling [Option]s.
///
/// Help is wanted here! Please open PRs to add any methods you want!
/// When possible, try to follow the function names in Rust for Option:
/// - https://doc.rust-lang.org/std/option/enum.Option.html
extension OptionConvenience<T> on Option<T> {
  /// Returns [Some.value] if `this` is a [Some].
  /// Otherwise, returns [defaultValue] (when [None]).
  T unwrapOr(T defaultValue) {
    return switch (this) {
      Some(:final value) => value,
      None() => defaultValue,
    };
  }

  /// Returns [Some.value] if `this` is a [Some].
  /// Otherwise, calls and returns the result of [defaultFn] (when [None]).
  T unwrapOrElse(T Function() defaultFn) {
    return switch (this) {
      Some(:final value) => value,
      None() => defaultFn(),
    };
  }

  /// Returns [Some.value] or `null` for [None].
  T? asNullable() {
    return switch (this) {
      Some(:final value) => value,
      None() => null,
    };
  }

  /// Maps an Option<T> into an Option<R> by applying the given [mapper].
  /// Only calls [mapper] when this [Option] is [Some].
  Option<R> map<R>(R Function(T) mapper) {
    return switch (this) {
      Some(:final value) => Some(mapper(value)),
      None() => None<R>(),
    };
  }
}

/// The current state of a [Future] or [Stream],
/// accessible from a synchronous context.
///
/// One of three variants: [AsyncData], [AsyncError], or [AsyncLoading].
///
/// Often, when a [Future]/[Stream] emits an error, or is swapped out and is put
/// back into the loading state, you want access to the previous data.
/// (Example: pull-to-refresh in UI and you want to show the current data.)
/// Thus, a `previousData` is provided in the [AsyncError] and [AsyncLoading]
/// states so you can access the previous data (if it exists).
@immutable
sealed class AsyncValue<T> {
  /// Base constructor for [AsyncValue]s.
  const AsyncValue();

  /// Shortcut for [AsyncData.new].
  const factory AsyncValue.data(T data) = AsyncData;

  /// Shortcut for [AsyncError.new].
  const factory AsyncValue.error(
    Object error,
    StackTrace stackTrace,
    Option<T> previousData,
  ) = AsyncError;

  /// Shortcut for [AsyncLoading.new].
  const factory AsyncValue.loading(Option<T> previousData) = AsyncLoading;

  /// Transforms a fallible [Future] into a safe-to-read [AsyncValue].
  /// Useful when mutating state.
  static Future<AsyncValue<T>> guard<T>(Future<T> Function() fn) async {
    try {
      return AsyncData(await fn());
    } catch (error, stackTrace) {
      return AsyncError(error, stackTrace, None<T>());
    }
  }
}

/// The data variant for an [AsyncValue].
///
/// To be in this state, a [Future] or [Stream] emitted a data event.
@immutable
final class AsyncData<T> extends AsyncValue<T> {
  /// Creates an [AsyncData] with the supplied [data].
  const AsyncData(this.data);

  /// The data of this [AsyncData].
  final T data;

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) => other is AsyncData<T> && other.data == data;

  @override
  String toString() => 'AsyncData(data: $data)';
}

/// The loading variant for an [AsyncValue].
///
/// To be in this state, a new [Future] or [Stream] has not emitted
/// a data or error event yet.
@immutable
final class AsyncLoading<T> extends AsyncValue<T> {
  /// Creates an [AsyncLoading] with the supplied [previousData].
  const AsyncLoading(this.previousData);

  /// The previous data (from a predecessor [AsyncData]), if it exists.
  /// This can happen if a new [Future]/[Stream] is watched and the
  /// [Future]/[Stream] it is replacing was in the [AsyncData] state.
  final Option<T> previousData;

  @override
  int get hashCode => previousData.hashCode;

  @override
  bool operator ==(Object other) =>
      other is AsyncLoading<T> && other.previousData == previousData;

  @override
  String toString() => 'AsyncLoading(previousData: $previousData)';
}

/// The error variant for an [AsyncValue].
///
/// To be in this state, a [Future] or [Stream] emitted an error event.
@immutable
final class AsyncError<T> extends AsyncValue<T> {
  /// Creates an [AsyncError] with the supplied [error], [stackTrace],
  /// and [previousData].
  const AsyncError(this.error, this.stackTrace, this.previousData);

  /// The emitted error associated with this [AsyncError].
  final Object error;

  /// The [StackTrace] corresponding with the [error].
  final StackTrace stackTrace;

  /// The previous data (from a predecessor [AsyncData]), if it exists.
  /// This can happen if a new [Future]/[Stream] is watched and the
  /// [Future]/[Stream] it is replacing was in the [AsyncData] state.
  final Option<T> previousData;

  @override
  int get hashCode => Object.hash(error, stackTrace, previousData);

  @override
  bool operator ==(Object other) =>
      other is AsyncError<T> &&
      other.error == error &&
      other.stackTrace == stackTrace &&
      other.previousData == previousData;

  @override
  String toString() => 'AsyncError(previousData: $previousData, '
      'error: $error, stackTrace: $stackTrace)';
}

/// Convenience methods for handling [AsyncValue]s.
///
/// Help is wanted here! Please open PRs to add any methods you want!
/// When possible, try to follow function names in Rust for Result/Option:
/// - https://doc.rust-lang.org/std/option/enum.Option.html
/// - https://doc.rust-lang.org/std/result/enum.Result.html
extension AsyncValueConvenience<T> on AsyncValue<T> {
  /// Returns *any* data contained within this [AsyncValue],
  /// including `previousData` for the [AsyncLoading] and [AsyncError] cases.
  ///
  /// Returns [Some] of [AsyncData.data] if `this` is an [AsyncData].
  /// Returns [AsyncLoading.previousData] if `this` is an [AsyncLoading].
  /// Returns [AsyncError.previousData] if `this` is an [AsyncError].
  ///
  /// See also [unwrapOr], which will only return the value
  /// on the [AsyncData] case.
  Option<T> get data {
    return switch (this) {
      AsyncData(:final data) => Some(data),
      AsyncLoading(:final previousData) => previousData,
      AsyncError(:final previousData) => previousData,
    };
  }

  /// Returns [AsyncData.data] if `this` is an [AsyncData].
  /// Otherwise, returns [defaultValue].
  ///
  /// See also [dataOr], which will always return any `data`/`previousData`
  /// contained within the [AsyncValue].
  T unwrapOr(T defaultValue) {
    return switch (this) {
      AsyncData(:final data) => data,
      _ => defaultValue,
    };
  }

  /// Returns [AsyncData.data] if `this` is an [AsyncData].
  /// Otherwise, calls and returns the result of [defaultFn].
  ///
  /// See also [dataOrElse], which will always return any `data`/`previousData`
  /// contained within the [AsyncValue].
  T unwrapOrElse(T Function() defaultFn) {
    return switch (this) {
      AsyncData(:final data) => data,
      _ => defaultFn(),
    };
  }

  /// Returns *any* data contained within this [AsyncValue],
  /// including `previousData` for the [AsyncLoading] and [AsyncError] cases.
  ///
  /// Returns [AsyncData.data] if `this` is an [AsyncData].
  /// Returns the value contained in [AsyncLoading.previousData] if `this` is
  /// an [AsyncLoading] and [AsyncLoading.previousData] is [Some].
  /// Returns the value contained in [AsyncError.previousData] if `this` is
  /// an [AsyncError] and [AsyncError.previousData] is [Some].
  /// Otherwise, returns [defaultValue].
  ///
  /// See also [unwrapOr], which will only return the value
  /// on the [AsyncData] case.
  T dataOr(T defaultValue) => data.unwrapOr(defaultValue);

  /// Returns *any* data contained within this [AsyncValue],
  /// including `previousData` for the [AsyncLoading] and [AsyncError] cases.
  ///
  /// Returns [AsyncData.data] if `this` is an [AsyncData].
  /// Returns the value contained in [AsyncLoading.previousData] if `this` is
  /// an [AsyncLoading] and [AsyncLoading.previousData] is [Some].
  /// Returns the value contained in [AsyncError.previousData] if `this` is
  /// an [AsyncError] and [AsyncError.previousData] is [Some].
  /// Otherwise, calls and returns the result of [defaultFn].
  ///
  /// See also [unwrapOrElse], which will only return the value
  /// on the [AsyncData] case.
  T dataOrElse(T Function() defaultFn) => data.unwrapOrElse(defaultFn);

  /// Fills in the [AsyncLoading.previousData] or [AsyncError.previousData] with
  /// [newPreviousData] if [AsyncLoading.previousData] or
  /// [AsyncError.previousData] are [None].
  /// If [AsyncLoading.previousData] or [AsyncError.previousData] are [Some],
  /// then [newPreviousData] will not be filled in.
  AsyncValue<T> fillInPreviousData(Option<T> newPreviousData) {
    return switch (this) {
      AsyncLoading(previousData: None()) => AsyncLoading(newPreviousData),
      AsyncError(:final error, :final stackTrace, previousData: None()) =>
        AsyncError(error, stackTrace, newPreviousData),
      _ => this,
    };
  }

  /// Maps an AsyncValue<T> into an AsyncValue<R> by applying
  /// the given [mapper].
  AsyncValue<R> map<R>(R Function(T) mapper) {
    return switch (this) {
      AsyncData(:final data) => AsyncData(mapper(data)),
      AsyncLoading(:final previousData) =>
        AsyncLoading(previousData.map(mapper)),
      AsyncError(:final error, :final stackTrace, :final previousData) =>
        AsyncError(error, stackTrace, previousData.map(mapper)),
    };
  }
}
