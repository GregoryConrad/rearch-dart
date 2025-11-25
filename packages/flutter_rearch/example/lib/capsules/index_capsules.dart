import 'package:flutter_mimir/flutter_mimir.dart';
import 'package:rearch/rearch.dart';

/// Represents the [MimirIndex] that contains the todos.
Future<MimirIndex> indexAsyncCapsule(CapsuleHandle use) async {
  final instance = await Mimir.defaultInstance;
  return instance.openIndex('todos', primaryKey: 'timestamp');
}

/// Allows for the [indexAsyncCapsule] to more easily be warmed up
/// for use in [indexCapsule].
AsyncValue<MimirIndex> indexWarmUpCapsule(CapsuleHandle use) {
  final future = use(indexAsyncCapsule);
  return use.future(future);
}

/// Acts as a proxy to the warmed-up [indexAsyncCapsule].
MimirIndex indexCapsule(CapsuleHandle use) {
  return use(indexWarmUpCapsule).dataOrElse(
    () => throw StateError('indexWarmUpCapsule was not warmed up!'),
  );
}
