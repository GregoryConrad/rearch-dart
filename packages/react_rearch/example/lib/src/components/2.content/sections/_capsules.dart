import 'package:react/react_client.dart';
import 'package:react_rearch_example/lib.dart';
import 'package:rearch/rearch.dart';

ValueWrapper<Sections> _currentSectionWrapperCapsule(CapsuleHandle use) =>
    use.data(Sections.first);

SectionsController sectionsController(CapsuleHandle use) {
  final wrapper = use(_currentSectionWrapperCapsule);

  final current = wrapper.value;

  return SectionsController(
    current: current,
    moveToPrevious: () {
      if (current.isFirst) return false;

      wrapper.value = Sections.values.elementAt(current.index - 1);
      return true;
    },
    moveToNext: () {
      if (current.isLast) return false;

      wrapper.value = Sections.values.elementAt(current.index + 1);
      return true;
    },
  );
}

enum Sections {
  first,
  second,
  third,
}

extension SectionsExtension on Sections {
  bool get isFirst => index == 0;
  bool get isLast => index == Sections.values.length - 1;

  ReactElement Function() get component => switch (this) {
        Sections.first => firstSection,
        Sections.second => secondSection,
        Sections.third => thirdSection,
      };
}

class SectionsController {
  SectionsController({
    required this.current,
    required this.moveToPrevious,
    required this.moveToNext,
  });

  final Sections current;
  final bool Function() moveToPrevious;
  final bool Function() moveToNext;
}

ValueWrapper<int> Function(Sections) sectionCounterCapsule(CapsuleHandle use) {
  final counters = use.value(<Sections, int>{});

  use.callonce(() {
    for (final section in Sections.values) {
      counters[section] = 0;
    }
  });

  final rebuild = use.rebuilder();

  bool setCount(Sections section, int count) {
    final current = counters[section]!;
    if (current == count) return false;
    counters[section] = count;
    rebuild();
    return true;
  }

  return (section) => (
        () => counters[section]!,
        (count) => setCount(section, count),
      );
}
