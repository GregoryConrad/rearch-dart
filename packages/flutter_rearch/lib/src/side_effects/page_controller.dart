part of '../side_effects.dart';

PageController _pageController(
  WidgetSideEffectRegistrar use, {
  int initialPage = 0,
  bool keepPage = true,
  double viewportFraction = 1.0,
  void Function(ScrollPosition)? onAttach,
  void Function(ScrollPosition)? onDetach,
}) {
  final controller = use.memo(
    () => PageController(
      initialPage: initialPage,
      keepPage: keepPage,
      viewportFraction: viewportFraction,
      onAttach: onAttach,
      onDetach: onDetach,
    ),
  );
  use.effect(() => controller.dispose, [controller]);

  return controller;
}
