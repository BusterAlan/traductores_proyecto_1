import "package:flutter_common_classes/constants/classes/params.dart";

import "../../../business/entities/automaton_graph_entity.dart";

/// Layout automaton params values to use case
class LayoutAutomatonParams extends Params {
  /// Layout automaton params values to use case
  LayoutAutomatonParams({required this.graph});

  /// Graph value
  final AutomatonGraphEntity graph;
}
