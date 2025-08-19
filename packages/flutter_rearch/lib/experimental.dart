/// A collection of ReArch experiments in case you like exploring the unknown.
///
/// Nothing here is officially supported;
/// items may come and go or experience breaking changes on any new release.
/// Further, items here may be untested so use at your own risk!
@experimental
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:meta/meta.dart';

/// {@template rearch.rearchInjection}
/// Injects some state to descendants in the Widget tree.
///
/// Here's a simple example of injecting some [int] state into the widget tree:
/// ```dart
/// class MyInjection extends RearchInjection<MyInjection, ValueWrapper<int>> {
///   const MyInjection({required super.child, super.key});
///
///   @override
///   ValueWrapper<int> build(BuildContext context, WidgetHandle use) {
///     return use.data(0);
///   }
///
///   static ValueWrapper<int> of(BuildContext context) =>
///       RearchInjection.of<MyInjection, ValueWrapper<int>>(context);
///
///   static ValueWrapper<int>? maybeOf(BuildContext context) =>
///       RearchInjection.maybeOf<MyInjection, ValueWrapper<int>>(context);
/// }
/// ```
///
/// You can think of a [RearchInjection] as a
/// [RearchConsumer] wrapped around an [InheritedWidget]
/// (as that is exactly how it is implemented),
/// but with minimal boilerplate.
///
/// # WARNING
/// This class is experimental since I am not yet 100% sold on the API.
/// It's a little too verbose still for my tastes
/// (and unfortunately, the development of macros was halted).
/// {@endtemplate}
@experimental
abstract class RearchInjection<W extends RearchInjection<W, Data>, Data>
    extends Widget {
  /// {@macro rearch.rearchInjection}
  const RearchInjection({required this.child, super.key});

  /// The widget below this widget in the tree.
  ///
  /// This is eventually passed onto the underlying [InheritedWidget.child].
  final Widget child;

  /// Creates the data to pass down the widget tree below the [RearchInjection].
  ///
  /// This acts exactly the same as [RearchConsumer.build],
  /// but instead of creating a new widget,
  /// you are creating some data/state to inject into the widget tree
  /// (internally using an [InheritedWidget].
  Data build(BuildContext context, WidgetHandle use);

  @override
  Element createElement() => _RearchInjectionElement<W, Data>(this);

  /// The state from the closest instance of the provided [RearchInjection]
  /// that encloses the given context.
  ///
  /// You will normally use this function to implement an `of` function
  /// in your derived classes.
  ///
  /// Will `throw` if the provided [RearchInjection] is not found
  /// in the given context.
  ///
  /// See also:
  ///  - [maybeOf], which is a similar function, except that it will
  ///    return `null` if the provided [RearchInjection] is not found
  ///    in the given context.
  static T of<Injection extends RearchInjection<Injection, T>, T>(
    BuildContext context,
  ) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<
          _RearchInjectionInheritedWidget<Injection, T>
        >();
    assert(widget != null, 'No $Injection in the widget tree above context!');
    return widget!.data;
  }

  /// The state from the closest instance of the provided [RearchInjection]
  /// that encloses the given context, if any.
  ///
  /// You will normally use this function to implement a `maybeOf` function
  /// in your derived classes.
  ///
  /// Will return `null` if the provided [RearchInjection] is not found
  /// in the given context.
  ///
  /// See also:
  ///  - [of], which is a similar function, except that it will `throw`
  ///    if the provided [RearchInjection] is not found in the given context.
  static T? maybeOf<Injection extends RearchInjection<Injection, T>, T>(
    BuildContext context,
  ) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<
          _RearchInjectionInheritedWidget<Injection, T>
        >();
    return widget?.data;
  }
}

class _RearchInjectionElement<W extends RearchInjection<W, Data>, Data>
    extends ComponentElement {
  _RearchInjectionElement(super.widget);

  @override
  Widget build() {
    final widget = this.widget as W;
    return RearchBuilder(
      builder: (ctx, use) {
        final data = widget.build(ctx, use);
        return _RearchInjectionInheritedWidget<W, Data>(
          data,
          child: widget.child,
        );
      },
    );
  }

  @override
  void update(W newWidget) {
    super.update(newWidget);
    rebuild(force: true);
  }
}

class _RearchInjectionInheritedWidget<W extends RearchInjection<W, Data>, Data>
    extends InheritedWidget {
  const _RearchInjectionInheritedWidget(this.data, {required super.child});

  final Data data;

  @override
  bool updateShouldNotify(
    covariant _RearchInjectionInheritedWidget<W, Data> oldWidget,
  ) => oldWidget.data != data;
}
