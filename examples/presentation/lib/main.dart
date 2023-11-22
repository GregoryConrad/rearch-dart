import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:rearch/rearch.dart';

// ignore_for_file: public_member_api_docs

void main() {
  usePathUrlStrategy();
  runApp(const PresentationApp());
}

class PresentationApp extends StatelessWidget {
  const PresentationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RearchBootstrapper(
      child: FlutterDeckApp(
        speakerInfo: const FlutterDeckSpeakerInfo(
          name: 'Gregory Conrad',
          description: 'Advisor: Professor George Heineman',
          socialHandle: 'github.com/GregoryConrad',
          imagePath: 'assets/portrait.jpg',
        ),
        configuration: const FlutterDeckConfiguration(
          transition: FlutterDeckTransition.fade(),
          // TODO(GregoryConrad): either change these defaults or delete
          // transition: FlutterDeckTransition.none(),
          // background: FlutterDeckBackgroundConfiguration(
          //   light: FlutterDeckBackground.solid(Color(0xFFB5FFFC)),
          //   dark: FlutterDeckBackground.solid(Color(0xFF16222A)),
          // ),
          // Override controls so that TextFields can receive "m" and "."
          controls: FlutterDeckControlsConfiguration(
            openDrawerKey: LogicalKeyboardKey.arrowUp,
            toggleMarkerKey: LogicalKeyboardKey.arrowDown,
          ),
          footer: FlutterDeckFooterConfiguration(
            showSlideNumbers: true,
            // TODO(GregoryConrad): WPI logo
            // widget: FlutterLogo(),
          ),
          progressIndicator: FlutterDeckProgressIndicator.gradient(
            backgroundColor: Colors.black,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink, Colors.purple],
            ),
          ),
        ),
        slides: const [
          FunctionalSlide(
            builder: intro,
            configuration: FlutterDeckSlideConfiguration(
              route: '/intro',
            ),
          ),
          FunctionalSlide(
            builder: agenda,
            configuration: FlutterDeckSlideConfiguration(
              route: '/agenda',
              header: FlutterDeckHeaderConfiguration(
                title: 'Agenda',
              ),
            ),
          ),

          // Motivation
          // - Many tried and true for OOP, not as many functional
          // - Need to build an application around data and ops on the data
          // - Declarative ONLY approach to application building
          // - loose coupling

          // Background
          // Background (State Management)
          // - Dart/Flutter, Widgets
          // Background (Component-Based Software Engineering)
          // Background (Incremental Computation)

          // Design
          // - Capsules, Containers, Side Effects
          // Design (Capsules)
          // - stateless, declarative, pure functions, despite side effects
          // - spreadsheet analogy with cells, A1 and B1
          // - capsule composition forms a *directed acyclic graph*
          // - graph is formed internally from capsule dependencies
          // Design (Containers)
          // - a mapping of capsule to their states (often backed by hash map)
          // - operates in entire states, strong consistency across capsules
          // - contain state of a set of capsules
          // - store side effect state, which are the crux of an application
          // - as idempotent capsules can be calcualted on teh fly
          // Design (Side Effects)
          // - tuple of private data coupled with a way to mutate that data,
          // - triggering a rebuild
          // - Are stored directly in the container
          // - side effects compose into a tree
          // Design (Side Effects Cont.)
          // - I lied--a simplistic model is a DAG.
          // - side effects are actually equivalent to self reads,
          //   which is allowed:
          // - example of a counter with both self reads and side effects

          // Paradigms
          FunctionalSlide(
            builder: paradigms,
            configuration: FlutterDeckSlideConfiguration(
              route: '/paradigms',
              header: FlutterDeckHeaderConfiguration(
                title: 'Paradigms',
              ),
            ),
          ),
          FunctionalSlide(
            builder: factories,
            configuration: FlutterDeckSlideConfiguration(
              route: '/paradigms/factories',
              header: FlutterDeckHeaderConfiguration(
                title: 'Paradigms (Factories)',
              ),
            ),
          ),
          FunctionalSlide(
            builder: actions,
            configuration: FlutterDeckSlideConfiguration(
              route: '/paradigms/actions',
              header: FlutterDeckHeaderConfiguration(
                title: 'Paradigms (Actions)',
              ),
            ),
          ),
          FunctionalSlide(
            builder: asynchrony,
            configuration: FlutterDeckSlideConfiguration(
              route: '/paradigms/asynchrony',
              header: FlutterDeckHeaderConfiguration(
                title: 'Paradigms (Asynchrony)',
              ),
            ),
          ),

          // Implementations
          // Implementations (Algorithms)
          // - graph is formed from capsules
          // Implementations (Algorithms Cont.)
          // - idempotent garbage collection
          // Implementations (Dart and Flutter Library)
          // - special features for functional style UI development
          //   (functional widgets)
          // - todos ui application (include dep graph pic)
          FunctionalSlide(
            builder: counterExample,
            configuration: FlutterDeckSlideConfiguration(
              route: '/implementations/counter-example',
              header: FlutterDeckHeaderConfiguration(
                title: 'Implementations (Dart and Flutter Library Cont.)',
              ),
            ),
          ),
          // Implementations (Rust Library)
          // - geared toward server and systems needs
          // - Rust container is safe across multithreaded environments,
          //   with high reads and mutex blocked writes
          // - todos web server (include endpoints, dep graph pic)
          // Implementations (Rust Library Benchmark)

          // Future Works
          // - grab from paper

          // Conclusion
          FunctionalSlide(
            builder: conclusion,
            configuration: FlutterDeckSlideConfiguration(
              route: '/conclusion',
              header: FlutterDeckHeaderConfiguration(
                title: 'Conclusion',
              ),
            ),
          ),
          FunctionalSlide(
            builder: builtWithRearch,
            configuration: FlutterDeckSlideConfiguration(
              route: '/conclusion/built-with-rearch',
            ),
          ),
          FunctionalSlide(
            builder: qAndA,
            configuration: FlutterDeckSlideConfiguration(
              route: '/conclusion/q-and-a',
            ),
          ),
        ],
      ),
    );
  }
}

