import 'package:flutter/material.dart';
import 'package:flutter_rearch/experimental.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rearch/rearch.dart';

void main() {
  testWidgets('Injected values are retrieved properly', (tester) async {
    await tester.pumpWidget(
      RearchBootstrapper(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              expect(FooInjection.maybeOf(context), isNull);
              return FooInjection(
                value: 1234,
                child: Builder(
                  builder: (context) {
                    expect(FooInjection.of(context), equals(1234));
                    return Column(
                      children: [
                        FooInjection(
                          value: 4321,
                          child: Builder(
                            builder: (context) {
                              expect(CountInjection.maybeOf(context), isNull);
                              return Text(FooInjection.of(context).toString());
                            },
                          ),
                        ),
                        CountInjection(
                          child: Builder(
                            builder: (context) {
                              expect(CountInjection.of(context).value, 0);
                              return Text(FooInjection.of(context).toString());
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
    expect(find.text('1234'), findsOneWidget);
    expect(find.text('4321'), findsOneWidget);
  });

  testWidgets('Updates to injected values result in rebuilds', (tester) async {
    await tester.pumpWidget(
      RearchBootstrapper(
        child: MaterialApp(
          home: Scaffold(
            body: CountInjection(
              child: Builder(
                builder: (context) {
                  final count = CountInjection.of(context);
                  return TextButton(
                    onPressed: () => count.value++,
                    child: Text(count.value.toString()),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Injections with the same type do not conflict', (tester) async {
    await tester.pumpWidget(
      RearchBootstrapper(
        child: MaterialApp(
          home: Scaffold(
            body: FooInjection(
              value: 123,
              child: BarInjection(
                value: 321,
                child: Builder(
                  builder: (context) {
                    return Column(
                      children: [
                        Text(FooInjection.of(context).toString()),
                        Text(BarInjection.of(context).toString()),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('123'), findsOneWidget);
    expect(find.text('321'), findsOneWidget);
  });
}

class FooInjection extends RearchInjection<FooInjection, int> {
  const FooInjection({required this.value, required super.child, super.key});

  final int value;

  @override
  int build(BuildContext context, WidgetHandle use) => value;

  static int of(BuildContext context) =>
      RearchInjection.of<FooInjection, int>(context);

  static int? maybeOf(BuildContext context) =>
      RearchInjection.maybeOf<FooInjection, int>(context);
}

class BarInjection extends RearchInjection<BarInjection, int> {
  const BarInjection({required this.value, required super.child, super.key});

  final int value;

  @override
  int build(BuildContext context, WidgetHandle use) => value;

  static int of(BuildContext context) =>
      RearchInjection.of<BarInjection, int>(context);

  static int? maybeOf(BuildContext context) =>
      RearchInjection.maybeOf<BarInjection, int>(context);
}

class CountInjection
    extends RearchInjection<CountInjection, ValueWrapper<int>> {
  const CountInjection({required super.child, super.key});

  @override
  ValueWrapper<int> build(BuildContext context, WidgetHandle use) =>
      use.data(0);

  static ValueWrapper<int> of(BuildContext context) =>
      RearchInjection.of<CountInjection, ValueWrapper<int>>(context);

  static ValueWrapper<int>? maybeOf(BuildContext context) =>
      RearchInjection.maybeOf<CountInjection, ValueWrapper<int>>(context);
}
