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
