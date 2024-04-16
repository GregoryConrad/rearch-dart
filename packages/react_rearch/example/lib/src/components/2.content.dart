import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';
import 'package:rearch/rearch.dart';

/// Body App component.
ReactDartComponentFactoryProxy2<Component2> content =
    registerComponent2(Content.new);

/// Initiated on loading state.
class Content extends RearchComponent {
  @override
  String get debugName => 'Body';

  @override
  ReactNode? build(ComponentHandle use) {
    final appName = use(appNameCapsule).value;

    return div(
      {
        'style': {
          'flex': '1',
          'textAlign': 'center',
          'backgroundColor': '#9d6c14',
        },
      },
      div(
        {
          'style': {
            ...getStyleVerticallyCenter(20),
          },
        },
        appName,
      ),
    );
  }
}
