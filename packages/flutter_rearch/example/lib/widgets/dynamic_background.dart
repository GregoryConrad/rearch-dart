import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_rearch_example/widgets/animated_splash_circle.dart';
import 'package:rearch/rearch.dart';

typedef SplashCircleProperties = ({
  int id,
  double centerX,
  double centerY,
  Color color,
  double radius,
  Duration appear,
  Duration disappear,
});

/// {@template DynamicBackground}
/// Displays the bubbly dynamic background effect.
/// {@endtemplate}
class DynamicBackground extends RearchConsumer {
  /// {@macro DynamicBackground}
  const DynamicBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    const color1 = Color(0xFFD223E4);
    const color2 = Color(0xFF0157F5);

    const avgCircleRadius = 0.07;
    final numCirclesToFillScreen = 1 / (pi * pow(avgCircleRadius, 2));
    final goalCircleCount = numCirclesToFillScreen / 2;

    final circles = use.data(<SplashCircleProperties>{});

    final circlesStream = use.memo(() {
      final random = Random();
      return Stream.periodic(const Duration(milliseconds: 50), (i) {
        return (
          id: i,
          centerX: random.nextDouble(),
          centerY: random.nextDouble(),
          color: Color.lerp(
            color1,
            color2,
            random.nextDouble(),
          )!.withValues(alpha: 0.3),
          radius:
              avgCircleRadius + avgCircleRadius * (random.nextDouble() - 0.5),
          appear: Duration(seconds: 2 + (random.nextDouble() * 3).round()),
          disappear: Duration(seconds: 2 + (random.nextDouble() * 3).round()),
        );
      });
    }, [color1, color2, avgCircleRadius]);
    final currCircle = use.stream(circlesStream).data.asNullable();
    if (circles.value.length < goalCircleCount && currCircle != null) {
      circles.value = {...circles.value, currCircle};
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            for (final circle in circles.value)
              Positioned(
                key: ValueKey(circle.id),
                left: (circle.centerX - circle.radius) * constraints.maxWidth,
                top: (circle.centerY - circle.radius) * constraints.maxHeight,
                child: AnimatedSplashCircle(
                  color: circle.color,
                  radius: circle.radius * constraints.maxHeight,
                  appear: circle.appear,
                  disappear: circle.disappear,
                  remove: () => circles.value = circles.value
                      .where((SplashCircleProperties c) => c.id != circle.id)
                      .toSet(),
                ),
              ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: const SizedBox.expand(),
            ),
          ],
        );
      },
    );
  }
}
