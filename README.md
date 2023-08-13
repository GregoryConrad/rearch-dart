<p align="center">
<a href="https://github.com/GregoryConrad/rearch-dart/actions"><img src="https://github.com/GregoryConrad/rearch-dart/actions/workflows/test.yml/badge.svg" alt="CI Status"></a>
<a href="https://github.com/GregoryConrad/rearch-dart"><img src="https://img.shields.io/github/stars/GregoryConrad/rearch-dart.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Github Stars"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License"></a>
</p>

<p align="center">
<img src="https://github.com/GregoryConrad/rearch-docs/blob/main/assets/banner.jpg?raw=true" width="75%" alt="Banner" />
</p>

<p align="center">
rearch = re-imagined approach to application design and architecture
</p>

---


## Features
Specifically, rearch is a:
- ⚡️ Reactive
- 🔍 Testable
- 🧱 Composable
- 🔌 Extendable
- ⬆️ Scalable
- 🧮 Functional
- 🪢 Databinding 
- 💉 Dependency Injection

Framework.

That's a mouthful! But in short, rearch is an entirely new approach to building applications.


## In a Nutshell
Define your "capsules" (en-_capsulated_ pieces of data) at the top level:
```dart
// Capsules are simply functions that consume a CapsuleHandle.
// The CapsuleHandle lets you get the data of other capsules,
// in addition to using a large variety of side effects.

// This particular capsule manages a count from a classic example counter app,
// using the state side effect.
(int, void Function()) countManager(CapsuleHandle use) {
  final (count, setCount) = use.state(0);
  return (count, () => setCount(count + 1));
}

// This capsule provides the current count, plus one.
int countPlusOneCapsule(CapsuleHandle use) => use(countManager).$1 + 1;
```

And then, if you are using Flutter, define some widgets:
```dart
// Widgets are just like a special kind of capsule!
// Instead of a CapsuleHandle, they consume a WidgetHandle.
// They also live at the top level.
@rearchWidget
Widget counterAppBody(BuildContext context, WidgetHandle use) {
  final (count, incrementCount) = use(countManager);
  final countPlusOne = use(countPlusOneCapsule);
  return Scaffold(
    appBar: AppBar(title: Text('Rearch Demo')),
    floatingActionButton: FloatingActionButton(
      onPressed: incrementCount,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    ),
    body: Center(
      child: Text(
        '$count + 1 = $countPlusOne',
        style: TextTheme.of(context).headlineLarge,
      ),
    ),
  );
}
```

