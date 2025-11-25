import 'package:flutter/material.dart';
import 'package:flutter_rearch_example/widgets/todo_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('todos can be created and toggled', (tester) async {
    Future<void> pump() => tester.pumpAndSettle();

    Future<void> createTodo({
      required String title,
      String? description,
    }) async {
      await tester.tap(find.byIcon(Icons.edit_rounded));
      await pump();
      await tester.enterText(
        find.widgetWithText(TextField, 'Title'),
        title,
      );
      if (description != null) {
        await tester.enterText(
          find.widgetWithText(TextField, 'Description'),
          description,
        );
      }
      await tester.tap(find.text('Save'));
      await pump();
    }

    Future<void> toggleTodo(String findByText) async {
      await tester.tap(find.text(findByText));
      await pump();
    }

    var showingCompleted = false;
    Future<void> toggleCompletionStatus() async {
      await tester.tap(
        find.widgetWithIcon(
          IconButton,
          showingCompleted
              ? Icons.task_alt_rounded
              : Icons.radio_button_unchecked_rounded,
        ),
      );
      showingCompleted = !showingCompleted;
      await pump();
    }

    await tester.pumpWidget(const TodoApp(showAnimatedBackground: false));
    await pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('foobar'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);

    await createTodo(title: '0', description: 'foobar');
    expect(find.text('0'), findsOneWidget);
    expect(find.text('foobar'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);

    await createTodo(title: '1');
    expect(find.text('0'), findsOneWidget);
    expect(find.text('foobar'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsNothing);

    await createTodo(title: '2');
    expect(find.text('0'), findsOneWidget);
    expect(find.text('foobar'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await toggleCompletionStatus();
    expect(find.text('0'), findsNothing);
    expect(find.text('foobar'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);

    await toggleCompletionStatus();
    expect(find.text('0'), findsOneWidget);
    expect(find.text('foobar'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await toggleTodo('0');
    expect(find.text('0'), findsNothing);
    expect(find.text('foobar'), findsNothing);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await toggleCompletionStatus();
    expect(find.text('0'), findsOneWidget);
    expect(find.text('foobar'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);

    await toggleTodo('foobar');
    expect(find.text('0'), findsNothing);
    expect(find.text('foobar'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);

    await toggleCompletionStatus();
    expect(find.text('0'), findsOneWidget);
    expect(find.text('foobar'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
