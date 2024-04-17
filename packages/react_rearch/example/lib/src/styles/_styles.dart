part of 'style.dart';

JsonMap syHeightPercent(int percent) => {'height': '$percent%'};

JsonMap syHeightPixels(int pixels) => {'height': '${pixels}px'};

JsonMap get syFullHeight => syHeightPercent(100);

JsonMap syWidthPercent(int percent) => {'width': '$percent%'};

JsonMap syWidthPixels(int pixels) => {'width': '${pixels}px'};

JsonMap get syFullWidth => syWidthPercent(100);

JsonMap get syVerticallyCenter => syVerticallyCenterPercent();

JsonMap syVerticallyCenterPercent([int percent = 50]) => {
      'position': 'relative',
      'top': '$percent%',
      'transform': 'translateY(-50%)',
    };

JsonMap syBgColor(String color) => {'backgroundColor': color};

JsonMap syTextAlign(String align) => {'textAlign': align};

JsonMap get syTextAlignCenter => syTextAlign('center');

// class SyDisplay {
//   static JsonMap get(String display) => {'display': display};
//   static JsonMap get block => get('block');
//   static JsonMap get flex => get('flex');
//   static JsonMap get inline => get('inline');
//   static JsonMap get inlineBlock => get('inline-block');
//   static JsonMap get inlineFlex => get('inline-flex');
// }
