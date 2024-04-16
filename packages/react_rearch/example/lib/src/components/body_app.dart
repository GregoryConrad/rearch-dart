import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

/// Body App component.
ReactDartComponentFactoryProxy2<Component2> bodyApp =
    registerComponent2(_BodyApp.new);

/// Initiated on loading state.
class _BodyApp extends RearchComponent {
  @override
  String get debugName => '_BodyApp';

  @override
  ReactNode? build(ComponentHandle use) {
    final personController = use(personControllerCapsule);
    final person = personController.get();

    return div(
      {},
      label({}, 'React ReArch Web App Example'),
      button(
        {
          'onClick': (_) => personController.generate(),
        },
        '${person.name} (${person.age})',
      ),
    );
  }
}
