import 'package:flutter_rearch_example/models/todo.dart';
import 'package:rearch/rearch.dart';

/// Represents the current filter to search with
/// ('' as a query string represents no current query).
({
  TodoListFilter filter,
  void Function(String) setQueryString,
  void Function() toggleCompletionStatus,
})
filterCapsule(CapsuleHandle use) {
  final (query, setQuery) = use.state('');
  final (completionStatus, setCompletionStatus) = use.state(false);
  return (
    filter: (query: query, completionStatus: completionStatus),
    setQueryString: setQuery,
    toggleCompletionStatus: () => setCompletionStatus(!completionStatus),
  );
}
