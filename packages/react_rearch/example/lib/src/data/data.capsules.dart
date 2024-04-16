import 'package:rearch/rearch.dart';

///.
ValueWrapper<String> nameCapsule(CapsuleHandle use) => use.data('Pedro');

///.
ValueWrapper<int> ageCapsule(CapsuleHandle use) => use.data(30);

/// .
PersonController personControllerCapsule(CapsuleHandle use) {
  final name = use(nameCapsule);
  final age = use(ageCapsule);

  final transactionRunner = use.transactionRunner();

  return PersonController(
    get: () => (name: name.value, age: age.value),
    generate: () {
      transactionRunner(() {
        name.value += '_';
        age.value++;
      });
    },
  );
}

///.
class PersonController {
  ///.
  PersonController({
    required this.get,
    required this.generate,
  });

  ///.
  final ({String name, int age}) Function() get;

  ///.
  final void Function() generate;
}
