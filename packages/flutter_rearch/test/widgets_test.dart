import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rearch/rearch.dart';

void main() {
  testWidgets('RearchConsumer rebuilds when constructor params change (#163)',
      (tester) async {
    await tester.pumpWidget(
      const RearchBootstrapper(
        child: MaterialApp(home: Scaffold(body: ParentConsumer())),
      ),
    );
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Used idempotent capsules will not dispose on each build (#170)',
      (tester) async {
    var builds = 0;
    void idempotentCapsule(CapsuleHandle use) => builds++;
    await tester.pumpWidget(
      RearchBootstrapper(
        child: MaterialApp(
          home: Scaffold(
            body: RearchBuilder(
              builder: (context, use) {
                final count = use.data(0);
                if (count.value < 2 || count.value.isEven) {
                  use(idempotentCapsule);
                }

                return TextButton(
                  onPressed: () => count.value++,
                  child: Text(count.value.toString()),
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(builds, equals(1)); // count == 0
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(builds, equals(1)); // count == 1
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(builds, equals(1)); // count == 2
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(builds, equals(1)); // count == 3, capsule not used, disposed
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(builds, equals(2)); // count == 4, capsule used, rebuilt
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(builds, equals(2)); // count == 5, capsule not used, disposed
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(builds, equals(3)); // count == 6, capsule used, rebuilt
  });
}

class ParentConsumer extends RearchConsumer {
  const ParentConsumer({super.key});
  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final value = use.data(0);
    return TextButton(
      onPressed: () => value.value++,
      child: ChildConsumer(value.value),
    );
  }
}

class ChildConsumer extends RearchConsumer {
  const ChildConsumer(this.i, {super.key});
  final int i;
  @override
  Widget build(BuildContext context, WidgetHandle use) {
    return Text('$i');
  }
}
