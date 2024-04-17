import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

///.
abstract class Section extends RearchComponent {
  @override
  String get debugName => 'Section';

  ///.
  String get title;

  @override
  ReactNode? build(ComponentHandle use) {
    return div(
      {
        ...Style(
          {
            'paddingTop': '20px',
          },
          size: SySize(
            fullHeight: true,
          ),
        ).value,
      },
      h3(
        {},
        title,
      ),
      buildContent(use),
    );
  }

  ///.
  ReactNode buildContent(ComponentHandle use);
}
