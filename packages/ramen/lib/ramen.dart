import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';
import 'package:rearch/rearch.dart';
import 'package:web/web.dart';

// TODO(GregoryConrad): documentation
// ignore_for_file: public_member_api_docs, unused_local_variable

// TODO(GregoryConrad): ensure we do an == check optimization on all views

// NOTE: we want an actual interface here
// ignore: one_member_abstracts
abstract interface class Injector<T> {
  T build(ViewHandle use);
}

// NOTE: This is needed since Dart's type system doesn't support my ideal API.
final class InjectorKey<@experimental T> {
  @experimental
  const InjectorKey(this._injectorType);
  final Type _injectorType;
}

sealed class IntermediateView {}

final class _InitialView implements IntermediateView {
  const _InitialView();
}

final class _InjectorView implements IntermediateView {
  const _InjectorView(this.injector);
  final Injector<Object?> injector;
}

final class _NestedView implements IntermediateView {
  const _NestedView(this.parent, this.child);
  final IntermediateView parent;
  final IntermediateView child;
}

final class _IntermediateNodeView implements IntermediateView {
  const _IntermediateNodeView(this.node);
  final Node node;
}

abstract interface class CustomIntermediateView implements IntermediateView {
  IntermediateView build(ViewHandle use, BuildContext context);
}

sealed class TerminatedView {}

final class _TerminatedNodeView implements TerminatedView {
  const _TerminatedNodeView(this.parent, this.node, this.children);
  final IntermediateView parent;
  final Node node;
  final List<TerminatedView> children;
}

final class _AliasTerminatedView implements TerminatedView {
  const _AliasTerminatedView(this.parent, this.alias);
  final IntermediateView parent;
  final TerminatedView alias;
}

abstract interface class CustomTerminatedView implements TerminatedView {
  TerminatedView build(ViewHandle use, BuildContext context);
}

extension IntermediateViewBuilder on IntermediateView {
  IntermediateView nest(IntermediateView child) => _NestedView(this, child);

  IntermediateView inject<T>(Injector<T> injector) =>
      nest(_InjectorView(injector));

  IntermediateView node(Node node) => nest(_IntermediateNodeView(node));

  TerminatedView terminateWithNode(
    Node node, {
    List<TerminatedView>? children,
  }) => _TerminatedNodeView(this, node, children ?? []);

  TerminatedView terminate(TerminatedView view) =>
      _AliasTerminatedView(this, view);
}

IntermediateView view() => const _InitialView();

/// New methods may be added to this interface on any new _minor_ release
/// (minor in terms of semver).
@experimental
abstract interface class ViewSideEffectApi implements SideEffectApi {}

/// Defines what a [ViewSideEffect] should look like (a [Function]
/// that consumes a [ViewSideEffectApi] and returns something).
typedef ViewSideEffect<T> = T Function(ViewSideEffectApi);

/// Represents an object that can [register] [ViewSideEffect]s.
abstract interface class ViewSideEffectRegistrar
    implements SideEffectRegistrar {
  @override
  T register<T>(ViewSideEffect<T> sideEffect);
}

/// The [ViewHandle] is to [view]s what a [CapsuleHandle] is to
/// [Capsule]s.
///
/// [ViewHandle]s provide a mechanism to watch [Capsule]s and
/// register [SideEffect]s, so all Capsule-specific methodologies
/// carry over.
abstract interface class ViewHandle
    implements CapsuleReader, ViewSideEffectRegistrar {}

/// New methods may be added to this interface on any new _minor_ release
/// (minor in terms of semver).
@experimental
// NOTE: we want an actual interface here
// ignore: one_member_abstracts
abstract interface class BuildContext {
  T injection<T>(InjectorKey<T> key);
}

// @view // works for Node, IntermediateView, and TerminatedView
// TerminatedView myView(ViewHandle use) => view()
//   ..node(HTMLElement.header())
//   ..node(HTMLElement.header());
// generates a class builder and extension method
// @injector // does same thing as @view but for injection
// ValueWrapper<int> myInjector(ViewHandle use) => use.data(123);

