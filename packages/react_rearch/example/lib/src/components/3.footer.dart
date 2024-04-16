import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';
import 'package:rearch/rearch.dart';

/// Body App component.
ReactDartComponentFactoryProxy2<Component2> footer =
    registerComponent2(_Footer.new);

/// Initiated on loading state.
class _Footer extends RearchComponent {
  @override
  String get debugName => '_Footer';

  @override
  ReactNode? build(ComponentHandle use) {
    return div(
      {
        'style': {
          'minHeight': '50px',
          'height': '5%',
          'textAlign': 'center',
          'backgroundColor': '#e59c4e',
        },
      },
      h4(
        {
          'style': {
            ...styleVerticallyCenter,
          },
        },
        'Footer',
      ),
    );
  }
}
