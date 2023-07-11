part of '../widgets.dart';

/// Provides [toWarmUpWidget], a mechanism to create a [Widget] from a [List]
/// of the current states of some "warm up" [Capsule]s.
extension CapsuleWarmUp on List<AsyncValue<dynamic>> {
  /// Creates a [Widget] from a [List] of the current states of
  /// some "warm up" [Capsule]s.
  ///
  /// - [child] is returned when all of the current states are [AsyncData].
  /// - [loading] is returned when any of the current states are [AsyncLoading].
  /// - [errorBuilder] is called to build the returned [Widget] when any
  /// of the current states are [AsyncError].
  Widget toWarmUpWidget({
    required Widget Function(List<AsyncError<dynamic>>) errorBuilder,
    required Widget loading,
    required Widget child,
  }) {
    // Check for any errors first
    final asyncErrors = whereType<AsyncError<Object?>>();
    if (asyncErrors.isNotEmpty) {
      return errorBuilder(asyncErrors.toList());
    }

    // Check to see if we have any still loading
    if (any((value) => value is AsyncLoading)) {
      return loading;
    }

    // We have only AsyncData (no loading or error), so return the child
    return child;
  }
}
