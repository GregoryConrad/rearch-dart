import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const CountApp());

/// The raw [SharedPreferences] async capsule to be warmed up.
Future<SharedPreferences> sharedPrefsAsyncCapsule(CapsuleHandle _) async {
  // Add in a little delay so we can see the loading state
  await Future<void>.delayed(const Duration(seconds: 1));
  return SharedPreferences.getInstance();
}

/// The warm up capsule for [sharedPrefsAsyncCapsule].
AsyncValue<SharedPreferences> sharedPrefsWarmUpCapsule(CapsuleHandle use) {
  final sharedPrefsFuture = use(sharedPrefsAsyncCapsule);
  return use.future(sharedPrefsFuture);
}

/// A synchronous copy of [sharedPrefsAsyncCapsule].
SharedPreferences sharedPrefsCapsule(CapsuleHandle use) {
  return use(sharedPrefsWarmUpCapsule).dataOrElse(
    () => throw StateError('sharedPrefsWarmUpCapsule was not warmed up!'),
  );
}

/// A capsule that exposes a persisted count and a [Function] to increment it.
(AsyncValue<int?>, void Function()) persistedCountCapsule(
  CapsuleHandle use,
) {
  final sharedPrefs = use(sharedPrefsCapsule);
  final (count, setCount) = use.persist<int?>(
    read: () async => sharedPrefs.getInt('count'),
    write: (newCount) async => sharedPrefs.setInt('count', newCount!),
  );
  final currCount = count.data.asNullable() ?? 0;
  return (count, () => setCount(currCount + 1));
}

/// {@template CountApp}
/// The root of the count application.
/// {@endtemplate}
class CountApp extends StatelessWidget {
  /// {@macro CountApp}
  const CountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const RearchBootstrapper(
      child: MaterialApp(
        title: 'Count Warm Up Example',
        home: GlobalWarmUps(child: CountBody()),
      ),
    );
  }
}

/// {@template GlobalWarmUps}
/// The global warm ups of the application.
/// {@endtemplate}
class GlobalWarmUps extends RearchConsumer {
  /// {@macro GlobalWarmUps}
  const GlobalWarmUps({required this.child, super.key});

  /// The child [Widget] to display when all [Capsule]s are warmed up.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    return [
      // When any of the following warm up capsules error out,
      // the errorBuilder is invoked.
      // If any are still loading, the loading widget is shown.
      // If there are no AsyncErrors or AsyncLoadings, child is shown.
      // Note: all loading happens in parallel automatically
      // to speed up your loading times!

      use(sharedPrefsWarmUpCapsule),
      // other warm ups here...
    ].toWarmUpWidget(
      child: child,
      loadingBuilder: (loadings) =>
          const Center(child: CircularProgressIndicator.adaptive()),
      errorBuilder: (errors) => Column(
        children: [
          // You might want your error display here to be prettier than this.
          // You can even wrap the Column in a MaterialApp/Scaffold.
          for (final AsyncError(:error, :stackTrace) in errors)
            Text('$error\n$stackTrace'),
        ],
      ),
    );
  }
}

/// {@template CountBody}
/// The body of the application.
/// {@endtemplate}
class CountBody extends RearchConsumer {
  /// {@macro CountBody}
  const CountBody({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final countText = use(persistedCountCapsule)
        .$1
        .map((count) => count ?? 0)
        .map((count) => count.toString());
    return Scaffold(
      body: Center(
        child: switch (countText) {
          AsyncData(:final data) =>
            Text(data, style: Theme.of(context).textTheme.headlineLarge),
          AsyncLoading() => const CircularProgressIndicator.adaptive(),
          AsyncError(:final error, :final stackTrace) =>
            Text('$error\n$stackTrace')
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: use(persistedCountCapsule).$2,
        child: const Icon(Icons.add),
      ),
    );
  }
}