final class BuildContextImpl implements BuildContext {
  const BuildContextImpl(this.injectionMap, this.read);
  final IMap<Type, Capsule<Object?>> injectionMap;
  final CapsuleReader read;

  @override
  T injection<T>(InjectorKey<T> key) {
    assert(
      injectionMap.containsKey(key._injectorType),
      'No ancestor ${key._injectorType} was found in the view tree! '
      'In order to use BuildContext.injection(), the corresponding data '
      'must first be inject()-ed above in the view tree.',
    );
    return read(injectionMap[key._injectorType]!) as T;
  }
}

void _inflateIntermediate(IntermediateView view) {
  switch (view) {
    case _InitialView():
      break;
    case _InjectorView(:final injector):
    // TODO(GregoryConrad): Handle this case.
    case _NestedView(:final parent, :final child):
    // TODO(GregoryConrad): Handle this case.
    case _IntermediateNodeView(:final node):
      // TODO(GregoryConrad): Handle this case.
      break;
    case CustomIntermediateView():
    // TODO(GregoryConrad): Handle this case.
  }
}

// NOTE: this is prototype code
// ignore: unused_element
void _inflateTerminated({
  required TerminatedView view,
  required IList<Object?> pathSoFar,
  required IMap<Type, Capsule<Object?>> injectionMap,
  required Node? parentNode,
  required Capsule<Object?> logicalParent,
}) {
  // add this capsule, keyed under pathSoFar + curr layer, to manager.
  // on rebuilds, grab current set of keys that prefix match.
  // give them new widget, or forceful dispose them and dependents
  switch (view) {
    case _TerminatedNodeView(:final parent, :final node, :final children):
      _inflateIntermediate(parent);
      // TODO(GregoryConrad): node
      for (final child in children) {
        // _inflateTerminated(child);
      }
    case _AliasTerminatedView(:final parent, :final alias):
      _inflateIntermediate(parent);
    // _inflateTerminated(alias);
    case CustomTerminatedView():
    // TODO(GregoryConrad): Handle this case.
  }
}

(Node Function(TerminatedView), dynamic) _viewsOrchestrator(CapsuleHandle use) {
  throw UnimplementedError();
  // return function that returns auto-updating Node given a TerminatedView
  // manage map of keys (pathSoFar) to capsules
}

Node Function(TerminatedView) viewInflaterAction(CapsuleHandle use) =>
    use(_viewsOrchestrator).$1;

// typedef _ViewCapsuleData = ({
//   BuildContextImpl context,
//   Node node,
//   List<TerminatedViewBuilder> childrenToBuild,
// });
// typedef _ViewCapsule = Capsule<_ViewCapsuleData>;

// // Capsule<dynamic> Function(ViewBuilder)
// dynamic viewsOrchestrator(CapsuleHandle use) {
//   final viewCapsules = use.value(<Key, Capsule<dynamic>>{});

//   _ViewCapsule buildView(
//     _ViewCapsule parent,
//     _ViewLayer viewLayer,
//   ) {
//     _ViewCapsuleData mainCapsule(CapsuleHandle use) {
//       final (:context, node: parentNode, childrenToBuild: _) = use(parent);

//       // build own HTML nodes using parent context and handle
//       final modifiedContext = context;
//       final newChild = null as Node;

//       use.effect(
//         () {
//           parentNode.appendChild(newChild);
//           return () => parentNode.removeChild(newChild);
//         },
//         [parentNode, newChild],
//       );

//       return (context: modifiedContext, node: newChild, childrenToBuild: []);
//     }

//     void childrenToBuildListener(CapsuleHandle use) {
//       use.asListener();
//       final childrenToBuild = use(mainCapsule).childrenToBuild;
//       // do this
//     }

//     throw '';
//     // also return a listener that listens to above capsule's viewbuilders
//     // and builds all of those
//   }

//   return null;
// }
