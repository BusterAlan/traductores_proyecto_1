import "package:flutter_common_classes/constants/classes/use_case.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/languaje_failures.dart";
import "../../data/models/params/generate_dot_params.dart";

/// Convierte un AutomatonGraphEntity (NFA o DFA) a formato DOT (Graphviz).
///
/// Ejemplo de salida DOT:
/// ```
/// digraph Automaton {
///   rankdir=LR;
///   node [shape=circle];
///
///   D0 [label="D0"];
///   D1 [label="D1", shape=doublecircle];
///
///   D0 -> D1 [label="a"];
///   D1 -> D0 [label="b"];
///
///   START [shape=none];
///   START -> D0;
/// }
/// ```
class GenerateDot extends UseCase<String, GenerateDotParams> {
  /// Convierte un AutomatonGraphEntity (NFA o DFA) a formato DOT (Graphviz).
  GenerateDot();

  @override
  Either<DotGenerationFailure, String> call({
    required GenerateDotParams params,
  }) {
    try {
      final graph = params.graph;
      final buffer = StringBuffer()

        // Cabecera DOT
        ..writeln("digraph Automaton {")
        ..writeln("  rankdir=LR;")
        ..writeln("  node [shape=circle];");

      // Definir nodos
      if (graph.isNfa) {
        for (final state in graph.nfaStates) {
          final nodeShape = state.isAccepting ? "doublecircle" : "circle";
          buffer.writeln(
            '  ${state.id} [label="${state.id}", shape=$nodeShape];',
          );
        }
      } else {
        for (final state in graph.dfaStates) {
          final nodeShape = state.isAccepting ? "doublecircle" : "circle";
          buffer.writeln(
            '  ${state.id} [label="${state.id}", shape=$nodeShape];',
          );
        }
      }

      // Nodo invisible para punta de flecha inicial
      buffer
        ..writeln('  START [shape=none, label=""];')

        // Transición inicial
        ..writeln("  START -> ${graph.initialStateId};");

      // Definir transiciones
      if (graph.isNfa) {
        for (final state in graph.nfaStates) {
          for (final transition in state.transitions) {
            final label = transition.isEpsilon ? "ε" : transition.symbol!;
            buffer.writeln(
              '  ${transition.fromStateId} -> ${transition.toStateId} [label="$label"];',
            );
          }
        }
      } else {
        for (final state in graph.dfaStates) {
          for (final transition in state.transitions) {
            buffer.writeln(
              '  ${transition.fromStateId} -> ${transition.toStateId} [label="${transition.symbol!}"];',
            );
          }
        }
      }

      // Cierre
      buffer.writeln("}");

      return right(buffer.toString());
    } catch (e) {
      return left(
        DotGenerationFailure("Error generando DOT: $e"),
      );
    }
  }
}
