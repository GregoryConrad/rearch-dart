import 'package:flutter_rearch_example/models/todo.dart';
import 'package:rearch/rearch.dart';

/// Manages the filter for the todo list.
///
/// (An empty [String] as a query string represents no current query).
({
  TodoListFilter filter,
  void Function(String) setQueryString,
  void Function() toggleCompletionStatus,
})
filterManagerCapsule(CapsuleHandle use) {
  final (query, setQuery) = use.state('');
  final (completionStatus, setCompletionStatus) = use.state(false);

  return (
    filter: (query: query, completionStatus: completionStatus),
    setQueryString: setQuery,
    toggleCompletionStatus: () => setCompletionStatus(!completionStatus),
  );
}

/// Represents the current filter to search with
///
/// (An empty [String] as a query string represents no current query).
TodoListFilter currentFilterCapsule(CapsuleHandle use) {
  return use(filterManagerCapsule).filter;
}

({bool completionStatus, void Function() toggleCompletionStatus})
completionStatusCapsule(CapsuleHandle use) {
  final manager = use(filterManagerCapsule);

  return (
    completionStatus: manager.filter.completionStatus,
    toggleCompletionStatus: manager.toggleCompletionStatus,
  );
}
