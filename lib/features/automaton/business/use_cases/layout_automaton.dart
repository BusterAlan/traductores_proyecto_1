import "package:flutter/material.dart" show debugPrint;
import "package:flutter/painting.dart";
import "package:flutter_common_classes/constants/classes/use_case.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/languaje_failures.dart";
import "../../data/models/params/layout_automaton_params.dart";
import "../entities/transition_entity.dart";

/// Calcula las posiciones [Offset] de cada estado del autómata
/// usando un layout por niveles (BFS) de izquierda a derecha.
///
/// El resultado es un [Map] de stateId → [Offset] listo para
/// ser consumido directamente por [NodeWidget.basic] de
/// interactive_graph_view.
///
/// Ejemplo de output para `(a|b)*abb` con 5 estados DFA:
/// ```
/// {
///   "D0": Offset(0, 0),
///   "D1": Offset(200, -100),
///   "D2": Offset(200, 100),
///   "D3": Offset(400, -100),
///   "D4": Offset(600, 0),
/// }
/// ```
class LayoutAutomaton
    extends UseCase<Map<String, Offset>, LayoutAutomatonParams> {
  /// Constructor
  LayoutAutomaton({
    this.horizontalSpacing = 200.0,
    this.verticalSpacing = 120.0,
  });

  /// Distancia horizontal entre niveles (columnas).
  final double horizontalSpacing;

  /// Distancia vertical entre estados dentro del mismo nivel.
  final double verticalSpacing;

  @override
  Either<DotGenerationFailure, Map<String, Offset>> call({
    required LayoutAutomatonParams params,
  }) {
    try {
      if (params.graph.isNfa) {
        return right(
          _computeLayout(
            initialStateId: params.graph.initialStateId,
            allStateIds: params.graph.nfaStates.map((s) => s.id).toSet(),
            getTransitions: (id) => params.graph.nfaStates
                .firstWhere((s) => s.id == id)
                .transitions,
          ),
        );
      }

      return right(
        _computeLayout(
          initialStateId: params.graph.initialStateId,
          allStateIds: params.graph.dfaStates.map((s) => s.id).toSet(),
          getTransitions: (id) =>
              params.graph.dfaStates.firstWhere((s) => s.id == id).transitions,
        ),
      );
    } catch (e) {
      return left(DotGenerationFailure("Error calculando layout: $e"));
    }
  }

  // ── BFS por niveles ────────────────────────────────────────────────────────

  Map<String, Offset> _computeLayout({
    required String initialStateId,
    required Set<String> allStateIds,
    required List<TransitionEntity> Function(String stateId) getTransitions,
  }) {
    // Nivel de cada estado: nivel 0 = estado inicial
    final levels = <String, int>{};
    final queue = <String>[initialStateId];
    levels[initialStateId] = 0;

    // BFS para asignar niveles
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      final currentLevel = levels[current]!;

      for (final t in getTransitions(current)) {
        // Solo procesar transiciones a estados válidos
        if (!allStateIds.contains(t.toStateId)) {
          debugPrint(
            "⚠️ Layout: Skipping transition to invalid state: ${t.toStateId}",
          );
          continue;
        }
        if (!levels.containsKey(t.toStateId)) {
          levels[t.toStateId] = currentLevel + 1;
          queue.add(t.toStateId);
        }
      }
    }

    // Estados no alcanzables desde el inicial → nivel máximo + 1
    final maxLevel = levels.values.isEmpty
        ? 0
        : levels.values.reduce((a, b) => a > b ? a : b);
    for (final id in allStateIds) {
      levels.putIfAbsent(id, () => maxLevel + 1);
    }

    // Agrupar estados por nivel
    final byLevel = <int, List<String>>{};
    for (final entry in levels.entries) {
      byLevel.putIfAbsent(entry.value, () => []).add(entry.key);
    }

    // Calcular Offsets: x por nivel, y centrado dentro del nivel
    final offsets = <String, Offset>{};

    for (final levelEntry in byLevel.entries) {
      final level = levelEntry.key;
      final statesInLevel = levelEntry.value;
      final count = statesInLevel.length;

      // Altura total del nivel, centrada en y=0
      final totalHeight = (count - 1) * verticalSpacing;
      final startY = -totalHeight / 2;

      for (int i = 0; i < count; i++) {
        offsets[statesInLevel[i]] = Offset(
          level * horizontalSpacing,
          startY + i * verticalSpacing,
        );
      }
    }

    return offsets;
  }
}
