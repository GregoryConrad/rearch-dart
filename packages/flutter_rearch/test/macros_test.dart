import 'package:flutter/widgets.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';

@RearchWidget()
Widget statelessThing(
  List<List<int>> i, {
  // int opt1 = 0, // parameter defaultValue not implemented in macros
  int? opt2,
  int? opt3 = 123,
}) =>
    throw UnimplementedError();

@RearchWidget()
Widget statefulThing(
  List<List<int>> i,
  WidgetHandle use,
  BuildContext context, {
  required WidgetHandle use2,
  required BuildContext context2,
  // int opt1 = 0, // parameter defaultValue not implemented in macros
  int? opt2,
  int? opt3 = 123,
}) =>
    throw UnimplementedError();

@RearchWidget()
Widget generics<A, B extends num>(A a, B b) => throw UnimplementedError();

@RearchInheritedWidget()
(int, void Function()) scopedCount(WidgetHandle use) {
  final (count, setCount) = use.state(0);
  return (count, () => setCount(count + 1));
}

@RearchInheritedWidget()
(int, void Function()) scopedCount2(
  WidgetHandle use, {
  required int startingCount,
}) {
  final (count, setCount) = use.state(startingCount);
  return (count, () => setCount(count + 1));
}

void main() {
  const ScopedCount(child: StatelessThing([]));
  const ScopedCount2(startingCount: 123, child: StatefulThing([]));
  const Generics(true, 123);
}
