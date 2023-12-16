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

