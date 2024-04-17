import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

/// App Header component.
ReactDartComponentFactoryProxy2<Component2> firstSection =
    registerComponent2(_FirstSection.new);

///.
class _FirstSection extends Section {
  @override
  String get title => 'First Section';

  @override
  ReactNode buildContent(
    ComponentHandle use,
  ) {
    return div(
      {
        ...Style(
          {},
          size: SySize(
            fullHeight: true,
          ),
        ).value,
      },
      'Section 1 content',
    );
  }
}
