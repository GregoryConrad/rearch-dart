## 1.7.2

 - **FIX**: ensure widget is mounted before marking dirty ([#305](https://github.com/GregoryConrad/rearch-dart/issues/305)).

## 1.7.1

 - Update a dependency to the latest release.

## 1.7.0

 - **FEAT**: add experimental `RearchInjection` widget for scoped state ([#267](https://github.com/GregoryConrad/rearch-dart/issues/267)).

## 1.6.14+0

 - Bump "flutter_rearch" to `1.6.14+0`.

## 1.6.14

 - Update a dependency to the latest release.

## 1.6.13

 - **REFACTOR**: migrate widget side effects over to `use.disposable` ([#235](https://github.com/GregoryConrad/rearch-dart/issues/235)).

## 1.6.12

 - Update a dependency to the latest release.

## 1.6.11

 - Update a dependency to the latest release.

## 1.6.10

 - Update a dependency to the latest release.

## 1.6.9

 - Update a dependency to the latest release.

## 1.6.8

 - **FIX**: add workaround for flutter hot reload bug ([#210](https://github.com/GregoryConrad/rearch-dart/issues/210)).

## 1.6.7

 - **FIX**: remove erroneous markNeedsBuild call in use.automaticKeepAlive ([#200](https://github.com/GregoryConrad/rearch-dart/issues/200)).

## 1.6.6

 - **FIX**: correct use.stream/future cancellation code ([#196](https://github.com/GregoryConrad/rearch-dart/issues/196)).

## 1.6.5+0

 - **DOCS**: update outdated bloc documentation links on README (#190)

## 1.6.5

 - **FIX**: add warning for previously silent but faulty `use()`s ([#188](https://github.com/GregoryConrad/rearch-dart/issues/188)).

## 1.6.4

 - **FIX**: dispose FocusNodes created via side effects.

## 1.6.3

 - Update a dependency to the latest release.

## 1.6.2

 - **FIX**: prevent premature idempotent capsule disposal ([#173](https://github.com/GregoryConrad/rearch-dart/issues/173)).

## 1.6.1

 - **FIX**: rebuild RearchElement when its widget updates ([#164](https://github.com/GregoryConrad/rearch-dart/issues/164)).

## 1.6.0+0

 - docs: update outdated parts of README

## 1.6.0

 - **FEAT**: add use.data and use.lazyData side effects ([#132](https://github.com/GregoryConrad/rearch-dart/issues/132)).

## 1.5.2

 - Update a dependency to the latest release.

## 1.5.1

 - Update a dependency to the latest release.

## 1.5.0

 - **FEAT**: add PageController side effect ([#111](https://github.com/GregoryConrad/rearch-dart/issues/111)).

## 1.4.2

 - **FIX**: update min Flutter/Dart sdk and deprecate old parameters ([#104](https://github.com/GregoryConrad/rearch-dart/issues/104)).

## 1.4.1

 - Update a dependency to the latest release.

## 1.4.0

 - **FEAT**: add FocusNode related widget side effects ([#80](https://github.com/GregoryConrad/rearch-dart/issues/80)).

## 1.3.2

 - Update a dependency to the latest release.

## 1.3.1

 - **FIX**: ensure ticker disposal after all other disposes.
 - **FIX**: rework todos application circle animations.

## 1.3.0

 - **FEAT**: add side effect mutations to rebuilds ([#64](https://github.com/GregoryConrad/rearch-dart/issues/64)).

## 1.2.4

 - **FIX**: clarify API elements that are not stabilized ([#46](https://github.com/GregoryConrad/rearch-dart/issues/46)).

## 1.2.3

 - Update a dependency to the latest release.

## 1.2.2

 - Update a dependency to the latest release.

## 1.2.1+0

## 1.2.1

 - Update a dependency to the latest release.

## 1.2.0

 - **FEAT**: handle not used across async gap assertions ([#22](https://github.com/GregoryConrad/rearch-dart/issues/22)).

## 1.1.0

 - **FEAT**: add transactional side effect mutations ([#20](https://github.com/GregoryConrad/rearch-dart/issues/20)).

## 1.0.4

 - Update a dependency to the latest release.

## 1.0.3

 - Update a dependency to the latest release.

## 1.0.2

 - Update a dependency to the latest release.

## 1.0.1

 - Update a dependency to the latest release.

## 1.0.0+0

 - Bump "flutter_rearch" to `1.0.0+0`.

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-dev.1

 - Update a dependency to the latest release.

## 1.0.0-dev.0

 - Bump "flutter_rearch" to `1.0.0-dev.0`.

## 0.0.0-dev.8

 - **DOCS**: add count warm up example ([#2](https://github.com/GregoryConrad/rearch-dart/issues/2)).

## 0.0.0-dev.7

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: add Capsule.map and remove ListenerHandle.

## 0.0.0-dev.6

 - Update a dependency to the latest release.

## 0.0.0-dev.5

> Note: This release has breaking changes.

 - **FEAT**: add state side effects for closure capture.
 - **FEAT**: made todo example app more sophisticated.
 - **DOCS**: finish the todo example app.
 - **BREAKING** **REFACTOR**: rename CapsuleConsumer to RearchConsumer.

## 0.0.0-dev.4

 - **FIX**: flutter bug fixes and prototype todo list example app.
 - **FEAT**: allow type inference in capsule warm up.

## 0.0.0-dev.3

 - Update a dependency to the latest release.

## 0.0.0-dev.2

 - **FEAT**: initial impl of flutter_rearch.
 - **FEAT**: working mvp.

