import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';
import 'package:rearch/rearch.dart';

/// Body App component.
ReactDartComponentFactoryProxy2<Component2> header =
    registerComponent2(_Header.new);

/// Initiated on loading state.
class _Header extends RearchComponent {
  @override
  String get debugName => '_Header';

  @override
  ReactNode? build(ComponentHandle use) {
    final appName = use(appNameCapsule).value;

    return div(
      {
        'style': {
          'minHeight': '100px',
          'height': '10%',
          'textAlign': 'center',
          'backgroundColor': '#d0823e',
        },
      },
      h1(
        {
          'style': {
            ...styleVerticallyCenter,
          },
        },
        'Header',
      ),
    );
  }
}
