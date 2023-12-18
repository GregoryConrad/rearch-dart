import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rearch/rearch.dart';

import 'util.dart';

void main() {
  testWidgets('side effects transactions are done in 1 build', (tester) async {
    (int, void Function(int)) capsule1(CapsuleHandle use) => use.state(0);
    (int, void Function(int)) capsule2(CapsuleHandle use) => use.state(1);
    int buildCounterCapsule(CapsuleHandle use) {
      use(capsule1);
      use(capsule2);
      return use.isFirstBuild() ? 1 : (use(buildCounterCapsule) + 1);
    }

    final container = useContainer();

    var widgetBuildCount = 0;

    await tester.pumpWidget(
      CapsuleContainerProvider(
        container: container,
        child: RearchBuilder(
          builder: (context, use) {
            widgetBuildCount++;

            final (state1, setState1) = use(capsule1);
            final (state2, setState2) = use(capsule2);
            final (state3, setState3) = use.state(2);
            final (state4, setState4) = use.state(3);
            final runTransaction = use.transactionRunner();

            return MaterialApp(
              home: Column(
                children: [
                  for (final (i, value)
                      in [state1, state2, state3, state4].indexed)
                    Text('$i: $value'),
                  TextButton(
                    onPressed: () => runTransaction(() {
                      setState1(123);
                      setState2(123);
                      setState3(123);
                      setState4(123);
                    }),
                    child: const Text('click me'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(widgetBuildCount, equals(1));
    expect(container.read(buildCounterCapsule), equals(1));
    expect(find.text('0: 0'), findsOneWidget);
    expect(find.text('1: 1'), findsOneWidget);
    expect(find.text('2: 2'), findsOneWidget);
    expect(find.text('3: 3'), findsOneWidget);

    await tester.tap(find.byType(TextButton));
    await tester.pump();

    expect(widgetBuildCount, equals(2));
    expect(container.read(buildCounterCapsule), equals(2));
    expect(find.text('0: 123'), findsOneWidget);
    expect(find.text('1: 123'), findsOneWidget);
    expect(find.text('2: 123'), findsOneWidget);
    expect(find.text('3: 123'), findsOneWidget);
  });
}
