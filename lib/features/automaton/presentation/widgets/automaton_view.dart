import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/cubit_states/state_mixin.dart";

import "../../business/entities/automaton_result_entity.dart";
import "../cubits/automaton_cubit.dart";
import "automaton_graph_view.dart";
import "error_view.dart";
import "placeholder_view.dart";
import "regex_input_bar.dart";

/// Automaton view
class AutomatonView extends StatefulWidget {
  /// Automaton view
  const AutomatonView({super.key});

  @override
  State<AutomatonView> createState() => _AutomatonViewState();
}

class _AutomatonViewState extends State<AutomatonView> {
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
                IconButton(
                  icon: const Icon(Icons.download_outlined),
                  tooltip: "Copiar DOT",
                  onPressed: () => _copyDot(context, state.data!),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
          body: Column(
            children: [
              RegexInputBar(
                controller: _controller,
                errorText: state.status == WidgetStatus.failure
                    ? state.failure?.message
                    : null,
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
        ),
      );

  Widget _buildBody(
    BuildContext context,
    StateMixin<AutomatonResultEntity> state,
  ) =>
      switch (state.status) {
        WidgetStatus.initial => const PlaceholderView(
            icon: Icons.account_tree_outlined,
            message: "Ingresa una expresión regular para comenzar",
          ),
        WidgetStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
        WidgetStatus.success => AutomatonGraphView(
            result: state.data!,
            showDfa: _showDfa,
          ),
        WidgetStatus.failure => ErrorView(failure: state.failure!.message),
        WidgetStatus.empty => const PlaceholderView(
            icon: Icons.warning_amber_outlined,
            message: "El autómata resultante está vacío",
          ),
      };

  Future<void> _copyDot(
    BuildContext context,
    AutomatonResultEntity data,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final graph = _showDfa ? data.dfa : data.nfa;
    final result = context.read<AutomatonCubit>().generateDot(graph);

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      messenger.showSnackBar(
        SnackBar(
          content: Text("Error exportando DOT: ${failure.message}"),
        ),
      );
      return;
    }

    final dot = result.getRight().toNullable()!;
    await Clipboard.setData(ClipboardData(text: dot));
    if (!mounted) {
      return;
    }

    messenger.showSnackBar(
      const SnackBar(content: Text("DOT copiado al portapapeles")),
    );
  }
}
