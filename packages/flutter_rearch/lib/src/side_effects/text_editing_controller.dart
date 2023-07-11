part of '../side_effects.dart';

TextEditingController _textEditingController(
  WidgetSideEffectRegistrar use, {
  String? initialText,
}) {
  final controller = use.memo(() => TextEditingController(text: initialText));
  use.effect(() => controller.dispose, [controller]);
  return controller;
}
