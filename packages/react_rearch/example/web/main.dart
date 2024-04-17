import 'dart:html';

import 'package:react/react_dom.dart';
import 'package:react_rearch_example/lib.dart';

void main() {
  // Body app
  // ignore: avoid_dynamic_calls
  render(app(), querySelector('#react_body_mount_point'));
}
