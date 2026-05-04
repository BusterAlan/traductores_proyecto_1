import "package:flutter_common_classes/constants/classes/params.dart";

import "../../../business/entities/automaton_graph_entity.dart";

/// Parámetros para el use case GenerateDot.
class GenerateDotParams extends Params {
  /// Parámetros para el use case GenerateDot.
  const GenerateDotParams({required this.graph});

  /// Autómata (NFA o DFA) a convertir a DOT.
  final AutomatonGraphEntity graph;
}
