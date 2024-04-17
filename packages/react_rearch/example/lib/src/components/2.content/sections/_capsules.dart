import 'package:rearch/rearch.dart';

///.
ValueWrapper<Sections> currentSectionCapsule(CapsuleHandle use) =>
    use.data(Sections.first);

///.
enum Sections {
  ///.
  first,

  ///.
  second,

  ///.
  third,
}
