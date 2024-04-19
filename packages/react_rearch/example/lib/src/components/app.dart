// import 'dart:async';

import 'dart:async';

import 'package:react/react.dart' hide body, footer, header;
import 'package:react/react_client.dart';
import 'package:react_rearch/react_rearch.dart';
import 'package:rearch/rearch.dart';

// ReactDartComponentFactoryProxy2<Component2> appElement =
//     registerComponent2(_App.new);

ReactDartComponentFactoryProxy2<Component2> appBuilder() =>
    registerComponent2(_App.new);

class _App extends RearchComponent {
  _App() {
    debug('constructor()');
  }

  @override
  String get debugName => '_App';

  @override
  ReactNode? build(ComponentHandle use) {
    final loadingCtrl = use(loadingCapsule);

    use.effect(
      () {
        Timer(const Duration(seconds: 10), () {
          // ignore: avoid_print
          debug('TIMER callback');
          loadingCtrl.value = false;
        });

        return null;
      },
      [],
    );

    return div(
      {},
      button(
        {
          'onClick': (_) => loadingCtrl.value = false,
        },
        'Button',
      ),
    );
  }
}

// ignore: avoid_print
// void _debug(String msg) => print('$msg');

ValueWrapper<bool> loadingCapsule(CapsuleHandle use) {
  final controller = use.data(true);

  // ignore: avoid_print
  print('Loading: ${controller.value ? 'ON' : 'OFF'}');

  return controller;
}

// class _App extends RearchComponent {
//   @override
//   ReactNode? build(ComponentHandle use) {
//     return div(
//       {
//         ...Style(
//           {
//             'display': 'flex',
//             'flexDirection': 'column',
//           },
//           size: SySize(
//             fullHeight: true,
//           ),
//         ).value,
//       },
//       header(),
//       content(),
//       footer(),
//     );
//   }
// }
