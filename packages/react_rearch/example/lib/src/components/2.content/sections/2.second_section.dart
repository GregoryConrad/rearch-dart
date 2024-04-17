part of '0.section.dart';

ReactElement secondSection(
        // {required String foo,}
        ) =>
    _secondSection({
      // _Props.fooField: foo,
    });

extension _SecondSectionProps on _Section {
  // static const fooField = 'foo';
  // int get foo => props[fooField] as String;
}

class _SecondSection extends _Section {
  @override
  String get title => 'Second Section';

  @override
  ReactNode buildContent(
    ComponentHandle use,
  ) {
    return div(
      {
        ...Style(
          {},
          size: SySize(
              // fullHeight: true,
              ),
        ).value,
      },
      'Section 2 content',
    );
  }
}

ReactDartComponentFactoryProxy2<Component2> _secondSection =
    registerComponent2(_SecondSection.new);
