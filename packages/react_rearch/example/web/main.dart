import 'dart:html';

import 'package:react/react_dom.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

void main() {
  // ignore: avoid_print
  print('MAIN');

  // ignore: avoid_dynamic_calls
  render(
    // rearchBootstrap(child: appElement),
    rearchBootstrap(childBuilder: appBuilder),
    querySelector('#react_body_mount_point'),
  );
}
