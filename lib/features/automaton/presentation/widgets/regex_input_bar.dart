import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../cubits/automaton_cubit.dart";

/// Regular expression input field
class RegexInputBar extends StatelessWidget {
  /// Regular expression input field
  const RegexInputBar({required this.controller, super.key});

  /// Text editing controller
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
