import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';

part 'side_effects/animation.dart';
part 'side_effects/keep_alive.dart';
part 'side_effects/text_editing_controller.dart';

extension _UseConvenience on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
}

/// A collection of the builtin [WidgetSideEffect]s.
extension BuiltinWidgetSideEffects on WidgetSideEffectRegistrar {
  /// The [WidgetSideEffectApi] backing this [WidgetSideEffectRegistrar].
  WidgetSideEffectApi api() => register((api) => api);

  /// The [BuildContext] associated with this [WidgetSideEffectRegistrar].
  BuildContext context() => register((api) => api.context);

  /// Provides a way to easily get a copy of a [TextEditingController].
  ///
  /// Pass an optional `initialText` to set the controller's initial text.
  TextEditingController textEditingController({String? initialText}) =>
      _textEditingController(this, initialText: initialText);

  /// Creates a single use [TickerProvider].
  /// Used by [animationController] when `vsync` is not set.
  TickerProvider singleTickerProvider() => _singleTickerProvider(this);

  /// Provides a way to easily get a copy of an [AnimationController].
  ///
  /// When [vsync] is not given, one is created automatically via
  /// [singleTickerProvider].
  /// You *may not* change [vsync] after the first build.
  ///
  /// All other fields are ignored after the first build except for [duration]
  /// and [reverseDuration], whose new values will be updated in the
  /// [AnimationController].
  AnimationController animationController({
    Duration? duration,
    Duration? reverseDuration,
    String? debugLabel,
    double initialValue = 0,
    double lowerBound = 0,
    double upperBound = 1,
    TickerProvider? vsync,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
  }) =>
      _animationController(
        this,
        vsync: vsync,
        duration: duration,
        reverseDuration: reverseDuration,
        debugLabel: debugLabel,
        lowerBound: lowerBound,
        upperBound: upperBound,
        animationBehavior: animationBehavior,
        initialValue: initialValue,
      );

  /// Prevents the associated [RearchConsumer] from being disposed when it
  /// normally would be by its lazy list container (such as in a [ListView]).
  ///
  /// Acts similar to [AutomaticKeepAlive].
  ///
  /// When using [automaticKeepAlive], you *must* use it in a new
  /// [RearchConsumer] that is a child of the container;
  /// otherwise, the widget might still be disposed.
  void automaticKeepAlive({bool keepAlive = true}) =>
      _automaticKeepAlive(this, keepAlive: keepAlive);

  static const _focusOnKeyDeprecationMsg =
      'Use onKeyEvent instead per latest Flutter guidelines. '
      'This will be removed in a non-breaking (minor) future release '
      'that has the Flutter sdk constraint bumped.';

  /// Provides a way to easily get a copy of a [FocusNode].
  FocusNode focusNode({
    String? debugLabel,
    @Deprecated(_focusOnKeyDeprecationMsg) FocusOnKeyCallback? onKey,
    FocusOnKeyEventCallback? onKeyEvent,
    bool skipTraversal = false,
    bool canRequestFocus = true,
    bool descendantsAreFocusable = true,
    bool descendantsAreTraversable = true,
  }) {
    return use.disposable(FocusNode.new, (node) => node.dispose())
      ..debugLabel = debugLabel
      // ignore: deprecated_member_use
      ..onKey = onKey
      ..onKeyEvent = onKeyEvent
      ..skipTraversal = skipTraversal
      ..canRequestFocus = canRequestFocus
      ..descendantsAreFocusable = descendantsAreFocusable
      ..descendantsAreTraversable = descendantsAreTraversable;
  }

  /// Provides a way to easily get a copy of a [FocusScopeNode].
  FocusScopeNode focusScopeNode({
    String? debugLabel,
    @Deprecated(_focusOnKeyDeprecationMsg) FocusOnKeyCallback? onKey,
    FocusOnKeyEventCallback? onKeyEvent,
    bool skipTraversal = false,
    bool canRequestFocus = true,
    TraversalEdgeBehavior traversalEdgeBehavior =
        TraversalEdgeBehavior.closedLoop,
  }) {
    return use.disposable(FocusScopeNode.new, (node) => node.dispose())
      ..debugLabel = debugLabel
      // ignore: deprecated_member_use
      ..onKey = onKey
      ..onKeyEvent = onKeyEvent
      ..skipTraversal = skipTraversal
      ..canRequestFocus = canRequestFocus
      ..traversalEdgeBehavior = traversalEdgeBehavior;
  }

  /// Provides a way to easily get a copy of a [PageController].
  PageController pageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    void Function(ScrollPosition)? onAttach,
    void Function(ScrollPosition)? onDetach,
  }) {
    return use.disposable(
      () => PageController(
        initialPage: initialPage,
        keepPage: keepPage,
        viewportFraction: viewportFraction,
        onAttach: onAttach,
        onDetach: onDetach,
      ),
      (controller) => controller.dispose(),
      [initialPage, keepPage, viewportFraction, onAttach, onDetach],
    );
  }
}
