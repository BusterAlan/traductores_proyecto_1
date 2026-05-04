import "package:flutter/painting.dart";

import "../../business/entities/automaton_graph_entity.dart";

/// Resultado completo del pipeline regex → autómata → layout.
/// Es el dato que el Cubit entrega a la UI en estado success.
class AutomatonResultEntity {
  /// Resultado completo del pipeline regex → autómata → layout.
  const AutomatonResultEntity({
    required this.nfa,
    required this.dfa,
    required this.nfaOffsets,
    required this.dfaOffsets,
  });

  /// NFA construido con Thompson's Construction.
  final AutomatonGraphEntity nfa;

  /// DFA construido con construcción de subconjuntos.
  final AutomatonGraphEntity dfa;

  /// Posiciones de cada estado del NFA para el visualizador.
  final Map<String, Offset> nfaOffsets;

  /// Posiciones de cada estado del DFA para el visualizador.
  final Map<String, Offset> dfaOffsets;
}
