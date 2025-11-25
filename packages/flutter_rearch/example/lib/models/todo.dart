import 'package:flutter_mimir/flutter_mimir.dart';

/// Represents an item in the todos list.
typedef Todo = ({
  int timestamp, // milliseconds since epoch
  String title,
  String? description,
  bool completed,
});

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
    return (
      timestamp: document['timestamp']!,
      title: document['title']!,
      description: document['description'],
      completed: document['completed']!,
    );
  }
}

/// Represents the filter for a list of todos.
typedef TodoListFilter = ({String query, bool completionStatus});
