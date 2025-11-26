# flutter_rearch_example

Simple Flutter TODO List app to show ReArch capabilities.

## How it works

This app is a simple TODO list app that allows you to add, edit, and delete todos.

It uses ReArch to manage the state and dependencies of the app.

The app is built using the following architecture:

- `lib/capsules/`: Contains the capsules that manage the state and dependencies of the app.
- `lib/models/`: Contains the models that represent the data of the app.
- `lib/widgets/`: Contains the widgets that display the data of the app.

### Capsules

In this app, we use capsules to:

#### Mimir index

[index_capsules.dart](lib/capsules/index_capsules.dart)

We have 3 capsules that manage our Mimir dependency:

- [indexAsyncCapsule](lib/capsules/index_capsules.dart#L10): Async capsule that opens the Mimir index.
- [indexWarmUpCapsule](lib/capsules/index_capsules.dart#L15): Warm up capsule that allows for the index to be warmed up for use in the indexCapsule.
- [indexCapsule](lib/capsules/index_capsules.dart#L20): Capsule that provides the Mimir index.

The initialization of the index is asynchronous, but we want to use it in a synchronous manner, so we have to warm up the capsule to wait for the index to be opened. [Warm Up Capsules Documentation](https://rearch.gsconrad.com/en/paradigms/warm-up-capsules)

#### Todo list

[todo_capsules.dart](lib/capsules/todo_capsules.dart)

We have 2 capsules that manage our Todo list:

- [todoListManagerCapsule](lib/capsules/todo_capsules.dart#L9): Capsule that manages the Todo list.
- [todoListCapsule](lib/capsules/todo_capsules.dart#L18): Capsule that provides the Todo list.

The `todoListManagerCapsule` is used to update or delete a Todo in Mimir, and the `todoListCapsule` listens to any changes in Mimir and provides the saved Todos.

We also have a [updateTodoAction](lib/capsules/todo_capsules.dart#L39) an action capsule that updates a given Todo. [Action Capsules Documentation](https://rearch.gsconrad.com/en/paradigms/actions)

#### Filter

[filter_capsules.dart](lib/capsules/filter_capsules.dart)

The same way we have a manager capsule for the Todo list, that updates and deletes Todos, we have a manager capsule for the filters that displays the Todos in the app.

- [filterManagerCapsule](lib/capsules/filter_capsules.dart#L10): Capsule that manages the filter.
- [currentFilterCapsule](lib/capsules/filter_capsules.dart#L15): Capsule that provides the current filter.
- [completionStatusCapsule](lib/capsules/filter_capsules.dart#L20): Capsule that provides the completion status of the todos.
- [setQueryStringAction](lib/capsules/filter_capsules.dart#L25): Action capsule that sets the query string of the filter.

### Models

We have 2 models that represent the data of the app:

- [Todo](lib/models/todo.dart): Model that represents a Todo.
- [TodoListFilter](lib/models/todo.dart#L76): Model that represents the filter for a list of todos.
