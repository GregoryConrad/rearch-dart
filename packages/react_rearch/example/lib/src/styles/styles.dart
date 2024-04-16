import 'package:react_rearch_example/lib.dart';

///.
JsonMap get styleVerticallyCenter => getStyleVerticallyCenter();

///.
JsonMap getStyleVerticallyCenter([int percent = 50]) => {
      'position': 'relative',
      'top': '$percent%',
      'transform': 'translateY(-50%)',
    };
