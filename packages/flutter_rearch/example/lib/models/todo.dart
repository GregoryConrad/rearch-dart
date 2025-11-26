import 'package:flutter_mimir/flutter_mimir.dart';

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
  // Should have a @useResult annotation. Check if it is ok to import
  // package:meta
  Todo toggleCompletion() => _copyWith(completed: !completed);

  @override
  int compareTo(Todo other) {
    return timestamp.compareTo(other.timestamp);
  }

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

/// Represents the filter for a list of todos.
typedef TodoListFilter = ({String query, bool completionStatus});
