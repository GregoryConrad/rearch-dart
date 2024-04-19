import 'dart:html';

import 'package:react/react_dom.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/src/components/app.dart';

void main() {
  // ignore: avoid_dynamic_calls
  render(
    rearchBootstrap(child: app()),
    querySelector('#react_body_mount_point'),
  );
}
