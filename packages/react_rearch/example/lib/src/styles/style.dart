import 'package:react_rearch_example/lib.dart';

part '_styles.dart';

class Style {
  Style(
    this.styles, {
    this.size,
    this.display,
    this.alignment,
    this.color,
  }) {
    _check();
  }

  final JsonMap styles;
  final SySize? size;
  final SyDisplay? display;
  final SyAlignment? alignment;
  final SyColor? color;

  Map<String, dynamic> get value => {
        'style': {
          // Custom
          ...styles,

          // Main
          ...?size?.value,
          ...?display?.value,
          ...?alignment?.value,
          ...?color?.value,
        },
      };

  void _check() {
    _checkSubStyle(size);
    _checkSubStyle(display);
    _checkSubStyle(alignment);
    _checkSubStyle(color);
  }

  void _checkSubStyle(SubStyle? subStyle) {
    if (subStyle == null) return;
    final error = subStyle.check();
    if (error != null) _error('${subStyle.name}: $error');
  }

  // ignore: only_throw_errors
  void _error(String msg) => throw 'Style: $msg';
}

abstract class SubStyle {
  SubStyle();

  String get name;

  Map<String, dynamic> get value;

  String? check();
}

class SySize extends SubStyle {
  SySize({
    this.fullHeight = false,
    this.heightPercent,
    this.heightPixels,
    this.fullWidth = false,
    this.widthPercent,
    this.widthPixels,
  });

  final bool fullWidth;
  final int? widthPercent;
  final int? widthPixels;
  final bool fullHeight;
  final int? heightPercent;
  final int? heightPixels;

  @override
  String get name => 'Size';

  @override
  Map<String, dynamic> get value => {
        ..._width,
        ..._height,
      };

  @override
  String? check() {
    // Width
    {
      var count = 0;
      if (fullWidth) count++;
      if (widthPercent != null) count++;
      if (widthPixels != null) count++;
      if (count > 1) return 'Only one width can be set -- Count: $count';
    }

    // Height
    {
      var count = 0;
      if (fullHeight) count++;
      if (heightPercent != null) count++;
      if (heightPixels != null) count++;
      if (count > 1) return 'Only one height can be set -- Count: $count';
    }

    return null;
  }

  JsonMap get _width => {
        if (fullWidth) ...syFullWidth,
        if (widthPercent != null) ...syWidthPercent(widthPercent!),
        if (widthPixels != null) ...syWidthPixels(widthPixels!),
      };

  JsonMap get _height => {
        if (fullHeight) ...syFullHeight,
        if (heightPercent != null) ...syHeightPercent(heightPercent!),
        if (heightPixels != null) ...syHeightPixels(heightPixels!),
      };
}

class SyDisplay extends SubStyle {
  SyDisplay({
    this.displayBlock = false,
    this.displayFlex = false,
    this.displayInline = false,
    this.displayInlineBlock = false,
    this.displayInlineFlex = false,
  });

  final bool displayBlock;
  final bool displayFlex;
  final bool displayInline;
  final bool displayInlineBlock;
  final bool displayInlineFlex;

  @override
  String get name => 'Display';

  @override
  Map<String, dynamic> get value => {
        if (displayBlock) ...block,
        if (displayFlex) ...flex,
        if (displayInline) ...inline,
        if (displayInlineBlock) ...inlineBlock,
        if (displayInlineFlex) ...inlineFlex,
      };

  @override
  String? check() {
    var count = 0;
    if (displayBlock) count++;
    if (displayFlex) count++;
    if (displayInline) count++;
    if (displayInlineBlock) count++;
    if (displayInlineFlex) count++;
    if (count > 1) return 'Only one display can be set -- Count: $count';

    return null;
  }

  static JsonMap get(String display) => {'display': display};
  static JsonMap get block => get('block');
  static JsonMap get flex => get('flex');
  static JsonMap get inline => get('inline');
  static JsonMap get inlineBlock => get('inline-block');
  static JsonMap get inlineFlex => get('inline-flex');
}

class SyAlignment extends SubStyle {
  SyAlignment({
    this.verticallyCenter = false,
    this.centerText = false,
  });

  final bool verticallyCenter;
  final bool centerText;

  @override
  String get name => 'Alignment';

  @override
  Map<String, dynamic> get value => {
        if (verticallyCenter) ...syVerticallyCenter,
        if (centerText) ...syTextAlignCenter,
      };

  @override
  String? check() {
    return null;
  }
}

class SyColor extends SubStyle {
  SyColor({
    this.text,
    this.background,
  });

  final String? text;
  final String? background;

  @override
  String get name => 'Color';

  @override
  Map<String, dynamic> get value => {
        if (text != null) 'color': text,
        if (background != null) 'backgroundColor': background,
      };

  @override
  String? check() {
    return null;
  }
}
