import "package:flutter_common_classes/constants/classes/use_case.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/languaje_failures.dart";
import "../../data/models/params/build_nfa_params.dart";
import "../compiler/ast/base_node.dart";
import "../compiler/ast/nodes.dart";
import "../entities/automaton_graph_entity.dart";
import "../entities/nfa_state_entity.dart";
import "../entities/transition_entity.dart";

/// Construye un NFA a partir de un AST de expresión regular
/// usando la construcción de Thompson.
///
/// Cada nodo del AST se convierte en un fragmento NFA con
/// exactamente un estado de entrada y uno de salida.
/// Los fragmentos se ensamblan recursivamente según el operador.
class BuildNfa extends UseCase<AutomatonGraphEntity, BuildNfaParams> {
  /// Constructor
  BuildNfa();

  /// Punto de entrada público.
  /// Recibe la expresión ya parseada y retorna el grafo NFA completo.
  @override
  Either<LanguageFailure, AutomatonGraphEntity> call({
    required BuildNfaParams params,
  }) {
    try {
      _counter = 0;
      final fragment = _build(params.ast);

      // Recopilamos todos los estados del fragmento en una lista plana
      final states = _collectStates(fragment);

      return right(
        AutomatonGraphEntity.nfa(
          initialStateId: fragment.start,
          acceptingStateIds: {fragment.end},
          alphabet: params.expression.alphabet,
          nfaStates: states,
        ),
      );
    } on _ThompsonException catch (e) {
      return left(NfaBuildFailure(e.message));
    } catch (e) {
      return left(NfaBuildFailure("Error inesperado: $e"));
    }
  }

  // ── Contador de IDs únicos ───────────────────────────────────────────────

  int _counter = 0;

  String _newId() => "q${_counter++}";

  // ── Núcleo recursivo ─────────────────────────────────────────────────────

  /// Convierte un nodo del AST en un fragmento NFA.
  _NfaFragment _build(RegexNode node) => switch (node) {
        final CharNode n => _buildChar(n),
        final ConcatNode n => _buildConcat(n),
        final OrNode n => _buildOr(n),
        final StarNode n => _buildStar(n),
        final PlusNode n => _buildPlus(n),
        final QuestionNode n => _buildQuestion(n),
        _ => throw _ThompsonException("Nodo desconocido: ${node.runtimeType}"),
      };

  // ── Casos base y compuestos ──────────────────────────────────────────────

  /// CharNode → dos estados conectados por el símbolo literal.
  ///
  /// (start) --'a'--> (end)
  _NfaFragment _buildChar(CharNode node) {
    final start = _newId();
    final end = _newId();

    return _NfaFragment(
      start: start,
      end: end,
      states: {
        start: NfaStateEntity(
          id: start,
          transitions: [
            TransitionEntity(
              fromStateId: start,
              toStateId: end,
              symbol: node.value,
            ),
          ],
        ),
        end: NfaStateEntity(id: end),
      },
    );
  }

  /// ConcatNode → conecta la salida de A con la entrada de B via ε.
  ///
  /// [A.start] → ... → [A.end] --ε--> [B.start] → ... → [B.end]
  _NfaFragment _buildConcat(ConcatNode node) {
    final a = _build(node.left);
    final b = _build(node.right);

    // Agregamos ε-transición del final de A al inicio de B
    final aEndUpdated = a.states[a.end]!.copyWith(
      transitions: [
        ...a.states[a.end]!.transitions,
        TransitionEntity(fromStateId: a.end, toStateId: b.start),
      ],
    );

    return _NfaFragment(
      start: a.start,
      end: b.end,
      states: {
        ...a.states,
        a.end: aEndUpdated,
        ...b.states,
      },
    );
  }

  /// OrNode → nuevo inicio que bifurca con ε hacia A y B;
  /// ambos convergen con ε a un nuevo estado final.
  ///
  ///        ε→ [A] →ε
  /// (start)          (end)
  ///        ε→ [B] →ε
  _NfaFragment _buildOr(OrNode node) {
    final a = _build(node.left);
    final b = _build(node.right);

    final start = _newId();
    final end = _newId();

    // Estado inicial: bifurca hacia A y B
    final startState = NfaStateEntity(
      id: start,
      transitions: [
        TransitionEntity(fromStateId: start, toStateId: a.start),
        TransitionEntity(fromStateId: start, toStateId: b.start),
      ],
    );

    // Finales de A y B: convergen al nuevo estado final
    final aEndUpdated = a.states[a.end]!.copyWith(
      transitions: [
        ...a.states[a.end]!.transitions,
        TransitionEntity(fromStateId: a.end, toStateId: end),
      ],
    );
    final bEndUpdated = b.states[b.end]!.copyWith(
      transitions: [
        ...b.states[b.end]!.transitions,
        TransitionEntity(fromStateId: b.end, toStateId: end),
      ],
    );

    return _NfaFragment(
      start: start,
      end: end,
      states: {
        start: startState,
        ...a.states,
        a.end: aEndUpdated,
        ...b.states,
        b.end: bEndUpdated,
        end: NfaStateEntity(id: end), // → cero o más repeticiones.
      },
    );
  }

