part of '../widgets.dart';

/// Provides a [CapsuleContainer] to the rest of the [Widget] tree
/// using an [InheritedWidget].
///
/// Does not manage the lifecycle of the supplied [CapsuleContainer].
/// You typically should use [RearchBootstrapper] instead.
class CapsuleContainerProvider extends InheritedWidget {
  /// Constructs a [CapsuleContainerProvider] with the supplied
  /// [container] and [child].
  const CapsuleContainerProvider({
    required this.container,
    required super.child,
    super.key,
  });

  /// The [CapsuleContainer] this [CapsuleContainerProvider] is providing
  /// to the rest of the [Widget] tree.
  final CapsuleContainer container;

  @override
  bool updateShouldNotify(CapsuleContainerProvider oldWidget) {
    return container != oldWidget.container;
  }

  /// Retrieves the [CapsuleContainer] of the given [context],
  /// based on an ancestor [CapsuleContainerProvider].
  /// If there is no ancestor [CapsuleContainerProvider], throws an error.
  static CapsuleContainer containerOf(BuildContext context) {
    final container = context
        .dependOnInheritedWidgetOfExactType<CapsuleContainerProvider>()
        ?.container;

    assert(
      container != null,
      'No CapsuleContainerProvider found in the widget tree!\n'
      'Did you forget to add RearchBootstrapper directly to runApp()?',
    );

    return container!;
  }
}
