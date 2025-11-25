import 'package:flutter_mimir/flutter_mimir.dart';

/// Represents an item in the todos list.
class Todo {
  /// The timestamp of the todo in milliseconds since epoch.
  ///
  /// Used as the primary key for the todo.
  final int timestamp;

  /// The title of the todo.
  final String title;

  /// The description of the todo.
  final String? description;

  /// Whether the todo is completed.
  final bool completed;

  /// Creates a new [Todo].
  const Todo({
    required this.timestamp,
    required this.title,
    this.description,
    required this.completed,
  });

  /// Toggles the completion status of the todo.
  // Should have a @useResult annotation. Check if it is ok to import package:meta
  Todo toggleCompletion() => _copyWith(completed: !completed);

  Todo _copyWith({
    int? timestamp,
    String? title,
    String? Function()? description,
    bool? completed,
  }) {
    return Todo(
      timestamp: timestamp ?? this.timestamp,
      title: title ?? this.title,
      description: description != null ? description() : this.description,
      completed: completed ?? this.completed,
    );
  }
}

/// Utilities for handling conversion between [Todo] and [MimirDocument]s.
extension TodoDocumentUtilities on Todo {
  /// Creates a [MimirDocument] from a [Todo].
  MimirDocument toDocument() {
    return {
      'timestamp': timestamp,
      'title': title,
      'description': description,
      'completed': completed,
    };
  }

  /// Creates a [Todo] from a [MimirDocument].
  static Todo toTodo(MimirDocument document) {
    return Todo(
      timestamp: document['timestamp']!,
      title: document['title']!,
      description: document['description'],
      completed: document['completed']!,
    );
  }
}

/// Represents the filter for a list of todos.
typedef TodoListFilter = ({String query, bool completionStatus});
