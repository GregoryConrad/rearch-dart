import 'package:meta/meta.dart';
import 'package:rearch/rearch.dart';

// ignore_for_file: public_member_api_docs

@internal
abstract class DataflowGraphNode implements Disposable {
  final _dependencies = <DataflowGraphNode>{};
  final _dependents = <DataflowGraphNode>{};

  bool get isIdempotent;
  bool buildSelf();

  @override
  @mustCallSuper
  void dispose() => clearDependencies();

  void addDependency(DataflowGraphNode node) {
    _dependencies.add(node);
    node._dependents.add(this);
  }

  void clearDependencies() {
    for (final dep in _dependencies) {
      dep._dependents.remove(this);
    }
    _dependencies.clear();
  }

  bool get hasNoDependents => _dependents.isEmpty;

  static void buildNodesAndDependents(Set<DataflowGraphNode> nodes) {
    final buildOrderStack = _createBuildOrderStack(nodes);
    final disposableNodes =
        _getDisposableNodesFromBuildOrderStack(buildOrderStack);
    final changedNodes = <DataflowGraphNode>{};

    for (final node in buildOrderStack.reversed) {
      final buildIsRequired = nodes.contains(node);
      final haveDepsChanged = node._dependencies.any(changedNodes.contains);
      if (!buildIsRequired && !haveDepsChanged) continue;

      if (disposableNodes.contains(node)) {
        // Note: dependency/dependent relationships will be ok after this,
        // since we are disposing all dependents in the build order,
        // because we are adding this node to changedNodes
        node.dispose();
        changedNodes.add(node);
      } else {
        final didNodeChange = node.buildSelf();
        if (didNodeChange) {
          changedNodes.add(node);
        }
      }
    }
  }

  static List<DataflowGraphNode> _createBuildOrderStack(
    Set<DataflowGraphNode> start,
  ) {
    // We need some more information alongside of each node
    // in order to do the topological sort:
    // - False is for the first visit, which adds all deps to be visited,
    //   and then node again
    // - True is for the second visit, which pushes the node to the build order
    final toVisitStack = [for (final node in start) (false, node)];
    final visited = <DataflowGraphNode>{};
    final buildOrderStack = <DataflowGraphNode>[];

    while (toVisitStack.isNotEmpty) {
      final (hasVisitedBefore, node) = toVisitStack.removeLast();

      if (hasVisitedBefore) {
        // Already processed this node's dependents, so add to build order
        buildOrderStack.add(node);
      } else if (!visited.contains(node)) {
        // New node, so mark this node to be added later and process dependents
        visited.add(node);
        toVisitStack.add((true, node)); // mark to be added to build order later
        node._dependents
            .where((dep) => !visited.contains(dep))
            .forEach((dep) => toVisitStack.add((false, dep)));
      }
    }

    return buildOrderStack;
  }

  static Set<DataflowGraphNode> _getDisposableNodesFromBuildOrderStack(
    List<DataflowGraphNode> buildOrderStack,
  ) {
    final disposable = <DataflowGraphNode>{};

    buildOrderStack.where((node) {
      final dependentsAllDisposable =
          node._dependents.every(disposable.contains);
      return node.isIdempotent && dependentsAllDisposable;
    }).forEach(disposable.add);

    return disposable;
  }
}
