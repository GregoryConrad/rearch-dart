import 'package:rearch/rearch.dart';
import 'package:test/test.dart';

CapsuleContainer useContainer() {
  final container = CapsuleContainer();
  addTearDown(container.dispose);
  return container;
}

MockableContainer useMockableContainer() {
  final container = MockableContainer();
  addTearDown(container.dispose);
  return container;
}
