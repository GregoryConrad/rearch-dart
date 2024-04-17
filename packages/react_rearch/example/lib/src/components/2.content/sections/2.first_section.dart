part of '0.section.dart';

/// App Header component.
ReactDartComponentFactoryProxy2<Component2> secondSection =
    registerComponent2(_SecondSection.new);

///.
class _SecondSection extends Section {
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
