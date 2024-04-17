import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

ReactElement content(
        // {required String foo,}
        ) =>
    _content({
      // _Props.fooField: foo,
    });

extension _Props on _Content {
  // static const fooField = 'foo';
  // int get foo => props[fooField] as String;
}

class _Content extends RearchComponent {
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
      currentSection.component(),
    );
  }
}

ReactDartComponentFactoryProxy2<Component2> _content =
    registerComponent2(_Content.new);
