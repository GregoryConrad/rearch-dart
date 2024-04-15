import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:rearch/rearch.dart';

/// Body App component.
ReactDartComponentFactoryProxy2<Component2> bodyApp =
    registerComponent2(_BodyApp.new);

/// Initiated on loading state.
class _BodyApp extends RearchComponent {
  @override
  ReactNode? build(ComponentHandle use) {
    final counter = use.data(0);

    return div(
      {},
      label({}, 'React ReArch Web Ap Example'),
      button(
        {
          'onClick': (_) => counter.value++,
        },
        'Count: ${counter.value}',
      ),
    );
  }
}
