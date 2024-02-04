import 'package:wip_flutter_rearch_macros/wip_flutter_rearch_macros.dart';

class Widget {
  const Widget({this.key});
  final Object? key;
}

class BuildContext {}

class WidgetHandle {}

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

// Generic type parameters are currently unimplemented
// @RearchWidget()
// Widget generics<A, B extends num>(A a, B b) => throw UnimplementedError();

void main(List<String> arguments) {
  const StatelessThing([]);
  const StatefulThing([]);
  // const Generics(true, 123);
}
