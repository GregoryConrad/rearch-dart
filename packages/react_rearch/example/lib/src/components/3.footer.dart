import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

extension _Props on _Footer {
  static const appInitDatetimeField = 'app-init-datetime';

  DateTime get appInitDatetime => props[appInitDatetimeField] as DateTime;
}

ReactElement footer({
  required DateTime appInitDateTime,
}) =>
    _footer({
      _Props.appInitDatetimeField: appInitDateTime,
    });

ReactDartComponentFactoryProxy2<Component2> _footer =
    registerComponent2(_Footer.new);

class _Footer extends RearchComponent {
  @override
  String get debugName => '_Footer';

  @override
  bool get debug => true;

  @override
  ReactNode? build(ComponentHandle use) {
    return div(
      {
        ...Style(
          {
            'minHeight': '50px',
          },
          size: SySize(
            heightPercent: 5,
          ),
          color: SyColor(
            background: '#e59c4e',
          ),
          alignment: SyAlignment(
            centerText: true,
          ),
        ).value,
      },
      h4(
        {
          ...Style(
            {},
            alignment: SyAlignment(
              verticallyCenter: true,
            ),
          ).value,
        },
        'Footer ($appInitDatetime)',
      ),
    );
  }
}
