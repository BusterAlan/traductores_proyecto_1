import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../cubits/automaton_cubit.dart";

/// Regular expression input field with auto-closing parentheses support
class RegexInputBar extends StatefulWidget {
  /// Regular expression input field with auto-closing parentheses support
  const RegexInputBar({
    required this.controller,
    this.errorText,
    super.key,
  });

  /// Text editing controller
  final TextEditingController controller;

  /// Error text shown below the input when the regex fails validation.
  final String? errorText;

  @override
  State<RegexInputBar> createState() => _RegexInputBarState();
}

class _RegexInputBarState extends State<RegexInputBar> {
  late TextEditingController _controller;
  bool _ignoreNextChange = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Maneja el auto-cierre de paréntesis y el comportamiento de backspace.
  void _onTextChange(String newText) {
    if (_ignoreNextChange) {
      _ignoreNextChange = false;
      return;
    }

    final oldText = _controller.text;
    final cursorPos = _controller.selection.baseOffset;

    // Caso: usuario tipea `(`
    if (newText.length == oldText.length + 1 && newText[cursorPos - 1] == "(") {
      _ignoreNextChange = true;
      _controller.text = newText.replaceRange(cursorPos, cursorPos, ")");
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPos),
      );
    }
    // Caso: usuario borra un `(` y queremos también borrar el `)` correspondiente
    else if (newText.length == oldText.length - 1) {
      final deletedChar = oldText[cursorPos];
      if (deletedChar == "(" && cursorPos < oldText.length - 1) {
        final nextChar = oldText[cursorPos + 1];
        if (nextChar == ")") {
          _ignoreNextChange = true;
          _controller.text = newText.replaceRange(cursorPos, cursorPos + 1, "");
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPos),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _onTextChange,
                decoration: InputDecoration(
                  labelText: "Expresión regular",
                  hintText: "ej: (a|b)*abb",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.code),
                  errorText: widget.errorText,
                ),
                onSubmitted: (value) =>
                    context.read<AutomatonCubit>().buildAutomaton(value),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () => context
                  .read<AutomatonCubit>()
                  .buildAutomaton(_controller.text),
              icon: const Icon(Icons.play_arrow),
              label: const Text("Generar"),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                _controller.clear();
                context.read<AutomatonCubit>().reset();
              },
              icon: const Icon(Icons.clear),
              tooltip: "Limpiar",
            ),
          ],
        ),
      );
}
