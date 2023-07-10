import 'package:meta/meta.dart';
import 'package:rearch/rearch.dart';

// ignore_for_file: public_member_api_docs

@internal
abstract class DataflowGraphNode implements Disposable {
  final _dependencies = <DataflowGraphNode>{};
  final _dependents = <DataflowGraphNode>{};

  bool get isSuperPure;
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

  void buildSelfAndDependents() {
    // We must build self, so we preemptively build it before other checks
    final selfChanged = buildSelf();
    if (!selfChanged) return;

    /*
    // TODO only build dependents when buildSelf returns true,
    //  and only gc nodes when depenency changes

    final disposable = <_DataflowGraphNode>{};

    buildOrder.reversed.where((node) {
      final dependentsAllDisposable =
          node.dependents.every(disposable.contains);
      return node.isSuperPure && dependentsAllDisposable;
    }).forEach(disposable.add);

    return disposable;
    */

    // Garbage collect all possible dependents and then build the rest
    final buildOrder = garbageCollectDisposableNodes(
      createBuildOrder().skip(1).toList(),
    );
    for (final node in buildOrder) {
      node.buildSelf();
    }
  }

  List<DataflowGraphNode> createBuildOrder() {
    // We need some more information alongside of each node
    // in order to do the topological sort:
    // - False is for the first visit, which adds all deps to be visited,
    //   and then node again
    // - True is for the second visit, which pushes the node to the build order
    final toVisitStack = [(false, this)];
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

    return buildOrderStack.reversed.toList();
  }

  static Iterable<DataflowGraphNode> garbageCollectDisposableNodes(
    List<DataflowGraphNode> buildOrder,
  ) {
    final nonDisposable = <DataflowGraphNode>[];

    for (final node in buildOrder.reversed) {
      final isDisposable = node.isSuperPure && node._dependents.isEmpty;
      if (isDisposable) {
        node.dispose();
      } else {
        nonDisposable.add(node);
      }
    }

    return nonDisposable.reversed;
  }
}
