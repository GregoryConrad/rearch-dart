import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react_rearch_example/lib.dart';
import 'package:rearch/rearch.dart';

ValueWrapper<Sections> currentSectionWrapperCapsule(CapsuleHandle use) =>
    use.data(Sections.first);

Sections currentSectionCapsule(CapsuleHandle use) =>
    use(currentSectionWrapperCapsule).value;

void Function() moveToPreviousSectionCapsule(CapsuleHandle use) {
  final wrapper = use(currentSectionWrapperCapsule);
  return () =>
      wrapper.value = Sections.values.elementAt(wrapper.value.index - 1);
}

void Function() moveToNextSectionCapsule(CapsuleHandle use) {
  final wrapper = use(currentSectionWrapperCapsule);
  return () =>
      wrapper.value = Sections.values.elementAt(wrapper.value.index + 1);
}

enum Sections {
  first,
  second,
  third,
}

extension SectionsExtension on Sections {
  bool get isFirst => index == 0;
  bool get isLast => index == Sections.values.length - 1;

  ReactDartComponentFactoryProxy2<Component2> get component => switch (this) {
        Sections.first => firstSection,
        Sections.second => secondSection,
        Sections.third => thirdSection,
      };
}
