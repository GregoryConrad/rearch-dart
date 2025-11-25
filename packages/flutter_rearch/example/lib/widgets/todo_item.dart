import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_rearch_example/capsules/todo_capsules.dart';
import 'package:flutter_rearch_example/models/todo.dart';
import 'package:flutter_rearch_example/widgets/dialogs.dart';
import 'package:rearch/rearch.dart';

/// {@template TodoItem}
/// Displays a singular [Todo] item from the [todoListCapsule].
/// This example is slightly over-engineered to showcase how to reduce rebuilds
/// when dealing with slightly larger lists of data.
/// {@endtemplate}
class TodoItem extends RearchConsumer {
  /// {@macro TodoItem}
  const TodoItem({required this.index, super.key});

  /// The [index] of this [TodoItem] in the [todoListCapsule].
  final int index;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    // The following uses a more advanced technique in rearch: inline capsules.
    // This is similar to `select` in other state management frameworks, but
    // inline capsules are much more powerful because they are full capsules.
    // Please read the documentation for more.
    final (:title, :description, :timestamp, :completed) = use(
      todoListCapsule.map(
        (asyncList) => asyncList.dataOrElse(
          () => throw StateError(
            'In order to display a TodoItem, the todo list must have data!',
          ),
        )[index],
      ),
    );

    final (:updateTodo, :deleteTodo) = use(todoListManagerCapsule);

    void delete() => deleteTodo(timestamp);
    void toggleCompletionStatus() {
      updateTodo(
        (
          title: title,
          description: description,
          timestamp: timestamp,
          completed: !completed,
        ),
      );
    }

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
