import 'package:flutter_mimir/flutter_mimir.dart';
import 'package:flutter_rearch_example/capsules/filter_capsules.dart';
import 'package:flutter_rearch_example/capsules/index_capsules.dart';
import 'package:flutter_rearch_example/models/todo.dart';
import 'package:rearch/rearch.dart';

/// Provides a way to create/update and delete todos.
({void Function(Todo todo) updateTodo, void Function(Todo todo) deleteTodo})
todoListManagerCapsule(CapsuleHandle use) {
  final index = use(indexCapsule);
  return (
    updateTodo: (todo) => index.addDocument(todo.toDocument()),
    deleteTodo: (todo) => index.deleteDocument(todo.timestamp.toString()),
  );
}

/// Represents the todos list using the filter from the [filterManagerCapsule].
AsyncValue<List<Todo>> todoListCapsule(CapsuleHandle use) {
  final index = use(indexCapsule);
  final (:query, :completionStatus) = use(currentFilterCapsule);

  // When query is null/empty, it does not affect the search.
  final documentsStream = use.memo(
    () => index.searchStream(
      query: query,
      filter: Mimir.where('completed', isEqualTo: completionStatus.toString()),
    ),
    [index, query, completionStatus],
  );

  final todoDocumentsState = use.stream(documentsStream);
  return todoDocumentsState.map(
    // I prefer using .sorted() from package:collections
    (todoDocs) => todoDocs.map(TodoDocumentUtilities.toTodo).toList()..sort(),
  );
}

/// An action capsule that updates a given [Todo].
void Function(Todo todo) updateTodoAction(CapsuleHandle use) {
  return use(todoListManagerCapsule).updateTodo;
}
