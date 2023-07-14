import 'package:flutter/material.dart';
import 'package:flutter_mimir/flutter_mimir.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';

void main() => runApp(const TodoApp());

/// Represents the [MimirIndex] that contains the movie dataset.
Future<MimirIndex> indexAsyncCapsule(CapsuleHandle use) async {
  final instance = await Mimir.defaultInstance;
  return instance.openIndex('todos', primaryKey: 'timestamp');
}

/// Allows for the [indexAsyncCapsule] to more easily be warmed up
/// for use in [indexCapsule].
AsyncValue<MimirIndex> indexWarmUpCapsule(CapsuleHandle use) {
  final future = use(indexAsyncCapsule);
  return use.future(future);
}

/// Acts as a proxy to the warmed-up [indexAsyncCapsule].
MimirIndex indexCapsule(CapsuleHandle use) {
  return use(indexWarmUpCapsule).data.unwrapOrElse(
        () => throw StateError('indexAsyncCapsule was not warmed up!'),
      );
}

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

/// Provides a way to create/update and delete todos.
({
  void Function(Todo) updateTodo,
  void Function(int) deleteTodo,
}) todoListManagerCapsule(CapsuleHandle use) {
  final index = use(indexCapsule);
  return (
    updateTodo: (todo) => index.addDocument(todo.toDocument()),
    deleteTodo: (timestamp) => index.deleteDocument(timestamp.toString()),
  );
}

/// Represents the filter for a list of todos.
typedef TodoListFilter = ({
  String query,
  bool completionStatus,
});

/// Represents the current filter to search with
/// ('' as a query string represents no current query).
({
  TodoListFilter filter,
  void Function(String) setQueryString,
  void Function() toggleCompletionStatus,
}) filterCapsule(CapsuleHandle use) {
  final (query, setQuery) = use.state('');
  final (completionStatus, setCompletionStatus) = use.state(false);
  return (
    filter: (query: query, completionStatus: completionStatus),
    setQueryString: setQuery,
    toggleCompletionStatus: () => setCompletionStatus(!completionStatus),
  );
}

/// Represents the todos list using the filter from the [filterCapsule].
AsyncValue<List<Todo>> todoListCapsule(CapsuleHandle use) {
  final index = use(indexCapsule);
  final (
    filter: (:query, :completionStatus),
    setQueryString: _,
    toggleCompletionStatus: _
  ) = use(filterCapsule);

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
    (todoDocs) => todoDocs.map(TodoDocumentUtilities.toTodo).toList()
      ..sort((todo1, todo2) => todo1.timestamp.compareTo(todo2.timestamp)),
  );
}

/// Represents the length of the [todoListCapsule].
AsyncValue<int> todoListLengthCapsule(CapsuleHandle use) =>
    use(todoListCapsule).map((todos) => todos.length);

/// {@template TodoApp}
/// Wraps around [MaterialApp] and is the entry point [Widget] of the app.
/// {@endtemplate}
class TodoApp extends StatelessWidget {
  /// {@macro TodoApp}
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RearchBootstrapper(
      child: MaterialApp(
        title: 'Rearch Todos',
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: const GlobalWarmUps(child: Body()),
      ),
    );
  }
}

/// {@template GlobalWarmUps}
/// Warms up all of the global warm up capsules so that the rest of the app
/// doesn't have to individually handle failure states.
/// {@endtemplate}
final class GlobalWarmUps extends CapsuleConsumer {
  /// {@macro GlobalWarmUps}
  const GlobalWarmUps({required this.child, super.key});

  /// The [Widget] to show when all warm up capsules are [AsyncData]s.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    return [
      use(indexWarmUpCapsule),
    ].toWarmUpWidget(
      child: child,
      loading: const Center(child: CircularProgressIndicator.adaptive()),
      errorBuilder: (errors) => Column(
        children: [
          for (final AsyncError(:error, :stackTrace) in errors)
            Text('$error\n$stackTrace'),
        ],
      ),
    );
  }
}

