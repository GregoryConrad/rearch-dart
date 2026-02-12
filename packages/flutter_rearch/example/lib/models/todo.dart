import 'package:mimir/mimir.dart';

/// Represents an item in the todos list.
final class Todo implements Comparable<Todo> {
  /// Creates a new [Todo].
  const Todo({
    required this.timestamp,
    required this.title,
    required this.completed,
    this.description,
  });

  /// Creates a [Todo] from a [MimirDocument].
  factory Todo.fromDocument(MimirDocument document) {
    return Todo(
      timestamp: document['timestamp'] as int,
      title: document['title'] as String,
      description: document['description'] as String?,
      completed: document['completed'] as bool,
    );
  }

  /// Creates a [MimirDocument] from a [Todo].
  MimirDocument toDocument() {
    return {
      'timestamp': timestamp,
      'title': title,
      'description': description,
      'completed': completed,
    };
  }

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

  /// Toggles the completion status of the todo.
  Todo toggleCompletion() => Todo(
    timestamp: timestamp,
    title: title,
    description: description,
    completed: !completed,
  );

  @override
  int compareTo(Todo other) {
    return timestamp.compareTo(other.timestamp);
  }
}

/// Represents the filter for a list of todos.
typedef TodoListFilter = ({String query, bool completionStatus});
