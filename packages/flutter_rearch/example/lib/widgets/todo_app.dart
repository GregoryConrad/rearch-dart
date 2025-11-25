import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_rearch_example/widgets/body.dart';
import 'package:flutter_rearch_example/widgets/global_warm_ups.dart';

/// {@template TodoApp}
/// Wraps around [MaterialApp] and is the entry point [Widget] of the app.
/// {@endtemplate}
class TodoApp extends StatelessWidget {
  /// {@macro TodoApp}
  const TodoApp({super.key, this.showAnimatedBackground = true});

  /// Whether to show the animated background.
  final bool showAnimatedBackground;

  @override
  Widget build(BuildContext context) {
    return RearchBootstrapper(
      child: MaterialApp(
        title: 'Rearch Todos',
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: GlobalWarmUps(
          child: Body(
            showAnimatedBackground: showAnimatedBackground,
          ),
        ),
      ),
    );
  }
}
