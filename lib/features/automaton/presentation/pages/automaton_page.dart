import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/cubit_states/state_mixin.dart";
import "package:interactive_graph_view/interactive_graph_view.dart";

import "../../business/entities/automaton_graph_entity.dart";
import "../../business/entities/automaton_result_entity.dart";
import "../cubits/automaton_cubit.dart";

/// Página principal del visualizador de autómatas.
@RoutePage()
class AutomatonPage extends StatelessWidget {
  /// Página principal del visualizador de autómatas.
  const AutomatonPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AutomatonCubit(),
        child: const _AutomatonView(),
      );
}

class _AutomatonView extends StatefulWidget {
  const _AutomatonView();

  @override
  State<_AutomatonView> createState() => _AutomatonViewState();
}

class _AutomatonViewState extends State<_AutomatonView> {
  final _controller = TextEditingController();

  // Controla qué grafo se muestra: NFA o DFA
  bool _showDfa = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AutomatonCubit, StateMixin<AutomatonResultEntity>>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text("Visualizador de Autómatas"),
            actions: [
              if (state.status == WidgetStatus.success) ...[
                Text(
                  _showDfa ? "DFA" : "NFA",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Switch(
                  value: _showDfa,
                  onChanged: (_) => setState(() => _showDfa = !_showDfa),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
          body: Column(
            children: [
              _RegexInputBar(controller: _controller),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
        ),
      );

  Widget _buildBody(
          BuildContext context, StateMixin<AutomatonResultEntity> state) =>
      switch (state.status) {
        WidgetStatus.initial => const _PlaceholderView(
            icon: Icons.account_tree_outlined,
            message: "Ingresa una expresión regular para comenzar",
          ),
        WidgetStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
        WidgetStatus.success => _AutomatonGraphView(
            result: state.data!,
            showDfa: _showDfa,
          ),
        WidgetStatus.failure => _ErrorView(failure: state.failure!.message),
        WidgetStatus.empty => const _PlaceholderView(
            icon: Icons.warning_amber_outlined,
            message: "El autómata resultante está vacío",
          ),
      };
}

// ── Barra de input ────────────────────────────────────────────────────────────

class _RegexInputBar extends StatelessWidget {
  const _RegexInputBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "Expresión regular",
                  hintText: "ej: (a|b)*abb",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
                onSubmitted: (value) =>
                    context.read<AutomatonCubit>().buildAutomaton(value),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () => context
                  .read<AutomatonCubit>()
                  .buildAutomaton(controller.text),
              icon: const Icon(Icons.play_arrow),
              label: const Text("Generar"),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                controller.clear();
                context.read<AutomatonCubit>().reset();
              },
              icon: const Icon(Icons.clear),
              tooltip: "Limpiar",
            ),
          ],
        ),
      );
}

// ── Visualizador del grafo ────────────────────────────────────────────────────

class _AutomatonGraphView extends StatefulWidget {
  const _AutomatonGraphView({
    required this.result,
    required this.showDfa,
  });

  final AutomatonResultEntity result;
  final bool showDfa;

  @override
  State<_AutomatonGraphView> createState() => _AutomatonGraphViewState();
}

class _AutomatonGraphViewState extends State<_AutomatonGraphView> {
  late GraphViewportController<String, String> _viewportController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(_AutomatonGraphView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambió el grafo (NFA ↔ DFA o nueva regex), reiniciamos el controller
    if (oldWidget.result != widget.result ||
        oldWidget.showDfa != widget.showDfa) {
      _initController();
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

    if (graph.isNfa) {
      for (final state in graph.nfaStates) {
        for (final t in state.transitions) {
          final label = t.isEpsilon ? "ε" : t.symbol!;
          final id = "${t.fromStateId}__${label}__${t.toStateId}";
          edges[id] = (t.fromStateId, label, t.toStateId);
        }
      }
    } else {
      for (final state in graph.dfaStates) {
        for (final t in state.transitions) {
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
      rebuildAllChildrenOnWidgetUpdate: true,
      viewportController: _viewportController,
      nodeBuilder: (context, nodeId) {
        final isAccepting = graph.acceptingStateIds.contains(nodeId);
        final isInitial = nodeId == graph.initialStateId;

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
        final (from, label, to) = edgeIds[edgeId]!;
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

// ── Vistas auxiliares ─────────────────────────────────────────────────────────

class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.failure});

  final String failure;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                failure,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
