# React ReArch

Experimental, and not fully supported, port of ReArch to React in Dart.

## Example

#### Index.hmtl
```html
<!DOCTYPE html>

<html>
	<head>
		<base href="/" target="_blank">
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="scaffolded-by" content="https://github.com/dart-lang/sdk">
		<title>React Rearch Example</title>
		<link rel="stylesheet" href="styles/main.css">
		<script src="packages/react/react.js"></script>
		<script src="packages/react/react_dom.js"></script>
		<script defer src="main.dart.js"></script>
	</head>

	<body>
		<!-- Body app -->
		<div id="react_body_mount_point"></div>
	</body>
</html>
```

<!-- #### Index.hml -->
```dart
void main() {
  // ignore: avoid_dynamic_calls
  render(
    rearchBootstrap(child: app()),
    querySelector('#react_body_mount_point'),
  );
}

///.
ReactElement app() => _appElement({});

ReactDartComponentFactoryProxy2<Component2> _appElement =
    registerComponent2(_App.new);

class _App extends RearchComponent {
  @override
  ReactNode? build(ComponentHandle use) {
    final loadingCtrl = use(loadingCapsule);

    use.effect(
      () => Timer.periodic(const Duration(seconds: 10), (_) {
        loadingCtrl.toggle();
      }).cancel,
      [],
    );

    return div(
      {
        'style': {
          'position': 'absolute',
          'top': '50%',
          'left': '50%',
          'transform': 'translate(-50%, -50%)',
          'textAlign': 'center',
        },
      },
      button(
        {
          'onClick': (_) => loadingCtrl.toggle(),
        },
        'Loading: ${loadingCtrl.get() ? 'ON' : 'OFF'}',
      ),
      label({
        'style': {
          'display': 'block',
          'marginTop': '10px',
        },
      }),
      'Count: ${loadingCtrl.count}',
    );
  }
}

///.
LoadingController loadingCapsule(CapsuleHandle use) {
  final controller = use.data(true);
  final count = use.data(0);

  final transactionRunner = use.transactionRunner();

  // ignore: avoid_print
  print('Loading: ${controller.value ? 'ON' : 'OFF'}');

  void set({required bool loading}) {
    transactionRunner(() {
      controller.value = loading;
      count.value += 1;
    });
  }

  return LoadingController(
    get: () => controller.value,
    set: set,
    toggle: () => set(loading: !controller.value),
    count: count.value,
  );
}

///.
class LoadingController {
  ///.
  LoadingController({
    required this.get,
    required this.set,
    required this.toggle,
    required this.count,
  });

  ///.
  final bool Function() get;

  ///.
  final void Function({required bool loading}) set;

  ///.
  final void Function() toggle;

  ///.
  final int count;
}
```