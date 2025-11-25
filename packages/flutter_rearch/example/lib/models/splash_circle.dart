import 'package:flutter/material.dart';
import 'package:flutter_rearch_example/widgets/animated_splash_circle.dart' show AnimatedSplashCircle;
import 'package:flutter_rearch_example/widgets/dynamic_background.dart' show DynamicBackground;

/// Represents the mathematical properties of an [AnimatedSplashCircle]
/// in a [DynamicBackground].
typedef SplashCircleProperties = ({
  int id,
  double centerX,
  double centerY,
  Color color,
  double radius,
  Duration appear,
  Duration disappear,
});
