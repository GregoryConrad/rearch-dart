import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_rearch_example/capsules/index_capsules.dart';
import 'package:rearch/rearch.dart';

/// {@template GlobalWarmUps}
/// Warms up all of the global warm up capsules so that the rest of the app
/// doesn't have to individually handle failure states.
/// {@endtemplate}
final class GlobalWarmUps extends RearchConsumer {
  /// {@macro GlobalWarmUps}
  const GlobalWarmUps({required this.child, super.key});

  /// The [Widget] to show when all warm up capsules are [AsyncData]s.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    return [
      use(indexWarmUpCapsule),
    ].toWarmUpWidget(
      child: child,
      loading: const Center(child: CircularProgressIndicator.adaptive()),
      errorBuilder: (errors) => Column(
        children: [
          for (final AsyncError(:error, :stackTrace) in errors)
            Text('$error\n$stackTrace'),
        ],
      ),
    );
  }
}
