part of '../components.dart';

///.
final capsuleContainer = CapsuleContainer();

///.
final capsuleContainerContext = createContext<CapsuleContainer>();

///.
ReactElement rearchBootstrap({required ReactElement child}) =>
    _bootstrapElement({
      _PropsExtension.childField: child,
    });

ReactDartComponentFactoryProxy2<Component2> _bootstrapElement =
    registerComponent2(_RearchBootstrap.new);

extension _PropsExtension on _RearchBootstrap {
  static const childField = 'child';

  ReactElement get childComponent => props[childField] as ReactElement;
}

class _RearchBootstrap extends Component2 {
  // final _capsuleContainer = CapsuleContainer();

  @override
  ReactNode render() {
    // ignore: avoid_print
    return capsuleContainerContext.Provider(
      {
        // 'value': _capsuleContainer,
        'value': capsuleContainer,
      },
      childComponent,
    );
  }
}
