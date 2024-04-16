import 'package:react/react.dart' hide body, footer, header;
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

/// Body App component.
ReactDartComponentFactoryProxy2<Component2> app = registerComponent2(_App.new);

/// Initiated on loading state.
class _App extends RearchComponent {
  @override
  String get debugName => '_App';

  @override
  ReactNode? build(ComponentHandle use) {
    final personController = use(personControllerCapsule);

    return div(
      {
        'style': {
          'height': '100%',
          'display': 'flex',
          'flexDirection': 'column',
        },
      },
      header(
        {},
      ),
      content(
        {},
      ),
      footer(
        {},
      ),
    );
  }
}
