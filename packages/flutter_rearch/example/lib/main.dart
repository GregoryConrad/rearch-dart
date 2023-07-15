import 'dart:ui';

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
    const searchBarHeight = 56.0;
    const animationDuration = Duration(milliseconds: 125);

    final (
      filter: (query: _, :completionStatus),
      setQueryString: _,
      :toggleCompletionStatus,
    ) = use(filterCapsule);
    final completionText = completionStatus ? 'completed' : 'incomplete';

    final todoListLengthState = use(todoListLengthCapsule);
    final todoListLength = todoListLengthState.dataOr(0);
    final statusWidget = switch (todoListLengthState) {
      AsyncLoading() => const CircularProgressIndicator.adaptive(),
      AsyncError(:final error) => Text('$error'),
      AsyncData(data: final length) when length == 0 =>
        Text('No $completionText todos found'),
      _ => null,
    };

    final (:updateTodo, deleteTodo: _) = use(todoListManagerCapsule);

    final bottomHeightAnimationController =
        use.animationController(duration: animationDuration);

    final (isSearching, setIsSearching) = use.state(false);
    use.effect(
      () {
        if (isSearching) {
          bottomHeightAnimationController.forward();
        } else {
          bottomHeightAnimationController.reverse();
        }
        return null;
      },
      [isSearching, bottomHeightAnimationController],
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: bottomHeightAnimationController,
        builder: (context, _) {
          final bottomHeight =
              bottomHeightAnimationController.value * searchBarHeight;
          return Stack(
            children: [
              // The dynamic background
              const Positioned.fill(child: DynamicBackground()),

              // The main todos content
              Positioned.fill(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: kToolbarHeight + 12 + bottomHeight,
                      ),
                    ),
                    SliverSafeArea(
                      sliver: SliverList.builder(
                        itemCount: todoListLength,
                        itemBuilder: (context, index) => TodoItem(index: index),
                      ),
                    ),
                  ],
                ),
              ),

              // The app bar
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: SizedBox(
                  height: MediaQuery.paddingOf(context).top +
                      kToolbarHeight +
                      bottomHeight,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: AppBar(
                        title: const Text(
                          'rearch todos',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.8),
                        elevation: 1,
                        scrolledUnderElevation: 1,
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
                            onPressed: () =>
                                showCreateTodoDialog(context, updateTodo),
                          ),
                        ],
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(bottomHeight),
                          child: SizedBox(
                            height: bottomHeight,
                            child: AnimatedSwitcher(
                              duration: animationDuration,
                              child: isSearching
                                  ? SearchBar(
                                      close: () => setIsSearching(false),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // The info/status widget at the bottom
              if (statusWidget != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.paddingOf(context).bottom,
                  child: Center(
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: statusWidget,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// {@template SearchBar}
/// Displays the search bar at the top of the application
/// and mutates the [filterCapsule].
/// {@endtemplate}
class SearchBar extends CapsuleConsumer {
  /// {@macro SearchBar}
  const SearchBar({required this.close, super.key});

  /// Callback that will close the search bar.
  final void Function() close;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final textController = use.textEditingController();

    final (
      filter: _,
      :setQueryString,
      toggleCompletionStatus: _,
    ) = use(filterCapsule);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: TextField(
        controller: textController,
        onChanged: setQueryString,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  if (textController.text == '') {
                    close();
                  } else {
                    textController.text = '';
                    setQueryString('');
                  }
                },
              ),
            ],
          ),
        ),
      ),
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
      key: ValueKey(timestamp),
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
          onLongPress: () => showDeletionConfirmationDialog(context, delete),
        ),
      ),
    );
  }
}

/// {@template DynamicBackground}
/// Displays the bubbly dynamic background effect.
/// {@endtemplate}
class DynamicBackground extends CapsuleConsumer {
  /// {@macro DynamicBackground}
  const DynamicBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    // TODO(GregoryConrad): make the dynamic background effect
    return const Placeholder();
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
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              onChanged: (newDescription) => description = newDescription,
              decoration: const InputDecoration(labelText: 'Description'),
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

/// Shows a deletion confirmation dialog.
Future<void> showDeletionConfirmationDialog(
  BuildContext context,
  void Function() delete,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.delete),
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              delete();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
