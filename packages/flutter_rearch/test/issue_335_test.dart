import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rearch/rearch.dart';

void main() {
  testWidgets('runTxn works after async gap (#335)', (tester) async {
    await tester.pumpWidget(
      const RearchBootstrapper(
        child: MaterialApp(
          home: Scaffold(
            body: AsyncConsumer(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('initial'));
    await tester.pumpAndSettle();
    expect(find.text('pass'), findsOneWidget);
  });
}

class AsyncConsumer extends RearchConsumer {
  const AsyncConsumer({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final status = use.data('initial');
    final completer = use.lazyValue(Completer.new);

    switch (status.value) {
      case 'initial':
        return RearchBuilder(
          key: ValueKey(status.value),
          builder: (context, use) {
            final runTxn = use.transactionRunner();
            return TextButton(
              onPressed: () async {
                status.value = 'intermediate';
                await completer.future;
                runTxn(() => status.value = 'pass');
              },
              child: Text(status.value),
            );
          },
        );
      case 'intermediate':
        return RearchBuilder(
          key: ValueKey(status.value),
          builder: (context, use) {
            Future.microtask(completer.complete);
            return Text(status.value);
          },
        );
      default:
        return Text(status.value);
    }
  }
}
