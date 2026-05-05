import "package:flutter/material.dart";
import "package:interactive_graph_view/interactive_graph_view.dart";

import "../../../business/entities/automaton_graph_entity.dart";
import "../views/automaton_graph_view.dart";

/// Mixin para compartir lógica común del GraphViewportController
mixin AutomatonGraphMixin<T extends StatefulWidget> on State<T> {
  /// Graph view port controller for the Graph View
  late GraphViewportController<String, String> viewportController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    final widgetValue = widget as AutomatonGraphView;

    final graph =
        widgetValue.showDfa ? widgetValue.result.dfa : widgetValue.result.nfa;
    final nodeIds = graph.allStateIds;
    final edgeIds = buildEdgeIds(graph);

    viewportController = GraphViewportController(
      initialNodeIds: nodeIds,
      initialEdgeIds: edgeIds.keys,
    );
  }

  @override
  void didUpdateWidget(T oldWidget) {
    oldWidget as AutomatonGraphView;
    final widgetValue = widget as AutomatonGraphView;

    super.didUpdateWidget(oldWidget);
    // Si cambió el grafo (NFA ↔ DFA o nueva regex), reiniciamos el controller
    if (oldWidget.result != widgetValue.result ||
        oldWidget.showDfa != widgetValue.showDfa) {
      // Forzar reconstrucción completa del controller
      viewportController = GraphViewportController(
        initialNodeIds: const [], // Empezar vacío
        initialEdgeIds: const [],
      );
      _initController(); // Inicializar con los nuevos datos
    }
  }

  /// Construye IDs únicos para cada transición del grafo.
  /// Formato: "fromId__symbol__toId" (doble guión para evitar colisiones).
  Map<String, (String from, String symbol, String to)> buildEdgeIds(
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
}
