part of '0.section.dart';

ReactElement thirdSection(
        // {required String foo,}
        ) =>
    _thirdSection({
      // _Props.fooField: foo,
    });

extension _ThirdSectionProps on _Section {
  // static const fooField = 'foo';
  // int get foo => props[fooField] as String;
}

class _ThridSection extends _Section {
  @override
  String get title => 'Third Section';

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
      'Section 3 content',
    );
  }
}

ReactDartComponentFactoryProxy2<Component2> _thirdSection =
    registerComponent2(_ThridSection.new);
