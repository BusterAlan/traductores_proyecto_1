import "package:equatable/equatable.dart";

import "dfa_state_entity.dart";
import "nfa_state_entity.dart";

/// Tipo de autómata representado.
enum AutomatonType {
  /// Non-deterministic finite automaton 
  nfa,
  /// Deterministic finite automaton
  dfa 
}

/// Grafo de autómata listo para ser consumido por el generador DOT
/// y por el visualizador de Flutter.
///
/// Contiene exactamente uno de [nfaStates] o [dfaStates] según [type].
class AutomatonGraphEntity extends Equatable {
  /// Grafo de autómata listo para ser consumido por el generador DOT
  /// y por el visualizador de Flutter.
  ///
  /// Contiene exactamente uno de [nfaStates] o [dfaStates] según [type].
  const AutomatonGraphEntity.nfa({
    required this.initialStateId,
    required this.acceptingStateIds,
    required this.alphabet,
    required this.nfaStates,
  })  : type = AutomatonType.nfa,
        dfaStates = const [];

  /// Grafo de autómata listo para ser consumido por el generador DOT
  /// y por el visualizador de Flutter.
  ///
  /// Contiene exactamente uno de [nfaStates] o [dfaStates] según [type].
  const AutomatonGraphEntity.dfa({
    required this.initialStateId,
    required this.acceptingStateIds,
    required this.alphabet,
    required this.dfaStates,
  })  : type = AutomatonType.dfa,
        nfaStates = const [];

  /// Automaton type value
  final AutomatonType type;

  /// Initial state identifier value
  final String initialStateId;

  /// Accepting state identifiers value
  final Set<String> acceptingStateIds;

  /// Alphabet value
  final Set<String> alphabet;

  // Solo uno de estos dos estará poblado:
  
  /// Nfa states value
  final List<NfaStateEntity> nfaStates;

  /// Dfa states value
  final List<DfaStateEntity> dfaStates;

  /// Getter to know if automaton is NFA
  bool get isNfa => type == AutomatonType.nfa;

  /// Getter to know if automaton is DFA
  bool get isDfa => type == AutomatonType.dfa;

  /// Todos los IDs de estado presentes en el grafo.
  Set<String> get allStateIds {
    if (isNfa) {
      return nfaStates.map((s) => s.id).toSet();
    }
    return dfaStates.map((s) => s.id).toSet();
  }

  @override
  List<Object?> get props => [
        type,
        initialStateId,
        acceptingStateIds,
        alphabet,
        nfaStates,
        dfaStates,
      ];

  @override
  String toString() =>
      "AutomatonGraph(type: $type, states: ${allStateIds.length}, "
      "alphabet: $alphabet)";
}
