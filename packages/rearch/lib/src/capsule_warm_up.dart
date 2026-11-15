part of '../rearch.dart';

/// Provides [warmUp], a mechanism that waits for the specified capsules
/// to be [AsyncData].
extension WarmUpCapsuleContainer on CapsuleContainer {
  /// Warms up the specified capsules by waiting for them to all be [AsyncData].
  Future<void> warmUp<T>(
    Iterable<Capsule<AsyncValue<T>>> capsules,
  ) {
    final completer = Completer<()>();
    final dispose = listen((use) {
      // The listener is only disposed once the future completes (async),
      // so it may still be called with updates after completion.
      if (completer.isCompleted) return;

      final resolved = capsules.map((capsule) => use(capsule));

      if (resolved.every((capsule) => capsule is AsyncData)) {
        completer.complete(());
      }

      final asyncError = resolved.whereType<AsyncError<T>>().firstOrNull;
      if (asyncError != null) {
        completer.completeError(asyncError.error, asyncError.stackTrace);
      }
    });

    return completer.future.whenComplete(dispose);
  }
}
