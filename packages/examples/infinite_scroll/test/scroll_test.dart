import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:infinite_scroll/main.dart';

const itemHeight = 48.0;
const numItemsToShow = 5;
const scrollOffset = Offset(0, 3 * numItemsToShow * itemHeight);

void main() {
  testWidgets('keep alive items are kept alive when scrolled', (tester) async {
    Future<void> scrollUp() async {
      await tester.drag(find.byType(InfiniteList), scrollOffset);
      await tester.pump();
    }

    Future<void> scrollDown() async {
      await tester.drag(find.byType(InfiniteList), -scrollOffset);
      await tester.pump();
    }

    void expectItems(Iterable<int> iterable, Matcher matcher) {
      for (final i in iterable) {
        expect(find.text('$i'), matcher);
      }
    }

    await tester.pumpWidget(
      const RearchBootstrapper(
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: numItemsToShow * itemHeight,
              child: InfiniteList(),
            ),
          ),
        ),
      ),
    );

    expectItems(Iterable<int>.generate(numItemsToShow * 2), findsNothing);

    await tester.pumpAndSettle();
    expectItems(Iterable<int>.generate(numItemsToShow), findsOneWidget);
    expectItems(
      Iterable<int>.generate(numItemsToShow, (i) => i + numItemsToShow),
      findsNothing,
    );

    await tester.tap(find.text('0'));
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();

    await scrollDown();
    await tester.pumpAndSettle();
    expectItems(Iterable<int>.generate(numItemsToShow), findsNothing);

    await scrollUp();
    expectItems([0, 2], findsOneWidget);
    expectItems([1, 3, 4, 5], findsNothing);

    await tester.pumpAndSettle();
    expectItems(Iterable<int>.generate(numItemsToShow), findsOneWidget);
    expectItems(
      Iterable<int>.generate(numItemsToShow, (i) => i + numItemsToShow),
      findsNothing,
    );

    await tester.tap(find.text('0'));
    await tester.tap(find.text('2'));
    await tester.pump();

    await scrollDown();
    await tester.pumpAndSettle();
    expectItems(Iterable<int>.generate(numItemsToShow), findsNothing);

    await scrollUp();
    expectItems(Iterable<int>.generate(numItemsToShow * 2), findsNothing);

    await tester.pumpAndSettle();
    expectItems(Iterable<int>.generate(numItemsToShow), findsOneWidget);
    expectItems(
      Iterable<int>.generate(numItemsToShow, (i) => i + numItemsToShow),
      findsNothing,
    );
  });
}
