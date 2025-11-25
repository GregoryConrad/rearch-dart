import 'package:flutter/material.dart';
import 'package:flutter_rearch_example/models/todo.dart';

/// Shows a dialog that enables users to create todos.
Future<void> showCreateTodoDialog(
  BuildContext context,
  void Function(Todo) todoCreator,
) {
  var (title, description) = ('', '');
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.edit_rounded),
        title: const Text('Create Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (newTitle) => title = newTitle,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              onChanged: (newDescription) => description = newDescription,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              todoCreator(
                (
                  title: title,
                  description: description == '' ? null : description,
                  completed: false,
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

/// Shows a deletion confirmation dialog.
Future<void> showDeletionConfirmationDialog(
  BuildContext context,
  void Function() delete,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.delete_rounded),
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              delete();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
