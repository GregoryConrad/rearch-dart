import 'package:rearch/rearch.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  test('basic count example', () {
    int count(CapsuleHandle _) => 0;
    int countPlusOne(CapsuleHandle use) => use(count) + 1;

    final container = useContainer();
    expect(container.read(count), equals(0));
    expect(container.read(countPlusOne), equals(1));
  });

  group('state updates', () {
    (int, void Function(int)) stateful(CapsuleHandle use) => use.state(0);
    int plusOne(CapsuleHandle use) => use(stateful).$1 + 1;

    test('for stateful capsule', () {
      final container = useContainer();

      {
        final (state, setState) = container.read(stateful);
        expect(state, equals(0));
        setState(1);
      }

      {
        final (state, setState) = container.read(stateful);
        expect(state, equals(1));
        setState(2);
        setState(3);
      }

      {
        final (state, _) = container.read(stateful);
        expect(state, equals(3));
      }
    });

    test('for dependent capsule', () {
      final container = useContainer();

      {
        final (state, setState) = container.read(stateful);
        final statePlusOne = container.read(plusOne);
        expect(state, equals(0));
        expect(statePlusOne, equals(1));
        setState(1);
      }

      {
        final (state, _) = container.read(stateful);
        final statePlusOne = container.read(plusOne);
        expect(state, equals(1));
        expect(statePlusOne, equals(2));
      }
    });
  });

  test('multiple side effects', () {
    ((int, void Function(int)), (int, void Function(int))) multi(
      CapsuleHandle use,
    ) {
      return (use.state(0), use.state(1));
    }

    final container = useContainer();

    {
      final ((s1, set1), (s2, set2)) = container.read(multi);
      expect(s1, equals(0));
      expect(s2, equals(1));
      set1(1);
      set2(2);
    }

    {
      final ((s1, _), (s2, _)) = container.read(multi);
      expect(s1, equals(1));
      expect(s2, equals(2));
    }
  });

  test('listener gets updates', () {
    (int, void Function(int)) stateful(CapsuleHandle use) => use.state(0);

    final container = useContainer();
    void setState(int state) => container.read(stateful).$2(state);

    final states = <int>[];
    void listener(CapsuleReader use) => states.add(use(stateful).$1);

    setState(1);
    final dispose1 = container.listen(listener);
    setState(2);
    setState(3);

    dispose1();
    setState(4);

    setState(5);
    final dispose2 = container.listen(listener);
    setState(6);
    setState(7);

    dispose2();
    setState(8);

    expect(states, equals([1, 2, 3, 5, 6, 7]));
  });

  test('listeners cannot trigger rebuilds', () {
    (int, void Function(int)) statefulCapsule(CapsuleHandle use) =>
        use.state(0);

    final container = useContainer();
    expect(
      () => container.listen((use) => use(statefulCapsule).$2(4321)),
      throwsA(isA<AssertionError>()),
    );
  });

  test('capsules cannot trigger rebuild in an ongoing build', () {
    (int, void Function(int)) statefulCapsule(CapsuleHandle use) =>
        use.state(0);
    void shouldThrow(CapsuleHandle use) => use(statefulCapsule).$2(1234);

    final container = useContainer();
    expect(() => container.read(shouldThrow), throwsA(isA<AssertionError>()));
  });

  test('generic capsules', () {
    var builds = 0;
    late num value;

    T generic<T extends num>(CapsuleHandle use) {
      builds++;
      return value as T;
    }

    final genericDouble1 = generic<double>;
    final genericDouble2 = generic<double>;

    final container = useContainer();
    final toTry = [
      (generic<int>, 0),
      (generic<int>, 0),
      (genericDouble1, 0.0),
      (genericDouble2, 0.0),
    ];
    for (final (f, val) in toTry) {
      value = val;
      container.read(f);
    }
    expect(builds, equals(2)); // once for int, once for double
  });

  test('capsule can read self after first build', () {
    void shouldThrow(CapsuleHandle use) => use(shouldThrow);
    (int, void Function()) buildCounter(CapsuleHandle use) {
      final isFirstBuild = use.isFirstBuild();
      final buildCount = isFirstBuild ? 1 : (use(buildCounter).$1 + 1);
      final rebuild = use.rebuilder();
      return (buildCount, rebuild);
    }

    final container = useContainer();

    expect(() => container.read(shouldThrow), throwsStateError);
    for (final i in Iterable.generate(3, (i) => i + 1)) {
      final (buildCount, rebuild) = container.read(buildCounter);
      expect(buildCount, equals(i));
      rebuild();
    }
  });

  test('== check skips unneeded rebuilds', () {
    final builds = <Capsule<Object?>, int>{};

    (int, void Function(int)) stateful(CapsuleHandle use) {
      builds.update(stateful, (count) => count + 1, ifAbsent: () => 1);
      return use.state(0);
    }

    int unchangingIdempotentDep(CapsuleHandle use) {
      builds.update(
        unchangingIdempotentDep,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      use(stateful);
      return 0;
    }

    int unchangingWatcher(CapsuleHandle use) {
      builds.update(
        unchangingWatcher,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      return use(unchangingIdempotentDep);
    }

    int changingIdempotentDep(CapsuleHandle use) {
      builds.update(
        changingIdempotentDep,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      return use(stateful).$1;
    }

    int changingWatcher(CapsuleHandle use) {
      builds.update(
        changingWatcher,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      return use(changingIdempotentDep);
    }

    void impureSink(CapsuleHandle use) {
      use.register((_) {});
      use(changingWatcher);
      use(unchangingWatcher);
    }

    final container = useContainer();

    expect(container.read(unchangingWatcher), equals(0));
    expect(container.read(changingWatcher), equals(0));
    expect(builds[stateful], equals(1));
    expect(builds[unchangingIdempotentDep], equals(1));
    expect(builds[changingIdempotentDep], equals(1));
    expect(builds[unchangingWatcher], equals(1));
    expect(builds[changingWatcher], equals(1));

    container.read(stateful).$2(0);
    expect(builds[stateful], equals(2));
    expect(builds[unchangingIdempotentDep], equals(1));
    expect(builds[changingIdempotentDep], equals(1));
    expect(builds[unchangingWatcher], equals(1));
    expect(builds[changingWatcher], equals(1));

    expect(container.read(unchangingWatcher), equals(0));
    expect(container.read(changingWatcher), equals(0));
    expect(builds[stateful], equals(2));
    expect(builds[unchangingIdempotentDep], equals(1));
    expect(builds[changingIdempotentDep], equals(1));
    expect(builds[unchangingWatcher], equals(1));
    expect(builds[changingWatcher], equals(1));

    container.read(stateful).$2(1);
    expect(builds[stateful], equals(3));
    expect(builds[unchangingIdempotentDep], equals(1));
    expect(builds[changingIdempotentDep], equals(1));
    expect(builds[unchangingWatcher], equals(1));
    expect(builds[changingWatcher], equals(1));

    expect(container.read(unchangingWatcher), equals(0));
    expect(container.read(changingWatcher), equals(1));
    expect(builds[stateful], equals(3));
    expect(builds[unchangingIdempotentDep], equals(2));
    expect(builds[changingIdempotentDep], equals(2));
    expect(builds[unchangingWatcher], equals(2));
    expect(builds[changingWatcher], equals(2));

    // Disable the idempotent gc
    container.read(impureSink);

    container.read(stateful).$2(2);
    expect(builds[stateful], equals(4));
    expect(builds[unchangingIdempotentDep], equals(3));
    expect(builds[changingIdempotentDep], equals(3));
    expect(builds[unchangingWatcher], equals(2));
    expect(builds[changingWatcher], equals(3));

    expect(container.read(unchangingWatcher), equals(0));
    expect(container.read(changingWatcher), equals(2));
    expect(builds[stateful], equals(4));
    expect(builds[unchangingIdempotentDep], equals(3));
    expect(builds[changingIdempotentDep], equals(3));
    expect(builds[unchangingWatcher], equals(2));
    expect(builds[changingWatcher], equals(3));
  });

  test('errors propagate correctly', () {
    Never throwsErrorCapsule(CapsuleHandle use) =>
        throw UnsupportedError('capsule should throw');
    Never dependentCapsule(CapsuleHandle use) => use(throwsErrorCapsule);
    final container = useContainer();
    expect(
      () => container.read(throwsErrorCapsule),
      throwsA(isA<UnsupportedError>()),
    );
    expect(
      () => container.read(dependentCapsule),
      throwsA(isA<UnsupportedError>()),
    );
  });

  // We use a more sophisticated graph here for a more thorough
  // test of all functionality
  //
  // -> A -> B -> C -> D
  //      \      / \
  //  H -> E -> F -> G
  //
  // C, D, E, G, H are idempotent. A, B, F are not.
  test('complex dependency graph', () {
    final builds = <Capsule<Object?>, int>{};

    (int, void Function(int)) a(CapsuleHandle use) {
      builds.update(a, (count) => count + 1, ifAbsent: () => 1);
      return use.state(0);
    }

    int b(CapsuleHandle use) {
      builds.update(b, (count) => count + 1, ifAbsent: () => 1);
      use.register((_) {});
      return use(a).$1;
    }

    int h(CapsuleHandle use) {
      builds.update(h, (count) => count + 1, ifAbsent: () => 1);
      return 1;
    }

    int e(CapsuleHandle use) {
      builds.update(e, (count) => count + 1, ifAbsent: () => 1);
      return use(a).$1 + use(h);
    }

    int f(CapsuleHandle use) {
      builds.update(f, (count) => count + 1, ifAbsent: () => 1);
      use.register((_) {});
      return use(e);
    }

    int c(CapsuleHandle use) {
      builds.update(c, (count) => count + 1, ifAbsent: () => 1);
      return use(b) + use(f);
    }

    int d(CapsuleHandle use) {
      builds.update(d, (count) => count + 1, ifAbsent: () => 1);
      return use(c);
    }

    int g(CapsuleHandle use) {
      builds.update(g, (count) => count + 1, ifAbsent: () => 1);
      return use(c) + use(f);
    }

    final container = useContainer();
    expect(builds.isEmpty, isTrue);

    expect(container.read(d), equals(1));
    expect(container.read(g), equals(2));
    expect(builds[a], equals(1));
    expect(builds[b], equals(1));
    expect(builds[c], equals(1));
    expect(builds[d], equals(1));
    expect(builds[e], equals(1));
    expect(builds[f], equals(1));
    expect(builds[g], equals(1));
    expect(builds[h], equals(1));

    container.read(a).$2(0);
    expect(container.read(d), equals(1));
    expect(container.read(g), equals(2));
    expect(builds[a], equals(2));
    expect(builds[b], equals(1));
    expect(builds[c], equals(1));
    expect(builds[d], equals(1));
    expect(builds[e], equals(1));
    expect(builds[f], equals(1));
    expect(builds[g], equals(1));
    expect(builds[h], equals(1));

    container.read(a).$2(1);
    expect(builds[a], equals(3));
    expect(builds[b], equals(2));
    expect(builds[c], equals(1));
    expect(builds[d], equals(1));
    expect(builds[e], equals(2));
    expect(builds[f], equals(2));
    expect(builds[g], equals(1));
    expect(builds[h], equals(1));

    expect(container.read(d), equals(3));
    expect(container.read(g), equals(5));
    expect(builds[a], equals(3));
    expect(builds[b], equals(2));
    expect(builds[c], equals(2));
    expect(builds[d], equals(2));
    expect(builds[e], equals(2));
    expect(builds[f], equals(2));
    expect(builds[g], equals(2));
    expect(builds[h], equals(1));
  });

  test('use() called after async gap throws', () {
    void noopCapsule(CapsuleHandle _) {}

    void useInBuildCapsule(CapsuleHandle use) => use(noopCapsule);

    void Function() useInCallbackCapsule(CapsuleHandle use) {
      return () => use(noopCapsule);
    }

    Future<void> useAfterAwaitCapsule(CapsuleHandle use) async {
      await null;
      use(noopCapsule);
    }

    final container = useContainer();
    final _ = container.read(useInBuildCapsule); // should not throw
    expect(
      container.read(useInCallbackCapsule),
      throwsA(isA<AssertionError>()),
    );
    expect(
      container.read(useAfterAwaitCapsule),
      throwsA(isA<AssertionError>()),
    );
  });

  test('use.fooBar() called after async gap throws', () {
    void useInBuildCapsule(CapsuleHandle use) => use.asListener();

    void Function() useInCallbackCapsule(CapsuleHandle use) {
      return () => use.asListener();
    }

    Future<void> useAfterAwaitCapsule(CapsuleHandle use) async {
      await null;
      use.asListener();
    }

    final container = useContainer();
    final _ = container.read(useInBuildCapsule); // should not throw
    expect(
      container.read(useInCallbackCapsule),
      throwsA(isA<AssertionError>()),
    );
    expect(
      container.read(useAfterAwaitCapsule),
      throwsA(isA<AssertionError>()),
    );
  });

  test('containers store capsules completely untyped (issue #36)', () {
    // Re-reading the capsule under a different type should not throw.
    () capsule(CapsuleHandle use) => ();
    useContainer()
      // ignore: unnecessary_cast
      ..read(capsule as Capsule<Object>)
      ..read(capsule);
  });

  test('use() in lists works correctly (spun off of issue #36)', () {
    int intCapsule(CapsuleHandle use) => 0;
    double doubleCapsule(CapsuleHandle use) => 0;
    List<num> upcastedListCapsule1(CapsuleHandle use) =>
        [use(intCapsule), use(doubleCapsule)];
    List<num> upcastedListCapsule2(CapsuleHandle use) =>
        [intCapsule, doubleCapsule].map(use.call).toList();

    final container = useContainer();
    expect(container.read(upcastedListCapsule1), equals([0, 0.0]));
    expect(container.read(upcastedListCapsule2), equals([0, 0.0]));
    expect(container.read(intCapsule), equals(0));
    expect(container.read(doubleCapsule), equals(0.0));
  });

  group('valid/invalid locations to trigger rebuilds', () {
    void Function() rebuildableCapsule(CapsuleHandle use) => use.rebuilder();
    void callsOtherCapsulesRebuildCapsule(CapsuleHandle use) =>
        use(rebuildableCapsule)();
    ValueWrapper<int> rebuildsSelfCapsule(CapsuleHandle use) =>
        use.data(0)..value += 1;

    test("rebuilds may not be triggered in a different capsule's build", () {
      final container = useContainer();
      expect(
        () => container.read(callsOtherCapsulesRebuildCapsule),
        throwsA(isA<AssertionError>()),
      );
    });

    test("rebuilds may be triggered in the same capsule's build", () {
      final container = useContainer();
      expect(container.read(rebuildsSelfCapsule).value, equals(1));
      container.read(rebuildsSelfCapsule).value = 2;
      expect(container.read(rebuildsSelfCapsule).value, equals(3));
    });
  });

  group('warmUp', () {
    test('when capsules are all AsyncData', () async {
      final container = useContainer();
      AsyncValue<int> intCapsule(CapsuleHandle use) => const AsyncData<int>(0);
      await container.warmUp([intCapsule]);
      expect(container.read(intCapsule), equals(const AsyncData(0)));
    });

    test('when capsule resolves to error', () async {
      final container = useContainer();
      Future<int> intAsyncCapsule(CapsuleHandle use) async =>
          throw UnsupportedError('boom');
      AsyncValue<int> intWarmUpCapsule(CapsuleHandle use) =>
          use.future(use(intAsyncCapsule));
      expect(
        container.warmUp([intWarmUpCapsule]),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });

  group('MockCapsuleContainer', () {
    final cap = capsule((use) => 0);

    test('throws when mocking initialized capsule', () {
      expect(
        () => useMockableContainer()
          ..read(cap)
          ..mock(cap).apply((use) => 123),
        throwsA(isA<StateError>()),
      );
    });

    test('throws when mocking already mocked capsule', () {
      expect(
        () => useMockableContainer()
          ..mock(cap).apply((use) => 321)
          ..mock(cap).apply((use) => 123),
        throwsA(isA<StateError>()),
      );
    });

    test('correctly mocks capsules', () {
      final container = useMockableContainer().mock(cap).apply((use) => 123);
      expect(container.read(cap), 123);

      final dependent = capsule((use) => 2 * use(cap));
      expect(container.read(dependent), equals(246));

      final newCap = capsule((use) => use(cap));
      expect(container.mock(newCap).apply((use) => 0).read(newCap), equals(0));
    });
  });
}
