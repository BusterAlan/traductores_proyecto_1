import "package:flutter_common_classes/constants/classes/params.dart";

import "../../../business/entities/automaton_graph_entity.dart";

/// Parameters used to convert to dfa for use case
class ConvertToDfaParams extends Params {
  /// Parameters used to convert to dfa for use case
  ConvertToDfaParams({required this.graph});

  /// Graph value
  final AutomatonGraphEntity graph;
}
