import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

/// App Footer component.
ReactDartComponentFactoryProxy2<Component2> footer =
    registerComponent2(_Footer.new);

///.
class _Footer extends RearchComponent {
  @override
  String get debugName => '_Footer';

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
        'Footer',
      ),
    );
  }
}
