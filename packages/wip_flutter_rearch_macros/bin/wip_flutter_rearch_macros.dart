import 'package:wip_flutter_rearch_macros/wip_flutter_rearch_macros.dart';

class Widget {
  const Widget({this.key});
  final Object? key;
}

class BuildContext {}

class WidgetHandle {}

abstract class RearchConsumer extends Widget {
  const RearchConsumer({super.key});
  Widget build(BuildContext context, WidgetHandle use);
}

@RearchWidget()
Widget thing(
  List<List<int>> i,
  WidgetHandle use,
  BuildContext context, {
  required WidgetHandle use2,
  required BuildContext context2,
}) =>
    throw UnimplementedError();

void main(List<String> arguments) {
  const Thing([]);
}
