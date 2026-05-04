import "package:flutter_common_classes/constants/classes/use_case.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/languaje_failures.dart";
import "../../data/models/params/convert_to_dfa_params.dart";
import "../entities/automaton_graph_entity.dart";
import "../entities/dfa_state_entity.dart";
import "../entities/nfa_state_entity.dart";
import "../entities/transition_entity.dart";

/// Convierte un NFA a DFA usando la construcción de subconjuntos.
///
/// Cada estado del DFA representa un CONJUNTO de estados del NFA.
/// El algoritmo expande iterativamente los subconjuntos accesibles
/// hasta que no queden subconjuntos nuevos por procesar.
class ConvertToDfa extends UseCase<AutomatonGraphEntity, ConvertToDfaParams> {
  /// Constructor
  ConvertToDfa();

  @override
  Either<DfaConversionFailure, AutomatonGraphEntity> call({
    required ConvertToDfaParams params,
  }) {
    try {
      if (!params.graph.isNfa) {
        return left(
          DfaConversionFailure(
            "El grafo recibido no es un NFA.",
          ),
        );
      }

      // Índice rápido: id → NfaStateEntity
      final nfaIndex = {for (final s in params.graph.nfaStates) s.id: s};

      // ── Paso 1: ε-cerradura del estado inicial ──────────────────────────
      final initialClosure =
          _epsilonClosure({params.graph.initialStateId}, nfaIndex);

      // ── Paso 2: construcción iterativa de subconjuntos ──────────────────
      // Mapeamos cada subconjunto (Set<String>) a su ID de estado DFA.
      final subsetToId = <String, String>{}; // key = _keyOf(subset)
      final dfaStates = <String, DfaStateEntity>{};

      var counter = 0;
      String newDfaId() => "D${counter++}";

      // Cola de subconjuntos pendientes de procesar
      final queue = <Set<String>>[initialClosure];
      final seen = <String>{}; // keys ya encolados

      final initialId = newDfaId();
      subsetToId[_keyOf(initialClosure)] = initialId;
      seen.add(_keyOf(initialClosure));

      while (queue.isNotEmpty) {
        final subset = queue.removeAt(0);
        final dfaId = subsetToId[_keyOf(subset)]!;

        final transitions = <TransitionEntity>[];

        // Para cada símbolo del alfabeto, calculamos el subconjunto destino
        for (final symbol in params.graph.alphabet) {
          // move(subset, symbol) — estados NFA alcanzables con symbol
          final moved = _move(subset, symbol, nfaIndex);
          if (moved.isEmpty) {
            continue;
          }

          // ε-cerradura del conjunto resultante
          final closure = _epsilonClosure(moved, nfaIndex);
          final closureKey = _keyOf(closure);

          // Si es un subconjunto nuevo, le asignamos ID y lo encolamos
          if (!seen.contains(closureKey)) {
            seen.add(closureKey);
            subsetToId[closureKey] = newDfaId();
            queue.add(closure);
          }

          final targetId = subsetToId[closureKey]!;
          transitions.add(
            TransitionEntity(
              fromStateId: dfaId,
              toStateId: targetId,
              symbol: symbol,
            ),
          );
        }

        // Un estado DFA es de aceptación si contiene algún estado NFA aceptador
        final isAccepting = subset.any(
          (nfaId) => nfaIndex[nfaId]?.isAccepting ?? false,
        );

        dfaStates[dfaId] = DfaStateEntity(
          id: dfaId,
          isAccepting: isAccepting,
          nfaStateIds: subset,
          transitions: transitions,
        );
      }

      final acceptingIds =
          dfaStates.values.where((s) => s.isAccepting).map((s) => s.id).toSet();

      return right(
        AutomatonGraphEntity.dfa(
          initialStateId: initialId,
          acceptingStateIds: acceptingIds,
          alphabet: params.graph.alphabet,
          dfaStates: dfaStates.values.toList(),
        ),
      );
    } on DfaConversionFailure catch (e) {
      return left(e);
    } catch (e) {
      return left(DfaConversionFailure("Error inesperado: $e"));
    }
  }

  // ── Algoritmos auxiliares ─────────────────────────────────────────────────

  /// ε-cerradura de un conjunto de estados NFA.
  ///
  /// Expande recursivamente todos los estados alcanzables
  /// solo con transiciones ε desde [states].
  Set<String> _epsilonClosure(
    Set<String> states,
    Map<String, NfaStateEntity> index,
  ) {
    final closure = <String>{...states};
    final stack = [...states];

    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      final epsilonTargets = index[current]?.epsilonTargets ?? [];

      for (final target in epsilonTargets) {
        if (!closure.contains(target)) {
          closure.add(target);
          stack.add(target);
        }
      }
    }

    return closure;
  }

  /// move(states, symbol) — estados NFA alcanzables consumiendo [symbol]
  /// desde cualquier estado en [states].
  Set<String> _move(
    Set<String> states,
    String symbol,
    Map<String, NfaStateEntity> index,
  ) =>
      {
        for (final id in states) ...index[id]?.targetsOn(symbol) ?? [],
      };

  /// Convierte un conjunto de IDs en una key canónica reproducible.
  /// Ordenar garantiza que {q0,q1} y {q1,q0} produzcan la misma key.
  String _keyOf(Set<String> states) {
    final sorted = states.toList()..sort();
    return sorted.join(",");
  }
}
