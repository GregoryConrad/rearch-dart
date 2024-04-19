part of '../components.dart';

final capsuleContainer = CapsuleContainer();

final capsuleContainerContext = createContext<CapsuleContainer>();

// ReactElement rearchBootstrap({
//   required ReactDartComponentFactoryProxy2<Component2> child,
// }) =>
//     registerComponent2(_RearchBootstrap.new)({
//       _PropsExtension.childField: child,
//     });

ReactElement rearchBootstrap({
  required ReactDartComponentFactoryProxy2<Component2> Function() childBuilder,
}) =>
    registerComponent2(_RearchBootstrap.new)({
      _PropsExtension.childBuilderField: childBuilder,
    });

extension _PropsExtension on _RearchBootstrap {
  static const childBuilderField = 'child';

  ReactDartComponentFactoryProxy2<Component2> Function() get childComponent =>
      props[childBuilderField] as ReactDartComponentFactoryProxy2<Component2>
          Function();
}

class _RearchBootstrap extends Component2 {
  // final _capsuleContainer = CapsuleContainer();

  _RearchBootstrap() {
    // ignore: avoid_print
    print('_RearchBootstrap.constructor()');
  }

  @override
  ReactNode render() {
    // ignore: avoid_print
    print('_RearchBootstrap.render()');

    return capsuleContainerContext.Provider(
      {
        // 'value': _capsuleContainer,
        'value': capsuleContainer,
      },
      childComponent()({}),
    );
  }
}