/// Helps reduce the boilerplate associated with making new slides.
/// Ideally, we would just have a macro,
/// but static metaprogramming isn't a thing quite yet.
class FunctionalSlide extends FlutterDeckSlideWidget {
  const FunctionalSlide({required super.configuration, required this.builder});

  final FlutterDeckSlide Function(BuildContext context) builder;

  @override
  FlutterDeckSlide build(BuildContext context) => builder(context);
}

FlutterDeckSlide intro(BuildContext context) {
  return FlutterDeckSlide.title(
    title: 'ReArch',
    subtitle: 'A Reactive Approach to Application Architecture '
        'Supporting Side Effects',
  );
}

FlutterDeckSlide agenda(BuildContext context) {
  return FlutterDeckSlide.blank(
    builder: (context) {
      return FlutterDeckBulletList(
        items: const [
          'Motivation',
          'Background',
          'Design',
          'Paradigms',
          'Implementations',
          'Future Works',
          'Conclusion',
        ],
      );
    },
  );
}

({int count, void Function() incrementCount}) countManager(CapsuleHandle use) {
  final (count, setCount) = use.state(0);
  return (
    count: count,
    incrementCount: () => setCount(count + 1),
  );
}

class Counter extends RearchConsumer {
  const Counter({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.add),
      label: Text(
        '${use(countManager).count}',
        style: const TextStyle(fontSize: 20),
      ),
      onPressed: use(countManager).incrementCount,
    );
  }
}

FlutterDeckSlide counterExample(BuildContext context) {
  return FlutterDeckSlide.split(
    splitRatio: const SplitSlideRatio(left: 3),
    leftBuilder: (context) {
      return const FlutterDeckCodeHighlight(
        fileName: 'counter_example.dart',
        code: r'''
/// A capsule that manages a counter.
({int count, void Function() incrementCount}) countManager(CapsuleHandle use) {
  final (count, setCount) = use.state(0);
  return (
    count: count,
    incrementCount: () => setCount(count + 1),
  );
}

/// A widget that displays and increments the count.
@rearchWidget
Widget counter(WidgetHandle use) {
  return ElevatedButton.icon(
    icon: const Icon(Icons.add),
    label: Text('${use(countManager).count}'),
    onPressed: use(countManager).incrementCount,
  );
}''',
      );
    },
    rightBuilder: (context) {
      return const Center(
        child: SizedBox(height: 48, child: Counter()),
      );
    },
  );
}

