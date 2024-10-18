import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/experimental.dart';
import 'package:rearch/rearch.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The underlying [Capsule] providing the app's [SharedPreferencesWithCache].
final Capsule<Future<SharedPreferencesWithCache>> sharedPrefsAsyncCapsule =
    capsule((use) {
  return SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
});

/// A wrapper around the [sharedPrefsAsyncCapsule]
/// to be warmed up by the [SharedPrefsWarmUp].
final Capsule<AsyncValue<SharedPreferencesWithCache>> sharedPrefsWarmUpCapsule =
    capsule((use) {
  return use.future(use(sharedPrefsAsyncCapsule));
});

///The [Capsule] providing the [SharedPreferencesWithCache] to other [Capsule]s.
final Capsule<SharedPreferencesWithCache> sharedPrefsCapsule = capsule((use) {
  return use(sharedPrefsWarmUpCapsule).dataOrElse(
    () => throw StateError('sharedPrefsWarmUpCapsule not warmed up'),
  );
});

/// Warms up the [sharedPrefsCapsule].
class SharedPrefsWarmUp extends RearchConsumer {
  /// Warms up the [sharedPrefsCapsule].
  const SharedPrefsWarmUp({required this.child, super.key});

  /// The child of this [SharedPrefsWarmUp] when [sharedPrefsCapsule]
  /// has been warmed up.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    return [use(sharedPrefsWarmUpCapsule)].toWarmUpWidget(
      child: child,
      loading: const Scaffold(body: Center(child: CircularProgressIndicator())),
      errorBuilder: (List<AsyncError<SharedPreferencesWithCache>> errors) {
        return Scaffold(
          body: Column(
            children: [
              const Text('Failed to load application!'),
              for (final error in errors) ...[
                Text(error.error.toString()),
              ],
            ],
          ),
        );
      },
    );
  }
}
