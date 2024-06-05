## 1.10.1

 - **FIX**: correct use.stream/future cancellation code ([#196](https://github.com/GregoryConrad/rearch-dart/issues/196)).

## 1.10.0+0

 - **DOCS**: update outdated bloc documentation links on README (#190)

## 1.10.0

 - **FEAT**: add `use.disposable` side effect.

## 1.9.0

 - **FEAT**: introduce `container.warmUp` extension method ([#176](https://github.com/GregoryConrad/rearch-dart/issues/176)).

## 1.8.0+1

 - Bump "rearch" to `1.8.0+1`.

## 1.8.0+0

 - docs: update outdated parts of README

## 1.8.0

 - **FEAT**: add use.data and use.lazyData side effects ([#132](https://github.com/GregoryConrad/rearch-dart/issues/132)).

## 1.7.1

 - **FIX**: make lazyStateGetterSetter actually lazy.

## 1.7.0

 - **FEAT**: add experimental MockableContainer.

## 1.6.1

 - **FIX**: update min Flutter/Dart sdk and deprecate old parameters ([#104](https://github.com/GregoryConrad/rearch-dart/issues/104)).

## 1.6.0

 - **FEAT**: add assertion to ensure rebuild isn't called during a build ([#100](https://github.com/GregoryConrad/rearch-dart/issues/100)).

## 1.5.0

 - **FEAT**: stabilize hydrate side effect with nullable parameter ([#66](https://github.com/GregoryConrad/rearch-dart/issues/66)).
 - **FEAT**: add replay state side effect ([#67](https://github.com/GregoryConrad/rearch-dart/issues/67)).

## 1.4.0

 - **FEAT**: add side effect mutations to rebuilds ([#64](https://github.com/GregoryConrad/rearch-dart/issues/64)).
 - **FEAT**: add experimental hydrate side effect ([#62](https://github.com/GregoryConrad/rearch-dart/issues/62)).

## 1.3.4

 - **FIX**: clarify API elements that are not stabilized ([#46](https://github.com/GregoryConrad/rearch-dart/issues/46)).

## 1.3.3

 - **FIX**: remove the generic on _CapsuleManager to allow capsule upcasts ([#39](https://github.com/GregoryConrad/rearch-dart/issues/39)).

## 1.3.2

 - **FIX**: force lazyStateGetterSettter dependents to rebuild on state change ([#34](https://github.com/GregoryConrad/rearch-dart/issues/34)).

## 1.3.1+0

 - Bump "rearch" to `1.3.1+0`.

## 1.3.1

 - **DOCS**: update README and code docs with new info ([#27](https://github.com/GregoryConrad/rearch-dart/issues/27)).

## 1.3.0

 - **FEAT**: handle not used across async gap assertions ([#22](https://github.com/GregoryConrad/rearch-dart/issues/22)).

## 1.2.0

 - **FEAT**: add transactional side effect mutations ([#20](https://github.com/GregoryConrad/rearch-dart/issues/20)).

## 1.1.0

 - **FEAT**: add invalidatableFuture side effect ([#19](https://github.com/GregoryConrad/rearch-dart/issues/19)).

## 1.0.3

 - **PERF**: remove several rebuild-related list creations.

## 1.0.2

 - **FIX**: prevent capsule init after disposal in onNextUpdate.

## 1.0.1

 - **FIX**: add gc in onNextUpdate to prevent possible leak ([#10](https://github.com/GregoryConrad/rearch-dart/issues/10)).

## 1.0.0+0

 - Bump "rearch" to `1.0.0+0`.

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-dev.1

 - **FEAT**: add improvements for listeners.

## 1.0.0-dev.0

 - **FEAT**: add refreshableFuture side effect.

## 0.0.0-dev.8

 - **FIX**: add proper handling for capsule self reads.
 - **FEAT**: add isFirstBuild side effect.

## 0.0.0-dev.7

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: add Capsule.map and remove ListenerHandle.

## 0.0.0-dev.6

 - **DOCS**: update terminology.

## 0.0.0-dev.5

 - **PERF**: add state effect == optimization.
 - **FEAT**: add state side effects for closure capture.

## 0.0.0-dev.4

 - **REFACTOR**: move rearch impl to new file.
 - **FIX**: flutter bug fixes and prototype todo list example app.

## 0.0.0-dev.3

 - **FEAT**: add remaining side effects.

## 0.0.0-dev.2

 - **FIX**: listener handle will not recreate manager on dispose.
 - **FEAT**: initial impl of flutter_rearch.

## 0.0.0-dev.1

 - **FEAT**: add == check to skip some rebuilds.
 - **FEAT**: working mvp.

