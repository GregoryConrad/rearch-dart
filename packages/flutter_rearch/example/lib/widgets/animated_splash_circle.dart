import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_rearch_example/widgets/dynamic_background.dart' show DynamicBackground;
import 'package:rearch/rearch.dart';

/// {@template AnimatedSplashCircle}
/// An individual animated circle in the [DynamicBackground].
/// {@endtemplate}
class AnimatedSplashCircle extends RearchConsumer {
  /// {@macro AnimatedSplashCircle}
  const AnimatedSplashCircle({
    required this.color,
    required this.radius,
    required this.appear,
    required this.disappear,
    required this.remove,
    super.key,
  });

  /// The color of this circle.
  final Color color;

  /// The radius of this circle.
  final double radius;

  /// The time it takes for the circle to fully appear.
  final Duration appear;

  /// The time it takes for the circle to fully disappear.
  final Duration disappear;

  /// A callback that removes this circle from the [DynamicBackground]
  /// for when its animations complete.
  final void Function() remove;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final controller = use.animationController(
      duration: appear,
      reverseDuration: disappear,
    );
    use.effect(
      () {
        controller.forward();
        return null;
      },
      [controller],
    );

    final animation = use.memo(
      () {
        return CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOutQuint,
          reverseCurve: Curves.linear,
        );
      },
      [controller],
    );
    use.effect(
      () {
        void statusListener(AnimationStatus status) {
          switch (status) {
            case AnimationStatus.completed:
              controller.reverse();
            case AnimationStatus.dismissed:
              remove();
            case _:
              break;
          }
        }

        animation.addStatusListener(statusListener);
        return animation.dispose;
      },
      [controller, remove, animation],
    );

    return ScaleTransition(
      scale: animation,
      child: CircleAvatar(
        backgroundColor: color,
        radius: radius,
      ),
    );
  }
}
