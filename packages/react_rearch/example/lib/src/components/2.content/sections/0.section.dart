import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';

part '1.first_section.dart';
part '2.first_section.dart';
part '3.first_section.dart';

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

      // Section selector
      _sectionSelector(use),

      // Title
      h3(
        {},
        title,
      ),

      // Content
      buildContent(use),
    );
  }

  ///.
  ReactNode buildContent(ComponentHandle use);
}

ReactNode _sectionSelector(ComponentHandle use) {
  final currentSection = use(currentSectionCapsule);
  final toPreviousSection = use(moveToPreviousSectionCapsule);
  final toNextSection = use(moveToNextSectionCapsule);

  return div(
    {},
    _sectionSelectorButton(
      '<',
      enable: !currentSection.isFirst,
      action: toPreviousSection,
    ),
    _sectionSelectorButton(
      '>',
      enable: !currentSection.isLast,
      action: toNextSection,
    ),
  );
}

ReactNode _sectionSelectorButton(
  String text, {
  required bool enable,
  required void Function() action,
}) =>
    button(
      {
        'disabled': !enable,
        'onClick': (_) => action(),
      },
      text,
    );
