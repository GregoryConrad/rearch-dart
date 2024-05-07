# ramen

> This page is under major construction.
> What is here will hopefully be enough to get you started for now.
> Please see the pub.dev API reference for more info.

> Note: you can specify your UI with Ramen's API for now,
> but you cannot actually build it onto the screen.
> I am currently working on the underlying algorithms and ReArch integration.

Ramen is an _experimental_ web UI framework built upon [ReArch]
that enables you to _declaratively_ and _functionally_ build your entire UI.
Because Ramen is built on top of ReArch (which is an incremental computation framework),
you get a load of features and optimizations for free.

Your typical view that can have a child will look something like:

```dart
@view
IntermediateView myView() => view()
    .nest(Padding.all(16))
    .nest(ColoredBox(color: 0x112233));
```

On the contrary, a view can be terminated (no further child is allowed):
```dart
TerminatedView myTextView() => view()
    .terminate(Text('Hello World!'));
```

Not many views (including `Padding`, `ColoredBox`, and `Text` above)
have actually been implemented yet.
Fear not! It is really easy to make one yourself:

```dart
view()
  .node(MyHtmlNode()) // you can add any HTML node you want!
  .terminateWithNode(TextNode('hello world')) // for terminal HTML nodes, like text nodes
```

In addition to the `ViewHandle` (that acts similarly to the `CapsuleHandle` in ReArch),
views can also consume a `BuildContext` that allows views to access _injected_ data.
Think InheritedWidget from Flutter, but way easier and more powerful.
I don't have time to write more out about this now, but see `view.inject()`.

[ReArch]: https://github.com/gregoryconrad/rearch-dart/
