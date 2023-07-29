import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';

void main() => runApp(const MyApp());

/// A factory capsule that returns the input data after a brief delay.
/// This also doubles as an example of a generic capsule.
Future<T> Function(T) delayedEchoFactory<T>(CapsuleHandle _) {
  return (data) => Future.delayed(const Duration(seconds: 1), () => data);
}

/// {@template MyApp}
/// The root of the infinite scroll demo.
/// {@endtemplate}
class MyApp extends StatelessWidget {
  /// {@macro MyApp}
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RearchBootstrapper(
      child: MaterialApp(
        title: 'Infinite Scroll Demo',
        home: Scaffold(
          appBar: AppBar(title: const Text('Infinite Scroll Demo')),
          body: const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Selected items will not be disposed when they are '
                  'scrolled off screen (they are using keep alives)',
                ),
              ),
              Expanded(child: InfiniteList()),
            ],
          ),
        ),
      ),
    );
  }
}

/// {@template InfiniteList}
/// The infinite list of numbers in the application.
/// {@endtemplate}
class InfiniteList extends StatelessWidget {
  /// {@macro InfiniteList}
  const InfiniteList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => InfiniteScrollItem(index: index),
    );
  }
}

/// {@template InfiniteScrollItem}
/// An item in the infinitely scrolling [ListView].
/// {@endtemplate}
class InfiniteScrollItem extends RearchConsumer {
  /// {@macro InfiniteScrollItem}
  const InfiniteScrollItem({required this.index, super.key});

  /// The index of this item.
  final int index;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (keepAlive, setKeepAlive) = use.state(false);
    use.automaticKeepAlive(keepAlive: keepAlive);

    final factory = use(delayedEchoFactory<int>);
    final echoFuture = use.memo(() => factory(index), [factory, index]);
    final echoState = use.future(echoFuture);

    return ListTile(
      selected: keepAlive,
      onTap: () => setKeepAlive(!keepAlive),
      leading: Icon(
        keepAlive
            ? Icons.task_alt_rounded
            : Icons.radio_button_unchecked_rounded,
      ),
      title: switch (echoState) {
        AsyncData(:final data) => Text('$data'),
        AsyncLoading() => const Align(
            alignment: Alignment.centerLeft,
            child: CircularProgressIndicator.adaptive(),
          ),
        AsyncError(:final error) => Text('$error'),
      },
    );
  }
}
