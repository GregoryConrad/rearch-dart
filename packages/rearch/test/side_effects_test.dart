import 'package:rearch/experimental.dart';
import 'package:rearch/rearch.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  test('use.data() dependents should rebuild when state updated', () {
    ValueWrapper<int> stateCapsule(CapsuleHandle use) => use.data(0);
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

  test('refreshableFuture', () async {
    var shouldError = false;

    (AsyncValue<int>, Future<int> Function()) testCapsule(CapsuleHandle use) {
      return use.refreshableFuture(() async {
        if (shouldError) throw Exception();
        return 0;
      });
    }

    final container = useContainer();

    AsyncValue<int> getState() => container.read(testCapsule).$1;
    Future<int> refresh() => container.read(testCapsule).$2();

    expect(getState(), equals(const AsyncLoading(None<int>())));
    await Future.delayed(Duration.zero, () => null);
    expect(getState(), equals(const AsyncData(0)));

    shouldError = true;
    final future = refresh();

    expect(getState(), equals(const AsyncLoading(Some(0))));
    expect(future, throwsA(isA<Exception>()));
    await Future.delayed(Duration.zero, () => null);
    expect((getState() as AsyncError<int>).previousData, equals(const Some(0)));

    shouldError = false;
    final newFuture = refresh();

    expect(getState(), equals(const AsyncLoading(Some(0))));
    expect(await newFuture, equals(0));
    expect((getState() as AsyncData<int>).data, equals(0));
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
      final hydrateState = use.hydrate(state, read: read, write: write);
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

  test('replay', () {
    (int?, void Function(int), {void Function()? undo, void Function()? redo})
    replayCapsule(CapsuleHandle use) => use.replay();

    final container = useContainer();
    expect(container.read(replayCapsule).$1, equals(null));
    expect(container.read(replayCapsule).undo, equals(null));
    expect(container.read(replayCapsule).redo, equals(null));

    container.read(replayCapsule).$2(1);
    expect(container.read(replayCapsule).$1, equals(1));
    expect(container.read(replayCapsule).undo, isA<void Function()>());
    expect(container.read(replayCapsule).redo, equals(null));

    container.read(replayCapsule).$2(1);
    expect(container.read(replayCapsule).$1, equals(1));
    expect(container.read(replayCapsule).undo, isA<void Function()>());
    expect(container.read(replayCapsule).redo, equals(null));

    container.read(replayCapsule).$2(2);
    expect(container.read(replayCapsule).$1, equals(2));
    expect(container.read(replayCapsule).undo, isA<void Function()>());
    expect(container.read(replayCapsule).redo, equals(null));

    container.read(replayCapsule).undo!();
    expect(container.read(replayCapsule).$1, equals(1));
    expect(container.read(replayCapsule).undo, isA<void Function()>());
    expect(container.read(replayCapsule).redo, isA<void Function()>());

    container.read(replayCapsule).undo!();
    expect(container.read(replayCapsule).$1, equals(null));
    expect(container.read(replayCapsule).undo, equals(null));
    expect(container.read(replayCapsule).redo, isA<void Function()>());

    container.read(replayCapsule).redo!();
    expect(container.read(replayCapsule).$1, equals(1));
    expect(container.read(replayCapsule).undo, isA<void Function()>());
    expect(container.read(replayCapsule).redo, isA<void Function()>());

    container.read(replayCapsule).undo!();
    expect(container.read(replayCapsule).$1, equals(null));
    expect(container.read(replayCapsule).undo, equals(null));
    expect(container.read(replayCapsule).redo, isA<void Function()>());

    container.read(replayCapsule).redo!();
    expect(container.read(replayCapsule).$1, equals(1));
    expect(container.read(replayCapsule).undo, isA<void Function()>());
    expect(container.read(replayCapsule).redo, isA<void Function()>());

    container.read(replayCapsule).redo!();
    expect(container.read(replayCapsule).$1, equals(2));
    expect(container.read(replayCapsule).undo, isA<void Function()>());
    expect(container.read(replayCapsule).redo, equals(null));

    container.read(replayCapsule).undo!();
    expect(container.read(replayCapsule).$1, equals(1));
    expect(container.read(replayCapsule).undo, isA<void Function()>());
    expect(container.read(replayCapsule).redo, isA<void Function()>());

    container.read(replayCapsule).$2(1234);
    expect(container.read(replayCapsule).$1, equals(1234));
    expect(container.read(replayCapsule).undo, isA<void Function()>());
    expect(container.read(replayCapsule).redo, equals(null));
  });

  group('side effect transactions', () {
    ((int, void Function(int)), (int, void Function(int)))
    twoSideEffectsCapsule(CapsuleHandle use) => (use.state(0), use.state(1));

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

        final ((state1, setState1), (state2, setState2)) = container.read(
          twoSideEffectsCapsule,
        );
        expect(state1, equals(0));
        expect(state2, equals(1));

        container.runTransaction(() {
          setState1(1);
          setState2(2);
        });
      }

      {
        expect(container.read(buildCounterCapsule), equals(2));

        final ((state1, _), (state2, _)) = container.read(
          twoSideEffectsCapsule,
        );
        expect(state1, equals(1));
        expect(state2, equals(2));
      }
    });

    test('multiple capsules with one side effect each', () {
      final container = useContainer();

      {
        expect(container.read(buildCounterCapsule), equals(1));

        final ((state1, setState1), (state2, _)) = container.read(
          twoSideEffectsCapsule,
        );
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

        final ((state1, _), (state2, _)) = container.read(
          twoSideEffectsCapsule,
        );
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

        final ((state1, _), (state2, _)) = container.read(
          twoSideEffectsCapsule,
        );
        final (state3, _) = container.read(anotherCapsule);
        expect(state1, equals(0));
        expect(state2, equals(1));
        expect(state3, equals(2));

        container.read(batchUpdateAllAction)(1234);
      }

      {
        expect(container.read(buildCounterCapsule), equals(2));

        final ((state1, _), (state2, _)) = container.read(
          twoSideEffectsCapsule,
        );
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

        final ((state1, setState1), (state2, _)) = container.read(
          twoSideEffectsCapsule,
        );
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

        final ((state1, _), (state2, _)) = container.read(
          twoSideEffectsCapsule,
        );
        final (state3, _) = container.read(anotherCapsule);
        expect(state1, equals(1234));
        expect(state2, equals(1234));
        expect(state3, equals(321));
      }
    });

    test('side effect mutations are batched at end of txn', () {
      var builds = 0;
      ValueWrapper<int> lazyStateCapsule(CapsuleHandle use) {
        builds++;
        return use.data(0);
      }

      final container = useContainer();
      container.runTransaction(() {
        container.read(lazyStateCapsule).$2(1);
        container.read(lazyStateCapsule).$2(2);
        expect(container.read(lazyStateCapsule).$1(), equals(0));
        expect(builds, equals(1));
      });
      expect(container.read(lazyStateCapsule).$1(), equals(2));
      expect(builds, equals(2));
    });
  });

  test("use.lazyData() doesn't call init fn unless necessary", () {
    var initCalls = 0;
    void init() => initCalls++;
    ValueWrapper<void> testCapsule(CapsuleHandle use) => use.lazyData(init);

    final container1 = useContainer();
    container1.read(testCapsule).$1();
    expect(initCalls, equals(1));

    final container2 = useContainer();
    container2.read(testCapsule).$2(null);
    container2.read(testCapsule).$1();
    expect(initCalls, equals(1));
  });

  test('use.lazyData() getter is memoized (#277)', () {
    final stateCapsule = capsule((use) => use.lazyData(() => 0));

    final container = useContainer();
    final originalGetter = container.read(stateCapsule).$1;

    container.read(stateCapsule).value = 0;
    final unchangedGetter = container.read(stateCapsule).$1;
    expect(unchangedGetter, isNot(equals(originalGetter)));

    container.read(stateCapsule).value = 1;
    final changedGetter = container.read(stateCapsule).$1;
    expect(changedGetter, isNot(equals(originalGetter)));

    container.read(stateCapsule).value = 1;
    final unchangedGetter2 = container.read(stateCapsule).$1;
    expect(unchangedGetter2, equals(changedGetter));

    container.read(stateCapsule).value = 2;
    final changedGetter2 = container.read(stateCapsule).$1;
    expect(changedGetter2, isNot(equals(unchangedGetter2)));
  });

  group('disposable creates and disposes objects', () {
    test('without dependencies', () {
      var check = 0;
      int capsule(CapsuleHandle use) {
        return use.disposable(() => 123, (i) => check = i);
      }

      final container = CapsuleContainer();
      expect(container.read(capsule), equals(123));
      expect(check, equals(0));
      container.dispose();
      expect(check, equals(123));
    });

    test('with dependencies', () {
      var check = 0;
      (int, void Function()) capsule(CapsuleHandle use) {
        final count = use.data(1);
        final c = use.disposable(
          () => count.value,
          (i) => check = i,
          [count.value],
        );
        return (c, () => count.value++);
      }

      final container = CapsuleContainer();
      expect(container.read(capsule).$1, equals(1));
      expect(check, equals(0));
      container.read(capsule).$2();
      expect(container.read(capsule).$1, equals(2));
      expect(check, equals(1));
      container.dispose();
      expect(check, equals(2));
    });
  });

  group('dynamic capsules', () {
    // NOTE: due to a Dart type system quirk (relating only to local variables),
    // this has to be written with `late final` and defined on a new line.
    late final DynamicCapsule<int, BigInt> fibonacciCapsule;
    fibonacciCapsule = capsule.dynamic((use, int n) {
      return switch (n) {
        _ when n < 0 => throw ArgumentError.value(n),
        0 => BigInt.zero,
        1 => BigInt.one,
        _ => use(fibonacciCapsule[n - 1]) + use(fibonacciCapsule[n - 2]),
      };
    });

    test('allow correct creation of fibonacci numbers', () {
      expect(
        useContainer().read(fibonacciCapsule[100]).toString(),
        equals('354224848179261915075'),
      );
    });
  });
}