  /// StarNode → cero o más repeticiones.
  ///
  /// (start) →ε→ [A] →ε→ (end)
  ///    ↑_________ε________|
  ///    └────────────────────ε──→ (end)   ← bypass
  _NfaFragment _buildStar(StarNode node) {
    final a = _build(node.node);

    final start = _newId();
    final end = _newId();

    final startState = NfaStateEntity(
      id: start,
      transitions: [
        TransitionEntity(fromStateId: start, toStateId: a.start), // entrar a A
        TransitionEntity(fromStateId: start, toStateId: end), // bypass
      ],
    );

    final aEndUpdated = a.states[a.end]!.copyWith(
      transitions: [
        ...a.states[a.end]!.transitions,
        TransitionEntity(fromStateId: a.end, toStateId: a.start), // loop
        TransitionEntity(fromStateId: a.end, toStateId: end), // salir
      ],
    );

    return _NfaFragment(
      start: start,
      end: end,
      states: {
        start: startState,
        ...a.states,
        a.end: aEndUpdated,
        end: NfaStateEntity(id: end),
      },
    );
  }

  /// PlusNode → una o más repeticiones (sin bypass inicial).
  ///
  /// (start) →ε→ [A] →ε→ (end)
  ///               ↑___ε___|
  _NfaFragment _buildPlus(PlusNode node) {
    final a = _build(node.node);

    final start = _newId();
    final end = _newId();

    // Sin bypass: obligatorio pasar por A al menos una vez
    final startState = NfaStateEntity(
      id: start,
      transitions: [
        TransitionEntity(fromStateId: start, toStateId: a.start),
      ],
    );

    final aEndUpdated = a.states[a.end]!.copyWith(
      transitions: [
        ...a.states[a.end]!.transitions,
        TransitionEntity(fromStateId: a.end, toStateId: a.start), // loop
        TransitionEntity(fromStateId: a.end, toStateId: end), // salir
      ],
    );

    return _NfaFragment(
      start: start,
      end: end,
      states: {
        start: startState,
        ...a.states,
        a.end: aEndUpdated,
        end: NfaStateEntity(id: end),
      },
    );
  }

  /// QuestionNode → cero o una ocurrencia.
  ///
  /// (start) →ε→ [A] →ε→ (end)
  ///    └──────────────ε──→ (end)   ← bypass
  _NfaFragment _buildQuestion(QuestionNode node) {
    final a = _build(node.node);

    final start = _newId();
    final end = _newId();

    final startState = NfaStateEntity(
      id: start,
      transitions: [
        TransitionEntity(fromStateId: start, toStateId: a.start), // entrar
        TransitionEntity(fromStateId: start, toStateId: end), // bypass
      ],
    );

    final aEndUpdated = a.states[a.end]!.copyWith(
      transitions: [
        ...a.states[a.end]!.transitions,
        TransitionEntity(
          fromStateId: a.end,
          toStateId: end,
        ), // salir (sin loop)
      ],
    );

    return _NfaFragment(
      start: start,
      end: end,
      states: {
        start: startState,
        ...a.states,
        a.end: aEndUpdated,
        end: NfaStateEntity(id: end),
      },
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Convierte el mapa de estados del fragmento a lista plana,
  /// marcando correctamente el estado de aceptación.
  List<NfaStateEntity> _collectStates(_NfaFragment fragment) =>
      fragment.states.entries.map((entry) {
        final isAccepting = entry.key == fragment.end;
        return entry.value.copyWith(isAccepting: isAccepting);
      }).toList();
}

// ── Tipos internos ─────────────────────────────────────────────────────────

/// Fragmento NFA intermedio durante la construcción de Thompson.
/// Contiene el ID del estado inicial, el final, y un mapa de todos los estados.
class _NfaFragment {
  const _NfaFragment({
    required this.start,
    required this.end,
    required this.states,
  });

  final String start;
  final String end;

  /// Mapa id → estado. Facilita el acceso y la actualización por ID.
  final Map<String, NfaStateEntity> states;
}

/// Excepción interna para errores durante la construcción.
class _ThompsonException implements Exception {
  const _ThompsonException(this.message);
  final String message;
}
