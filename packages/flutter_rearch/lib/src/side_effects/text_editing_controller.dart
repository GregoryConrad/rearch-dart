part of '../side_effects.dart';

TextEditingController _textEditingController(
  WidgetSideEffectRegistrar use, {
  String? initialText,
}) {
  return use.disposable(
    () => TextEditingController(text: initialText),
    (controller) => controller.dispose(),
  );
}
