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
