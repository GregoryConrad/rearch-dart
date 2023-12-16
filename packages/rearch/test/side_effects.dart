import 'package:rearch/rearch.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  test('invalidatableFuture', () async {
    var shouldError = false;

    (AsyncValue<int> Function(), void Function()) testCapsule(
      CapsuleHandle use,
    ) {
      return use.invalidatableFuture(() async {
        if (shouldError) throw Exception();
        return 0;
      });
    }

    final container = useContainer();
    final (getState, invalidate) = container.read(testCapsule);

    expect(getState(), equals(const AsyncLoading(None<int>())));
    await Future.delayed(Duration.zero, () => null);
    expect(getState(), equals(const AsyncData(0)));

    shouldError = true;
    invalidate();

    expect(getState(), equals(const AsyncLoading(Some(0))));
    await Future.delayed(Duration.zero, () => null);
    expect(getState(), isA<AsyncError<int>>);
    expect(getState().data, equals(const Some(0)));
  });
}
