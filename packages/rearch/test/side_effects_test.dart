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
    expect((getState() as AsyncError<int>).previousData, equals(const Some(0)));
  });

  group('side effect transactions', () {
    (
      (int, void Function(int)),
      (int, void Function(int)),
    ) twoSideEffectsCapsule(CapsuleHandle use) => (use.state(0), use.state(1));

    (int, void Function(int)) anotherCapsule(CapsuleHandle use) => use.state(2);

    void Function(int) batchUpdateAllAction(CapsuleHandle use) {
      final ((_, setState1), (_, setState2)) = use(twoSideEffectsCapsule);
      final (_, setState3) = use(anotherCapsule);
      final runTransaction = use.transactionRunner();
      return (n) => runTransaction(() {
            for (final setState in [setState1, setState2, setState3]) {
              setState(n);
            }
          });
    }

    int buildCounterCapsule(CapsuleHandle use) {
      use(twoSideEffectsCapsule);
      use(anotherCapsule);
      if (use.isFirstBuild()) {
        return 1;
      } else {
        return use(buildCounterCapsule) + 1;
      }
    }

    test('one capsule with multiple side effects', () {
      final container = useContainer();

      {
        expect(container.read(buildCounterCapsule), equals(1));

        final ((state1, setState1), (state2, setState2)) =
            container.read(twoSideEffectsCapsule);
        expect(state1, equals(0));
        expect(state2, equals(1));

        container.runTransaction(() {
          setState1(1);
          setState2(2);
        });
      }

      {
        expect(container.read(buildCounterCapsule), equals(2));

        final ((state1, _), (state2, _)) =
            container.read(twoSideEffectsCapsule);
        expect(state1, equals(1));
        expect(state2, equals(2));
      }
    });

    test('multiple capsules with one side effect each', () {
      final container = useContainer();

      {
        expect(container.read(buildCounterCapsule), equals(1));

        final ((state1, setState1), (state2, _)) =
            container.read(twoSideEffectsCapsule);
        final (state3, setState3) = container.read(anotherCapsule);
        expect(state1, equals(0));
        expect(state2, equals(1));
        expect(state3, equals(2));

        container.runTransaction(() {
          setState1(123);
          setState3(123);
        });
      }

      {
        expect(container.read(buildCounterCapsule), equals(2));

        final ((state1, _), (state2, _)) =
            container.read(twoSideEffectsCapsule);
        final (state3, _) = container.read(anotherCapsule);
        expect(state1, equals(123));
        expect(state2, equals(1));
        expect(state3, equals(123));
      }
    });

    test('multiple capsules with multiple side effects', () {
      final container = useContainer();

      {
        expect(container.read(buildCounterCapsule), equals(1));

        final ((state1, _), (state2, _)) =
            container.read(twoSideEffectsCapsule);
        final (state3, _) = container.read(anotherCapsule);
        expect(state1, equals(0));
        expect(state2, equals(1));
        expect(state3, equals(2));

        container.read(batchUpdateAllAction)(1234);
      }

      {
        expect(container.read(buildCounterCapsule), equals(2));

        final ((state1, _), (state2, _)) =
            container.read(twoSideEffectsCapsule);
        final (state3, _) = container.read(anotherCapsule);
        expect(state1, equals(1234));
        expect(state2, equals(1234));
        expect(state3, equals(1234));
      }
    });

    test('nested transactions', () {
      final container = useContainer();

      {
        expect(container.read(buildCounterCapsule), equals(1));

        final ((state1, setState1), (state2, _)) =
            container.read(twoSideEffectsCapsule);
        final (state3, setState3) = container.read(anotherCapsule);
        expect(state1, equals(0));
        expect(state2, equals(1));
        expect(state3, equals(2));

        container.runTransaction(() {
          setState1(321);
          container.read(batchUpdateAllAction)(1234);
          setState3(321);
        });
      }

      {
        expect(container.read(buildCounterCapsule), equals(2));

        final ((state1, _), (state2, _)) =
            container.read(twoSideEffectsCapsule);
        final (state3, _) = container.read(anotherCapsule);
        expect(state1, equals(1234));
        expect(state2, equals(1234));
        expect(state3, equals(321));
      }
    });
  });
}
