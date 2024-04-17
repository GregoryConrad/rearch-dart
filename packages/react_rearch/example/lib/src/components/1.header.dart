import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

/// App Header component.
ReactDartComponentFactoryProxy2<Component2> header =
    registerComponent2(_Header.new);

///.
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
