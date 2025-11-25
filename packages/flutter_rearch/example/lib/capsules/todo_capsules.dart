import 'package:flutter_mimir/flutter_mimir.dart';
import 'package:flutter_rearch_example/capsules/filter_capsule.dart';
import 'package:flutter_rearch_example/capsules/index_capsules.dart';
import 'package:flutter_rearch_example/models/todo.dart';
import 'package:rearch/rearch.dart';

/// Provides a way to create/update and delete todos.
({void Function(Todo) updateTodo, void Function(int) deleteTodo})
todoListManagerCapsule(CapsuleHandle use) {
  final index = use(indexCapsule);
  return (
    updateTodo: (todo) => index.addDocument(todo.toDocument()),
    deleteTodo: (timestamp) => index.deleteDocument(timestamp.toString()),
  );
}

/// Represents the todos list using the filter from the [filterCapsule].
AsyncValue<List<Todo>> todoListCapsule(CapsuleHandle use) {
  final index = use(indexCapsule);
  final (
    filter: (:query, :completionStatus),
    setQueryString: _,
    toggleCompletionStatus: _,
  ) = use(
    filterCapsule,
  );

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
    (todoDocs) =>
        todoDocs.map(TodoDocumentUtilities.toTodo).toList()
          ..sort((todo1, todo2) => todo1.timestamp.compareTo(todo2.timestamp)),
  );
}

/// Represents the length of the [todoListCapsule].
AsyncValue<int> todoListLengthCapsule(CapsuleHandle use) =>
    use(todoListCapsule).map((todos) => todos.length);
