part of '0.section.dart';

/// App Header component.
ReactDartComponentFactoryProxy2<Component2> thirdSection =
    registerComponent2(_ThridSection.new);

///.
class _ThridSection extends Section {
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
            fullHeight: true,
          ),
        ).value,
      },
      'Section 3 content',
    );
  }
}