/// {@template Body}
/// Wraps around [Scaffold] and serves as the main body of the application.
/// {@endtemplate}
class Body extends CapsuleConsumer {
  /// {@macro Body}
  const Body({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (isSearching, setIsSearching) = use.state(false);

    final (
      filter: (query: _, :completionStatus),
      setQueryString: _,
      :toggleCompletionStatus,
    ) = use(filterCapsule);

    final (:updateTodo, deleteTodo: _) = use(todoListManagerCapsule);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'rearch todos',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        toolbarOpacity: 0.75,
        bottomOpacity: 0.75,
        actions: [
          IconButton(
            icon: Icon(
              completionStatus
                  ? Icons.task_alt_rounded
                  : Icons.radio_button_unchecked_rounded,
            ),
            onPressed: toggleCompletionStatus,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => setIsSearching(!isSearching),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => showCreateTodoDialog(context, updateTodo),
          )
        ],
        // TODO(GregoryConrad): bottom: PreferredSizeWidget,
      ),
      // TODO(GregoryConrad): lets do that fun bubble effect
      body: const TodoList(),
    );
  }
}

/// {@template TodoList}
/// Displays the current list of todos based on the [filterCapsule],
/// including support for when the todos are [AsyncLoading] and [AsyncError].
/// {@endtemplate}
class TodoList extends CapsuleConsumer {
  /// {@macro TodoList}
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final completionFilter = use(filterCapsule).filter.completionStatus;
    final completionText = completionFilter ? 'completed' : 'incomplete';

    final todoListLength = use(todoListLengthCapsule);

    final todoListWidget = todoListLength.data.map((length) {
      return ListView.builder(
        itemCount: length,
        itemBuilder: (context, index) => TodoItem(index: index),
      );
    }).asNullable();

    final infoWidget = switch (todoListLength) {
      AsyncLoading() => const CircularProgressIndicator.adaptive(),
      AsyncError(:final error) => Text('$error'),
      AsyncData(data: final length) when length == 0 =>
        Text('No $completionText todos found'),
      _ => null,
    };

    return Stack(
      children: [
        if (todoListWidget != null)
          Positioned.fill(
            child: todoListWidget,
          ),
        if (infoWidget != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: infoWidget,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// {@template TodoItem}
/// Displays a singular [Todo] item from the [todoListCapsule].
/// This example is slightly over-engineered to showcase how to reduce rebuilds
/// when dealing with slightly larger lists of data.
/// {@endtemplate}
class TodoItem extends CapsuleConsumer {
  /// {@macro TodoItem}
  const TodoItem({required this.index, super.key});

  /// The [index] of this [TodoItem] in the [todoListCapsule].
  final int index;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    // The following uses a more advanced technique in rearch: inline capsules.
    // This is similar to `select` in other state management frameworks, but
    // inline capsules are much more powerful because they are full capsules.
    // Please read the documentation to learn more about inline capsules
    // *before using them*, because:
    // > with great power comes great responsibility
    // (you can accidentally cause leaks if you're not careful)
    final (:title, :description, :timestamp, :completed) = use(
      (CapsuleReader use) => use(todoListCapsule).dataOrElse(
        () => throw StateError(
          'In order to display a TodoItem, the todo list must have data!',
        ),
      )[index],
    );

    final (:updateTodo, :deleteTodo) = use(todoListManagerCapsule);

    void delete() => deleteTodo(timestamp);
    void toggleCompletionStatus() {
      updateTodo(
        (
          title: title,
          description: description,
          timestamp: timestamp,
          completed: !completed,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        child: ListTile(
          title: Text(title),
          subtitle: description != null ? Text(description) : null,
          leading: Icon(
            completed
                ? Icons.task_alt_rounded
                : Icons.radio_button_unchecked_rounded,
          ),
          onTap: toggleCompletionStatus,
          onLongPress: delete,
        ),
      ),
    );
  }
}

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
        icon: const Icon(Icons.edit),
        title: const Text('Create Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (newTitle) => title = newTitle,
            ),
            TextField(
              onChanged: (newDescription) => description = newDescription,
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
