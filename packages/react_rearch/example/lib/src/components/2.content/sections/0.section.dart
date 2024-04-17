import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:react_rearch_example/lib.dart';
import 'package:rearch/rearch.dart';

part '1.first_section.dart';
part '2.second_section.dart';
part '3.third_section.dart';

extension _SectionProps on _Section {
  // static const fooField = 'foo';
  // int get foo => props[fooField] as String;
}

abstract class _Section extends RearchComponent {
  @override
  String get debugName => 'Section -- $title';

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

      // Counter button
      counterButton(use),

      // Content
      buildContent(use),
    );
  }

  ReactNode buildContent(ComponentHandle use);
}

ReactNode _sectionSelector(ComponentHandle use) {
  final controller = use(sectionsController);
  final current = controller.current;

  return div(
    {},
    _sectionSelectorButton(
      '<',
      enable: !current.isFirst,
      action: controller.moveToPrevious,
    ),
    _sectionSelectorButton(
      '>',
      enable: !current.isLast,
      action: controller.moveToNext,
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

ReactNode counterButton(ComponentHandle use) {
  final controller = use(sectionsController);
  final current = controller.current;
  final currentCounter = use(sectionCounterCapsule)(current);

  return button(
    {
      'onClick': (_) => currentCounter.value++,
    },
    'Counter: ${currentCounter.value}',
  );
}
