import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_rearch_example/capsules/todo_capsules.dart';
import 'package:flutter_rearch_example/models/todo.dart';
import 'package:flutter_rearch_example/widgets/dialogs.dart';

/// {@template TodoItem}
/// Displays a singular [Todo] item from the [todoListCapsule].
/// This example is slightly over-engineered to showcase how to reduce rebuilds
/// when dealing with slightly larger lists of data.
/// {@endtemplate}
class TodoItem extends RearchConsumer {
  /// {@macro TodoItem}
  const TodoItem({required this.todo, super.key});

  /// The [Todo] to display.
  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final Todo(:title, :description, :timestamp, :completed) = todo;
    final (:updateTodo, :deleteTodo) = use(todoListManagerCapsule);

    void delete() => deleteTodo(todo);
    void toggleCompletionStatus() => updateTodo(todo.toggleCompletion());

    return Padding(
      key: ValueKey(timestamp),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
        child: ListTile(
          title: Text(title),
          subtitle: description != null ? Text(description) : null,
          leading: Icon(
            completed
                ? Icons.task_alt_rounded
                : Icons.radio_button_unchecked_rounded,
          ),
          onTap: toggleCompletionStatus,
          onLongPress: () => showDeletionConfirmationDialog(context, delete),
        ),
      ),
    );
  }
}
