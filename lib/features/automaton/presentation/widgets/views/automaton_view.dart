import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/cubit_states/state_mixin.dart";
import "package:path/path.dart" as path;
import "package:path_provider/path_provider.dart";
import "package:share_plus/share_plus.dart";

import "../../../business/entities/automaton_result_entity.dart";
import "../../cubits/automaton_cubit.dart";
import "../components/regex_input_bar.dart";
import "automaton_graph_view.dart";
import "error_view.dart";
import "placeholder_view.dart";

/// Automaton view widget that contains the scaffold properties
class AutomatonView extends StatefulWidget {
  /// Automaton view widget that contains the scaffold properties
  const AutomatonView({super.key});

  @override
  State<AutomatonView> createState() => _AutomatonViewState();
}

class _AutomatonViewState extends State<AutomatonView> {
  final _controller = TextEditingController();
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
                  icon: const Icon(Icons.share_outlined),
                  tooltip: "Compartir DOT",
                  onPressed: () => _shareDot(context, state.data!),
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

  /// Escribe el DOT en un archivo temporal y lo comparte via share sheet.
  /// Funciona en Android físico, iOS y desktop sin permisos especiales.
  Future<void> _shareDot(
    BuildContext context,
    AutomatonResultEntity data,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final graph = _showDfa ? data.dfa : data.nfa;
    final result = context.read<AutomatonCubit>().generateDot(graph);

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      messenger.showSnackBar(
        SnackBar(content: Text("Error generando DOT: ${failure.message}")),
      );
      return;
    }

    final dot = result.getRight().toNullable()!;

    // Usar el directorio temporal — siempre disponible, no requiere permisos
    final tempDir = await getTemporaryDirectory();
    final fileName =
        "automaton_${_showDfa ? 'dfa' : 'nfa'}_${DateTime.now().millisecondsSinceEpoch}.dot";
    final file = File(path.join(tempDir.path, fileName));

    try {
      await file.writeAsString(dot);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("No se pudo crear el archivo: $e")),
      );
      return;
    }

    if (!context.mounted) {
      return;
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: "text/plain")],
        subject: "Autómata ${_showDfa ? 'DFA' : 'NFA'} — $fileName",
      ),
    );
  }
}