*Note: the `@rearchWidget` above requires
[static metaprogramming](https://github.com/dart-lang/language/issues/1482),
which has not yet been released.
In the meantime, there is a custom widget, `RearchConsumer`, which you can extend.*


## Getting Started
### With Flutter
Simply run:
`flutter pub add rearch flutter_rearch`

And (*this part is important*), wrap your application widget
with a `RearchBootstrapper` widget in your `main.dart`:
```dart
void main() {
  runApp(RearchBootstrapper(
    child: MaterialApp(...),
  ));
}
```

### Dart Only
Simply run:
`dart pub add rearch`

And then just create one container for your application:
```dart
void main() {
  final container = CapsuleContainer();
  // Use the container.
}
```

### Documentation
Now go take a look at [documentation]!


## Why Rearch?
Rearch is different than other state management frameworks because it acts upon
two key observations:
1. UI is a function of state and side effect(s).
2. State is a function of other state and side effect(s).

Accordingly, rearch allows you to *simply* define functions of state + side effects
for creating both state and UI,
and in doing so allows you to create applications of great scale.
Also because of this insight, I'd argue that rearch is
*the most testable approach to building applications today*.
With rearch, all of your capsule/widget code will be pure functions
(despite having arbitrary side effects!),
and you will *never need complicated mocks*.

> Rearch is the subject of my master's thesis;
check back here later for a link to the final write up
if you want to learn about the theory behind rearch.

Further, rearch has an *extremely powerful* side effects system, and that is not an understatement.
You will *never* have to wait on a new feature; you can just create a side effect!
Side effects enable you to have extremely high code reuse between your state and widget logic,
and allow you to think in the same manner for both.

Worth mentioning here, rearch's persistence side effect also provides the (arguably) best
mechanism to cache/persist state *out of any Flutter state management framework*.
Don't believe me? Take a peak at the examples in the [documentation].

But back on track here: if the reasons listed above are not enough for you,
then here are some more reasons, based on some other popular solutions.

### Why not Provider?
It's maintenance-only and has fundamental problems; Riverpod is its successor.

### Why not Riverpod?
I actually created rearch after being mostly _happy_ with Riverpod.
The core principles behind Riverpod are incredbily smart, and I never would have thought of rearch without them.

However, it can be argued that Riverpod has some design problems, in addition to some other grievances:
- All the different provider types are not easy for beginners to grasp.
Code generation has helped in this regard, but there are still many different types behind the scenes,
and users will still have to learn about them at some point when using Riverpod.
Further, new users often do not know when to choose a function or a class when using `@riverpod`.
- Family and AutoDispose providers have design problems (more on this later),
and consequently can set you up for bad practices/easy misuse.
- Notifier classes are not all that clear for beginners.
They contain many intricacies and odd fields like `future` and `stream` that are not declarative.
- No _easy_ way to scope state to a particular Widget.
- Some pretty crucial features like offline persistence and watching mutations have taken *years* to get implemented.
That is not Remi's fault though; he is a very busy guy and he can only do so much.
Perhaps, though, if there wasn't a need to modify the core components to add new functionality,
then users would never need to wait on said changes and could extend the library themselves.
- The advanced features are inherently complex and hard to grasp.
In addition, most will have to use them at some point when developing an app with some level of sophistication.
- The `dependencies` parameter. I have seen quite a few beginners stumble across it and get confused.
You shouldn't need to specify dependencies for scoped providers
when you already do a `ref.watch` in the provider; that is just redundant and error-prone.

You will notice a lot of carry over from Riverpod when using rearch
(because I cherry-picked many of the ideas I liked),
but there are a notable few things missing (on purpose):
Family and AutoDispose providers.
While working on the initial version of rearch for quite some time, and going through many design revisions,
I realized how these two core parts of Riverpod are actually *flawed*, to an extent.
While they work at the surface level for some users,
the ideas backing Family/AutoDispose promote bad practices (keep reading!).

#### What's wrong with `family`?
> TL;DR: rearch embraces the factory pattern, which solves all the issues with `family`.

Families have two problems:
1. Families are globally-scoped, which does not make sense from a design perspective for the cases they are intended to solve.
2. They rely on AutoDispose to not cause leaks, and AutoDispose itself has problems (see the next section).

To best explain that first point, think for a second: where are family providers used?
There are two possible answers:
1. The provider is used locally.
In this case, why are you promoting local state to global state, which is where family providers live?
It should be kept local, just like a mutable variable.
As many know, keeping local state at the top level is a bad practice.
2. The provider is used globally.
In this case, you would need to store the family arguments(s) in one provider,
and then use the family provider to turn those arguments into a new provider accessible globally.
While family *does* work for this use case, it also doesn't quite make sense.
To prevent leaks, you must also tack on AutoDispose.
Further, the framework must deal with the complexity of caching the different in-use versions of the family,
which then forces the parameters to override `hashCode` and `==`.
That is a lot of effort for something that could be done simply with the factory pattern and no additional overhead!

For some quick context, factories are a way to create an object on demand based on some dynamic arguments,
such as those provided by a user or some external mechanism.
Factories allow you to create an object for however long you need it, and gracefully handle its state and disposal.

For that reason, rearch exposes a way to make working with the factory pattern easier;
see the [documentation] for more.

#### What's wrong with `autoDispose`?
> TL;DR: rearch is smart enough to know which capsules it can dispose automatically. (Cool, right?)

AutoDispose, in my opinion, is a broken concept.
When you have to rely on hacks like a timer to keep something from being disposed (`disposeDelay`)
when navigating around an app, it should be clear that something is wrong in the implementation and/or idea.
Plus, in a mobile application, you either have global state or disposable local state.
If you need some state to automatically dispose, chances are you actually need ephemeral state.
> In cases where a global cache is exceedingly large for some reason (like for app-wide image(s)/video(s)),
I'd argue clearing that cache should often be taken care of on a case-per-case basis due to differing application requirements.

Consequently, AutoDispose has all sorts of parameters and traces of it scattered throughout the core framework
to accomodate one-off situations, all in addition to a barrage of types to support the different combinations
(i.e., `AutoDisposeAsyncNotifierProviderElement`, `AutoDisposeAsyncNotifierProviderFamily`,
`AutoDispose...`, [etc.](https://pub.dev/documentation/riverpod/latest/riverpod/riverpod-library.html)).

Instead of AutoDispose, rearch:
- Introduces the novel concept of _idempotent_ capsules when dealing with global state.
  - You don't need to know anything about idempotent capsules when using rearch;
they are identified internally and are automatically cleaned up for you!
- Embraces the use of factories and side effects for ephemeral state.

### Why not Hooks?
I actually love `flutter_hooks`! Just a few grievances:
- Hooks only work from within *widgets*
- Hooks are only effective at handling *ephemeral* state
- Not as testable as rearch, since rearch uses DI (yes, mocks are possible, but rearch is still easier to test)

Hooks are akin to rearch's side effects; in fact, some work very similar to or exactly the same across the libraries.

### Why not Bloc?

> BLoC = Boilerplate + Lots of Code.

Bloc was my first state management solution, and I quickly outgrew it in favor of using `get_it` and Rx.
In my opinion, Bloc is far too much boilerplate for too little gain.
In fact, the crux of the Bloc architecture is simply replicable in the `useReducer` hook
from `flutter_hooks` with way less development overhead!

The Bloc pattern is also easy to replicate in rearch with `use.reducer`,
and rearch results in _far more_ declarative and concise code.

An aside: the earlier days of Bloc exposed Stream transformers with `async *` functions.
I did think the use of `Stream`s was an interesting way to represent state over time,
but the implementation itself was still far too verbose.

### Why not `get_it`?
There is a bit of overhead in having to set up dependency injection with pre-Dart 3 packages like `get_it`
(which is actually, technically speaking, a "service locater").
Coming from `get_it`, you should welcome rearch,
since all dependency injection is done for you automatically with zero boilerplate!
Further, rearch is a _reactive_ dependency injection framework; `get_it` lacks reactivity.
But, if you don't want the reactivity; no problem!
You don't have to use it, but it is there in case you do.

### Why not Rx and Streams?
I was a decent fan of using Rx and streams for state management and used to do so myself.

However, there are a few main issues with Rx and streams:
1. Streams are great at being streams; they are terrible at managing state.
This has multiple reasons, but a big one is because streams cannot *correctly* support side effects
(which is a fundamental limitation--there is no dependency graph when composing streams).
2. ["Streams were not designed for Flutter apps."](https://twitter.com/remi_rousselet/status/1294273161580752898?lang=en)
3. It is _very_ easy to mess up when using streams and cause a leak.
(Some say it requires a PhD to properly understand how to work with streams!)
4. Streams require a bit of syntactic and thought overhead,
in addition to requiring a DI/service locator tool to access them.

### Why not GetX?
Your code will look like 🍝.


## Credit
Giving credit where credit is due:
I got the original idea for rearch (although, it was much different back then!)
after using `riverpod`, `flutter_hooks`, and `functional_widget`.
Rearch would not have been possible if not for these stellar, role-model projects.
Rearch took *dozens* (not an exaggeration) of design overhauls to arrive at where it is today,
incorporating many ideas from these 3 pacakges along the way.


## Help Wanted!
As much as I have done with rearch, it always seems like there is more to do.
One person can only do so much!

If you would like to sponsor me to continue my work, thank you!
Sponsorship information should be up soon.

Or, if you would like to contribute, here are some areas where I would really appreciate help!
- Documentation (especially inline!)
  - If you could add code samples/improve clarity, that would be greatly appreciated.
- Adding extension methods to `AsyncValue` and `Option` are easy "first issues"
  - See the respective source files for more on contributing there.
- New (platform-agnostic) side effects!
  - I've made many as I've needed them, but it'd be great to have more.
  - If you find yourself using a custom side effect over and over, consider making a PR!
Chances are other developers can use it too.

[documentation]: https://rearch.gsconrad.com
