import "package:flutter/material.dart";
import "package:interactive_graph_view/interactive_graph_view.dart";

import "../../business/entities/automaton_graph_entity.dart";
import "../../business/entities/automaton_result_entity.dart";

/// View where [GraphView] is located to use it
class AutomatonGraphView extends StatefulWidget {
  /// View where [GraphView] is located to use it
  const AutomatonGraphView({
    required this.result,
    required this.showDfa,
    super.key,
  });

  /// Result automaton entity value
  final AutomatonResultEntity result;

  /// Boolean flag is dfa is shown
  final bool showDfa;

  @override
  State<AutomatonGraphView> createState() => _AutomatonGraphViewState();
}

class _AutomatonGraphViewState extends State<AutomatonGraphView> {
  late GraphViewportController<String, String> _viewportController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(AutomatonGraphView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambió el grafo (NFA ↔ DFA o nueva regex), reiniciamos el controller
    if (oldWidget.result != widget.result ||
        oldWidget.showDfa != widget.showDfa) {
      // Forzar reconstrucción completa del controller
      _viewportController = GraphViewportController(
        initialNodeIds: const [], // Empezar vacío
        initialEdgeIds: const [],
      );
      _initController(); // Inicializar con los nuevos datos
    }
  }

  void _initController() {
    final graph = widget.showDfa ? widget.result.dfa : widget.result.nfa;
    final nodeIds = graph.allStateIds;
    final edgeIds = _buildEdgeIds(graph);

    _viewportController = GraphViewportController(
      initialNodeIds: nodeIds,
      initialEdgeIds: edgeIds.keys,
    );
  }

  /// Construye IDs únicos para cada transición del grafo.
  /// Formato: "fromId__symbol__toId" (doble guión para evitar colisiones).
  Map<String, (String from, String symbol, String to)> _buildEdgeIds(
    AutomatonGraphEntity graph,
  ) {
    final edges = <String, (String, String, String)>{};
    final validStateIds = graph.allStateIds;

    if (graph.isNfa) {
      for (final state in graph.nfaStates) {
        for (final t in state.transitions) {
          // Validar que ambos estados existen
          if (!validStateIds.contains(t.fromStateId) ||
              !validStateIds.contains(t.toStateId)) {
            debugPrint(
              "⚠️ Skipping invalid NFA transition: ${t.fromStateId} -> ${t.toStateId}",
            );
            continue;
          }
          final label = t.isEpsilon ? "ε" : t.symbol!;
          final id = "${t.fromStateId}__${label}__${t.toStateId}";
          edges[id] = (t.fromStateId, label, t.toStateId);
        }
      }
    } else {
      for (final state in graph.dfaStates) {
        for (final t in state.transitions) {
          // Validar que ambos estados existen
          if (!validStateIds.contains(t.fromStateId) ||
              !validStateIds.contains(t.toStateId)) {
            debugPrint(
              "⚠️ Skipping invalid DFA transition: ${t.fromStateId} -> ${t.toStateId}",
            );
            continue;
          }
          final id = "${t.fromStateId}__${t.symbol!}__${t.toStateId}";
          edges[id] = (t.fromStateId, t.symbol!, t.toStateId);
        }
      }
    }

    return edges;
  }

  @override
  Widget build(BuildContext context) {
    final graph = widget.showDfa ? widget.result.dfa : widget.result.nfa;
    final offsets =
        widget.showDfa ? widget.result.dfaOffsets : widget.result.nfaOffsets;
    final edgeIds = _buildEdgeIds(graph);

    final colorScheme = Theme.of(context).colorScheme;

    return GraphView<String, String>(
      key: ValueKey(
        "${widget.showDfa}_${graph.allStateIds.length}_${edgeIds.length}",
      ),
      rebuildAllChildrenOnWidgetUpdate: true,
      viewportController: _viewportController,
      nodeBuilder: (context, nodeId) {
        final isAccepting = graph.acceptingStateIds.contains(nodeId);
        final isInitial = nodeId == graph.initialStateId;

        assert(() {
          if (offsets[nodeId] == null) {
            debugPrint("⚠️ Missing offset for node: $nodeId");
          }
          return true;
        }());

        return NodeWidget.basic(
          position: offsets[nodeId] ?? Offset.zero,
          text: nodeId,
          isDragEnabled: false,
          style: NodeStyle(
            backgroundColor: isAccepting
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHigh,
            textStyle: TextStyle(
              color: isAccepting
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface,
              fontWeight: isInitial ? FontWeight.bold : FontWeight.normal,
            ),
            borderSide: isAccepting
                ? BorderSide(color: colorScheme.primary, width: 2)
                : isInitial
                    ? BorderSide(color: colorScheme.secondary, width: 2)
                    : BorderSide.none,
            borderRadius: const Radius.circular(24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      },
      edgeBuilder: (context, edgeId) {
        final edgeData = edgeIds[edgeId];
        if (edgeData == null) {
          debugPrint("❌ Critical: Edge ID not found in map: $edgeId");
          // Retornar un edge dummy para evitar crash
          return EdgeWidget(
            startNodeId: graph.initialStateId,
            endNodeId: graph.initialStateId,
            text: "MISSING",
            style: const EdgeStyle(
              lineColor: Colors.orange,
              textStyle: TextStyle(color: Colors.orange),
            ),
          );
        }
        final (from, label, to) = edgeData;
        // Validación adicional en runtime
        if (!graph.allStateIds.contains(from) ||
            !graph.allStateIds.contains(to)) {
          debugPrint("❌ Critical: Invalid edge at runtime: $from -> $to");
          // Retornar un edge dummy para evitar crash
          return EdgeWidget(
            startNodeId:
                graph.initialStateId, // Usar estado inicial como fallback
            endNodeId: graph.initialStateId,
            text: "ERROR",
            style: const EdgeStyle(
              lineColor: Colors.red,
              textStyle: TextStyle(color: Colors.red),
            ),
          );
        }
        return EdgeWidget(
          startNodeId: from,
          endNodeId: to,
          text: label,
          style: EdgeStyle(
            lineColor: colorScheme.outline,
            textStyle: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12,
            ),
            textBackgroundColor: colorScheme.surface,
          ),
        );
      },
    );
  }
}
