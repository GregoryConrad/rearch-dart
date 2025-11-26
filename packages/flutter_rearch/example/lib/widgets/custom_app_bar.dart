import 'dart:ui';

import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_rearch_example/models/todo.dart';
import 'package:flutter_rearch_example/widgets/custom_search_bar.dart';
import 'package:flutter_rearch_example/widgets/dialogs.dart';

/// {@template CustomAppBar}
/// The custom [AppBar] featured in the application.
/// {@endtemplate}
class CustomAppBar extends StatelessWidget {
  /// {@macro CustomAppBar}
  const CustomAppBar({
    required this.bottomHeight,
    required this.completionStatus,
    required this.toggleCompletionStatus,
    required this.isSearching,
    required this.toggleIsSearching,
    required this.updateTodo,
    required this.animationDuration,
    super.key,
  });

  /// The height of the [AppBar.bottom] (this should be an animated value).
  final double bottomHeight;

  /// Whether we are displaying completed or incomplete todos.
  final bool completionStatus;

  /// Callback that toggles the type of todos we are displaying.
  final void Function() toggleCompletionStatus;

  /// Whether or not the AppBar should be displayed with the [CustomSearchBar].
  final bool isSearching;

  /// Toggle for [isSearching].
  final void Function() toggleIsSearching;

  /// Function that creates/updates a given [Todo].
  final void Function(Todo) updateTodo;

  /// The [Duration] of the [CustomSearchBar] open/close animation.
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.paddingOf(context).top + kToolbarHeight + bottomHeight,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AppBar(
            title: const Text(
              'rearch todos',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            elevation: 2,
            scrolledUnderElevation: 2,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.7),
            actions: [
              IconButton(
                tooltip: completionStatus
                    ? 'Show incomplete todos'
                    : 'Show completed todos',
                icon: Icon(
                  completionStatus
                      ? Icons.task_alt_rounded
                      : Icons.radio_button_unchecked_rounded,
                ),
                onPressed: toggleCompletionStatus,
              ),
              IconButton(
                tooltip: 'Search todos',
                icon: const Icon(Icons.search_rounded),
                onPressed: toggleIsSearching,
              ),
              IconButton(
                tooltip: 'Create todo',
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => showCreateTodoDialog(context, updateTodo),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: SizedBox(
                height: bottomHeight,
                child: AnimatedSwitcher(
                  duration: animationDuration,
                  child: isSearching
                      ? CustomSearchBar(close: toggleIsSearching)
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
