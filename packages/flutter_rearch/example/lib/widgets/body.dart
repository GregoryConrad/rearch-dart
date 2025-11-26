import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_rearch_example/capsules/filter_capsules.dart';
import 'package:flutter_rearch_example/capsules/todo_capsules.dart';
import 'package:flutter_rearch_example/widgets/custom_app_bar.dart';
import 'package:flutter_rearch_example/widgets/dynamic_background.dart';
import 'package:flutter_rearch_example/widgets/todo_item.dart';
import 'package:rearch/rearch.dart';

/// {@template Body}
/// Wraps around [Scaffold] and serves as the main body of the application.
/// {@endtemplate}
class Body extends RearchConsumer {
  /// {@macro Body}
  const Body({super.key, this.showAnimatedBackground = true});

  /// Whether to show the animated background.
  final bool showAnimatedBackground;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    const searchBarHeight = 56.0;
    const animationDuration = Duration(milliseconds: 125);

    final (:completionStatus, :toggleCompletionStatus) = use(
      completionStatusCapsule,
    );

    final completionText = completionStatus ? 'completed' : 'incomplete';

    final todoList = use(todoListCapsule);

    final statusWidget = switch (todoList) {
      AsyncLoading() => const CircularProgressIndicator.adaptive(),
      AsyncError(:final error) => Text('$error'),
      AsyncData(data: final todos) when todos.isEmpty => Text(
        'No $completionText todos found',
      ),
      _ => null,
    };

    final updateTodo = use(updateTodoAction);

    final bottomHeightAnimationController = use.animationController(
      duration: animationDuration,
    );

    final (isSearching, setIsSearching) = use.state(false);

    use.effect(() {
      if (isSearching) {
        bottomHeightAnimationController.forward();
      } else {
        bottomHeightAnimationController.reverse();
      }

      return null;
    }, [isSearching, bottomHeightAnimationController]);

    return Scaffold(
      body: AnimatedBuilder(
        animation: bottomHeightAnimationController,
        builder: (context, _) {
          final bottomHeight =
              bottomHeightAnimationController.value * searchBarHeight;
          return Stack(
            children: [
              // The dynamic background
              if (showAnimatedBackground)
                const Positioned.fill(child: DynamicBackground()),

              // The main todos content
              Positioned.fill(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: kToolbarHeight + bottomHeight + 12,
                      ),
                    ),

                    if (todoList case AsyncData(data: final todos))
                      SliverSafeArea(
                        sliver: SliverList.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            return TodoItem(todo: todos[index]);
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // The app bar
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: CustomAppBar(
                  bottomHeight: bottomHeight,
                  completionStatus: completionStatus,
                  toggleCompletionStatus: toggleCompletionStatus,
                  toggleIsSearching: () => setIsSearching(!isSearching),
                  isSearching: isSearching,
                  updateTodo: updateTodo,
                  animationDuration: animationDuration,
                ),
              ),

              // The info/status widget at the bottom
              if (statusWidget != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: max(MediaQuery.paddingOf(context).bottom, 16),
                  child: Center(
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: statusWidget,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
