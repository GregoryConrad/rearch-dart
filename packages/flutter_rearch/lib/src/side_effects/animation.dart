part of '../side_effects.dart';

TickerProvider _singleTickerProvider(
  WidgetSideEffectRegistrar use,
) {
  final context = use.context();
  final provider = use.memo(() => _SingleTickerProvider(context));
  use.effect(
    () {
      // *After* dispose, ensure Ticker was disposed.
      // The animation controller itself may be disposed after the ticker,
      // so we must insert a gap into the event loop to check if the ticker
      // was actually disposed a little bit later.
      return () {
        // NOTE: this assert is a workaround to run code only in debug mode
        // ignore: prefer_asserts_with_message
        assert(
          () {
            () async {
              await null;
              assert(
                provider._ticker == null || !provider._ticker!.isActive,
                'A Ticker created with use.singleTickerProvider() was not '
                'disposed, causing the Ticker to leak. '
                'You need to call dispose() on the AnimationController that '
                'consumes the Ticker to prevent this leak.',
              );
            }();
            return true;
          }(),
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

  return use.disposable(
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
      (controller) => controller.dispose(),
    )
    ..duration = duration
    ..reverseDuration = reverseDuration;
}
