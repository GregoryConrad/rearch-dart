import 'package:rearch/experimental.dart';
import 'package:rearch/rearch.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  test('stateGetterSetter dependents should rebuild when state updated', () {
    (int Function(), void Function(int)) stateCapsule(CapsuleHandle use) =>
        use.stateGetterSetter(0);
    int currStateCapsule(CapsuleHandle use) => use(stateCapsule).$1();

    final container = useContainer();
    expect(container.read(currStateCapsule), equals(0));
    container.read(stateCapsule).$2(1);
    expect(container.read(currStateCapsule), equals(1));
  });

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

  test('hydrate', () async {
    var writtenData = -1;
    var shouldWriteError = false;
    var writeCount = 0;

    Future<int> read() async => writtenData;

    Future<void> write(int newData) async {
      await null;
      writeCount++;
      if (shouldWriteError) throw Exception();
      writtenData = newData;
    }

    (AsyncValue<int>, void Function(int?)) testCapsule(
      CapsuleHandle use,
    ) {
      final (state, setState) = use.state<int?>(null);
      final hydrateState = use.hydrate(
        state != null ? Some(state) : const None<int>(),
        read: read,
        write: write,
      );
      return (hydrateState, setState);
    }

    final container = useContainer();
    final setState = container.read(testCapsule).$2;

    Future<void> setAndExpect({
      required int? setStateTo,
      required AsyncValue<int> expectInitialHydratedStateToEqual,
      required int? expectNewHydratedStateToEqual, // null for AsyncError
    }) async {
      final initialWriteCount = writeCount;
      final finalWriteCount = setStateTo != null && setStateTo != writtenData
          ? initialWriteCount + 1
          : initialWriteCount;

      setState(setStateTo);

      expect(
        container.read(testCapsule).$1,
        equals(expectInitialHydratedStateToEqual),
      );
      expect(writeCount, equals(initialWriteCount));

      await null;

      if (expectNewHydratedStateToEqual == null) {
        container.read(testCapsule).$1 as AsyncError; // should not throw
      } else {
        expect(
          container.read(testCapsule).$1,
          equals(AsyncData(expectNewHydratedStateToEqual)),
        );
      }
      expect(writeCount, equals(finalWriteCount));
    }

    await setAndExpect(
      setStateTo: null,
      expectInitialHydratedStateToEqual: const AsyncLoading(None<int>()),
      expectNewHydratedStateToEqual: -1,
    );
    await setAndExpect(
      setStateTo: 0,
      expectInitialHydratedStateToEqual: const AsyncLoading(Some(-1)),
      expectNewHydratedStateToEqual: 0,
    );
    await setAndExpect(
      setStateTo: null,
      expectInitialHydratedStateToEqual: const AsyncData(0),
      expectNewHydratedStateToEqual: 0,
    );
    await setAndExpect(
      setStateTo: 1,
      expectInitialHydratedStateToEqual: const AsyncLoading(Some(0)),
      expectNewHydratedStateToEqual: 1,
    );
    await setAndExpect(
      setStateTo: 1,
      expectInitialHydratedStateToEqual: const AsyncData(1),
      expectNewHydratedStateToEqual: 1,
    );
    await setAndExpect(
      setStateTo: 2,
      expectInitialHydratedStateToEqual: const AsyncLoading(Some(1)),
      expectNewHydratedStateToEqual: 2,
    );
    shouldWriteError = true;
    await setAndExpect(
      setStateTo: 3,
      expectInitialHydratedStateToEqual: const AsyncLoading(Some(2)),
      expectNewHydratedStateToEqual: null,
    );
    shouldWriteError = false;
    await setAndExpect(
      setStateTo: 4,
      expectInitialHydratedStateToEqual: const AsyncLoading(Some(2)),
      expectNewHydratedStateToEqual: 4,
    );
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
