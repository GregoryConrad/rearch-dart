import 'package:rearch/rearch.dart';

/// Represents a manager of the count;
/// i.e., has the count and a way to manage that count.
(int, void Function(int)) countManager(CapsuleHandle use) => use.state(0);

/// Provides a function that increments the count.
/// Note: normally this would just be done with the `countManager` capsule;
/// it is separate in this example to demonstrate capsule composability.
void Function() countIncrementer(CapsuleHandle use) {
  final (count, setCount) = use(countManager);
  return () => setCount(count + 1);
}

/// Provides the current count.
/// Note: normally this would just be done with the `countManager` capsule;
/// it is separate in this example to demonstrate capsule composability.
int count(CapsuleHandle use) => use(countManager).$1;

/// Provides the current count plus one.
/// This helps showcase rearch's reactivity.
int countPlusOne(CapsuleHandle use) => use(count) + 1;

/// Entrypoint of the application.
void main() {
  final container = Container();

  assert(
    container.read(count) == 0,
    'count should start at 0',
  );
  assert(
    container.read(countPlusOne) == 1,
    'countPlusOne should start at 1',
  );

  final incrementCount = container.read(countIncrementer);
  incrementCount();

  assert(
    container.read(count) == 1,
    'count should be 1 after count increment',
  );
  assert(
    container.read(countPlusOne) == 2,
    'countPlusOne should be 2 after count increment',
  );

  container.dispose();
}
