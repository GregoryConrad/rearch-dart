import 'package:flutter_test/flutter_test.dart';
import 'package:rearch/rearch.dart';

CapsuleContainer useContainer() {
  final container = CapsuleContainer();
  addTearDown(container.dispose);
  return container;
}
