part of '../components.dart';

/// {@template rearch.bootstrapper}
/// Bootstraps rearch for use in Flutter.
///
/// Provides a [CapsuleContainer] to the rest of the [Widget] tree via
/// [CapsuleContainerProvider].
/// {@endtemplate}
class RearchBootstrapper extends StatefulWidget {
  /// {@macro rearch.bootstrapper}
  const RearchBootstrapper({
    required this.child,
    super.key,
  });

  /// The child of this [RearchBootstrapper].
  final Widget child;

  @override
  State<RearchBootstrapper> createState() => _RearchBootstrapperState();
}

class _RearchBootstrapperState extends State<RearchBootstrapper> {
  late final CapsuleContainer container;

  @override
  void initState() {
    super.initState();
    container = CapsuleContainer();
  }

  @override
  void dispose() {
    super.dispose();
    container.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CapsuleContainerProvider(
      container: container,
      child: widget.child,
    );
  }
}
