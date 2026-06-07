import 'dart:async';

import 'package:rearch/experimental.dart';
import 'package:rearch/rearch.dart';

void main() {
  CapsuleContainer().read(bootAppCapsule);
}

void bootAppCapsule(CapsuleHandle use) {
  final index = use.data(0);

  use.effect(() {
    return Timer.periodic(const Duration(seconds: 10), (_) {
      index.value++;
    }).cancel;
  });

  use(customIndexDynamicCapsules[index.value]);
}

final DynamicCapsule<int, String> customIndexDynamicCapsules = capsule
    .dynamic<int, String>(
      (use, index, disposeSelf) {
        final count = use.data(0);

        use.effect(() {
          return Timer.periodic(const Duration(seconds: 2), (_) {
            print('<$index>: Count: ${count.value++}');
            if (count.value == 10) {
              disposeSelf();
            }
          }).cancel;
        });

        return 'Index $index';
      },
      (index) {
        print('Disposed $index');
      },
    );
