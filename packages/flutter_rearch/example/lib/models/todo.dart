import 'package:flutter_mimir/flutter_mimir.dart';

/// Represents an item in the todos list.
class Todo {
  final int timestamp; // milliseconds since epoch
  final String title;
  final String? description;
  final bool completed;

  Todo({
    required this.timestamp,
    required this.title,
    this.description,
    required this.completed,
  });

  Todo copyWith({
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

  Todo toggleCompletion() {
    return copyWith(completed: !completed);
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