FlutterDeckSlide paradigms(BuildContext context) {
  return FlutterDeckSlide.blank(
    builder: (context) {
      return FlutterDeckBulletList(
        items: const [
          'So how do we build an actual application?',
          'ReArch provides the building blocks; they must be constructed upon.',
          'Factories',
          'Actions',
          'Asynchrony',
          'And many others...',
        ],
      );
    },
  );
}

String salutationCapsule(CapsuleHandle use) => 'Hello';

String Function(String) greetingFactory(CapsuleHandle use) {
  final salutation = use(salutationCapsule);
  return (name) => '$salutation, $name!';
}

FlutterDeckSlide factories(BuildContext context) {
  return FlutterDeckSlide.split(
    splitRatio: const SplitSlideRatio(left: 3, right: 2),
    leftBuilder: (context) {
      return const Stack(
        children: [
          Positioned.fill(
            top: 8,
            child: Column(
              children: [
                Text(
                  '"In object-oriented programming, a factory is an object '
                  'for creating other objects; formally, it is a function '
                  'or method that returns objects..."',
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 12),
                Text('~Wikipedia', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Positioned.fill(
            child: Center(
              child: FlutterDeckCodeHighlight(
                fileName: 'greeting.dart',
                code: r'''
String salutationCapsule(CapsuleHandle use) => 'Hello';

String Function(String) greetingFactory(CapsuleHandle use) {
  final salutation = use(salutationCapsule);
  return (name) => '$salutation, $name!';
}''',
              ),
            ),
          ),
        ],
      );
    },
    rightBuilder: (context) {
      return RearchBuilder(
        builder: (context, use) {
          final (name, setName) = use.state('Audience');
          final createGreeting = use(greetingFactory);
          final textColor = FlutterDeckTheme.of(context).slideTheme.color;
          final textStyle = TextStyle(color: textColor, fontSize: 24);

          return Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(createGreeting(name), style: textStyle),
                    const SizedBox(height: 16),
                    TextField(
                      style: textStyle,
                      onChanged: setName,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: Text('Name', style: textStyle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

FlutterDeckSlide actions(BuildContext context) {
  return FlutterDeckSlide.split(
    leftBuilder: (context) {
      return FlutterDeckBulletList(
        items: const [
          'Directly derived from application feature requirements',
          'Often perform side effects (in the container or externally)',
          'Enables *easy* loose coupling for a particular functionality',
        ],
      );
    },
    rightBuilder: (context) {
      return const FlutterDeckCodeHighlight(
        language: 'rust',
        fileName: 'actions_example.rs',
        code: '''
fn x_manager(
    CapsuleHandle { register, .. }: CapsuleHandle
) -> (u32, impl CData + Fn(u32)) {
    let (x, set_x) = register(side_effects::state(0));
    (*x, set_x)
}

fn increment_x_action(
    CapsuleHandle { mut get, .. }: CapsuleHandle
) -> impl CData + Fn() {
    let (x, set_x) = get(x_manager);
    move || set_x(x + 1)
}''',
      );
    },
  );
}

FlutterDeckSlide asynchrony(BuildContext context) {
  return FlutterDeckSlide.blank(
    builder: (context) {
      return FlutterDeckBulletList(
        items: const [
          'TODO',
          'Long or delayed computations',
          'Interfacing with I/O',
        ],
      );
    },
  );
}

FlutterDeckSlide conclusion(BuildContext context) {
  return FlutterDeckSlide.blank(
    builder: (context) {
      return FlutterDeckBulletList(
        items: const ['TODO grab this from the pres we got from prof heineman'],
      );
    },
  );
}

FlutterDeckSlide builtWithRearch(BuildContext context) {
  return FlutterDeckSlide.quote(quote: 'Built with ReArch');
}

FlutterDeckSlide qAndA(BuildContext context) {
  // A misuse of the quote template for sure, but it works great for this.
  return FlutterDeckSlide.quote(
    quote: 'Thanks for listening!',
    attribution: 'Any questions or comments?',
  );
}
