// import 'dart:async';

import 'package:react/react.dart' hide body, footer, header;
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

ReactElement app(
        // {required String foo,}
        ) =>
    _app({
      // _Props.fooField: foo,
    });

extension _Props on _App {
  // static const fooField = 'foo';
  // int get foo => props[fooField] as String;
}

class _App extends RearchComponent {
  @override
  String get debugName => '_App';

  @override
  bool get debug => false;

  @override
  ReactNode? build(ComponentHandle use) {
    return div(
      {
        ...Style(
          {
            'display': 'flex',
            'flexDirection': 'column',
          },
          size: SySize(
            fullHeight: true,
          ),
        ).value,
      },
      header(),
      content(),
      footer(),
    );
  }
}

ReactDartComponentFactoryProxy2<Component2> _app = registerComponent2(_App.new);
