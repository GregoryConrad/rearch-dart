import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

/// App Content component.
ReactDartComponentFactoryProxy2<Component2> content =
    registerComponent2(Content.new);

///.
class Content extends RearchComponent {
  @override
  String get debugName => 'Body';

  @override
  ReactNode? build(ComponentHandle use) {
    final currentSection = use(sectionsController).current;

    return div(
      {
        ...Style(
          {
            'flex': '1',
          },
          alignment: SyAlignment(
            centerText: true,
          ),
          color: SyColor(background: '#9d6c14'),
        ).value,
      },
      currentSection.component(
        {},
      ),
    );
  }
}
