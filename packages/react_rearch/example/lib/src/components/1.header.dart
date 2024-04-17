import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

ReactElement header(
        // {required String foo,}
        ) =>
    _header({
      // _Props.fooField: foo,
    });

extension _Props on _Header {
  // static const fooField = 'foo';
  // int get foo => props[fooField] as String;
}

class _Header extends RearchComponent {
  @override
  String get debugName => '_Header';

  @override
  ReactNode? build(ComponentHandle use) {
    return div(
      {
        ...Style(
          {
            'minHeight': '100px',
          },
          size: SySize(
            heightPercent: 10,
          ),
          color: SyColor(background: '#d0823e'),
          alignment: SyAlignment(
            centerText: true,
          ),
        ).value,
      },
      h1(
        {
          ...Style(
            {},
            alignment: SyAlignment(
              verticallyCenter: true,
            ),
          ).value,
        },
        'Header',
      ),
    );
  }
}

ReactDartComponentFactoryProxy2<Component2> _header =
    registerComponent2(_Header.new);
