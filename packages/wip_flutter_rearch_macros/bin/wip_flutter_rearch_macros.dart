import 'package:rearch/rearch.dart';
import 'package:wip_flutter_rearch_macros/wip_flutter_rearch_macros.dart';

class Widget {
  const Widget({this.key});
  final Object? key;
}

abstract class InheritedWidget extends Widget {
  const InheritedWidget({required this.child, super.key});
  final Widget child;
  bool updateShouldNotify(covariant InheritedWidget oldWidget);
}

// ignore: one_member_abstracts
abstract interface class BuildContext {
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>();
}

abstract interface class WidgetHandle implements SideEffectRegistrar {}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key});
  Widget build(BuildContext context);
}

abstract class RearchConsumer extends Widget {
  const RearchConsumer({super.key});
  Widget build(BuildContext context, WidgetHandle use);
}

@RearchWidget()
Widget statelessThing(
  List<List<int>> i, {
  // int opt1 = 0, // parameter defaultValue not implemented in macros yet
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
  // int opt1 = 0, // parameter defaultValue not implemented in macros yet
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

void main(List<String> arguments) {
  const ScopedCount(child: StatelessThing([]));
  const ScopedCount2(startingCount: 123, child: StatefulThing([]));
  const Generics(true, 123);
}
