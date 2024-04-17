part of '0.section.dart';

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
              // fullHeight: true,
              ),
        ).value,
      },
      'Section 1 content',
    );
  }
}
