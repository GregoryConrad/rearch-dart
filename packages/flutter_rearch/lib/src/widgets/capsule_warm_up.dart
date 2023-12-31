part of '../widgets.dart';

/// Provides [toWarmUpWidget], a mechanism to create a [Widget] from a [List]
/// of the current states of some "warm up" [Capsule]s.
extension CapsuleWarmUp<T> on List<AsyncValue<T>> {
  /// Creates a [Widget] from a [List] of the current states of
  /// some "warm up" [Capsule]s.
  ///
  /// - [child] is returned when all of the current states are [AsyncData].
  /// - [loadingBuilder] is called to build the returned [Widget] when any
  /// of the current states are [AsyncLoading] and there is not any state of
  /// type [AsyncError].
  /// - [errorBuilder] is called to build the returned [Widget] when any
  /// of the current states are [AsyncError].
  Widget toWarmUpWidget({
    required Widget Function(List<AsyncError<T>>) errorBuilder,
    required Widget Function(List<AsyncLoading<T>>) loadingBuilder,
    required Widget child,
  }) {
    // Check for any errors first
    final asyncErrors = whereType<AsyncError<T>>();
    if (asyncErrors.isNotEmpty) {
      return errorBuilder(asyncErrors.toList());
    }

    // Check to see if we have any still loading
    final asyncLoadings = whereType<AsyncLoading<T>>();
    if (asyncLoadings.isNotEmpty) {
      return loadingBuilder(asyncLoadings.toList());
    }

    // We have only AsyncData (no loading or error), so return the child
    return child;
  }
}
