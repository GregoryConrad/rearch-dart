part of '../components.dart';

final capsuleContainerContext = createContext<CapsuleContainer>();

ReactElement rearchBootstrap({
  required ReactDartComponentFactoryProxy2<Component2> child,
}) =>
    registerComponent2(_RearchBootstrap.new)({
      _PropsExtension.childField: child,
    });

extension _PropsExtension on _RearchBootstrap {
  static const childField = 'child';

  ReactDartComponentFactoryProxy2<Component2> get childComponent =>
      props[childField] as ReactDartComponentFactoryProxy2<Component2>;
}

class _RearchBootstrap extends Component2 {
  final _capsuleContainer = CapsuleContainer();

  @override
  ReactNode render() {
    return capsuleContainerContext.Provider(
      {
        'value': _capsuleContainer,
      },
      childComponent({}),
    );
  }
}
