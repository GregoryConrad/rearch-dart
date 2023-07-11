part of '../side_effects.dart';

TickerProvider _singleTickerProvider(
  WidgetSideEffectRegistrar use,
) {
  final context = use.context();
  final provider = use.memo(() => _SingleTickerProvider(context));
  use.effect(
    () {
      // During dispose, ensure Ticker was disposed.
      return () {
        assert(
          provider._ticker == null || !provider._ticker!.isActive,
          'A Ticker created with use.singleTickerProvider() was not disposed, '
          'causing the Ticker to leak. You need to call dispose() on the '
          'AnimationController that consumes the Ticker to prevent this leak.',
        );
      };
    },
    [provider],
  );

  provider._ticker?.muted = !TickerMode.of(context);

  return provider;
}

final class _SingleTickerProvider implements TickerProvider {
  _SingleTickerProvider(this.context);

  final BuildContext context;
  Ticker? _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(
      _ticker == null,
      '${context.widget.runtimeType} attempted to create multiple '
      'Tickers with a single use.singleTickerProvider(). '
      'If you need multiple Tickers, call use.singleTickerProvider() '
      'multiple times.',
    );
    return _ticker = Ticker(onTick, debugLabel: 'Created by $context');
  }
}

AnimationController _animationController(
  WidgetSideEffectRegistrar use, {
  Duration? duration,
  Duration? reverseDuration,
  String? debugLabel,
  double initialValue = 0,
  double lowerBound = 0,
  double upperBound = 1,
  TickerProvider? vsync,
  AnimationBehavior animationBehavior = AnimationBehavior.normal,
}) {
  vsync ??= use.singleTickerProvider();

  final controller = use.memo(
    () => AnimationController(
      vsync: vsync!,
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
      lowerBound: lowerBound,
      upperBound: upperBound,
      animationBehavior: animationBehavior,
      value: initialValue,
    ),
  );
  use.effect(() => controller.dispose, [controller]);

  controller
    ..duration = duration
    ..reverseDuration = reverseDuration;

  return controller;
}
