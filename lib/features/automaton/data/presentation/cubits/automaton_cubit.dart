import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/cubit_states/state_mixin.dart";

import "../../../business/entities/automaton_graph_entity.dart";

/// Automaton cubit
class AutomatonCubit extends Cubit<StateMixin<AutomatonGraphEntity>> {
  /// Automaton cubit
  AutomatonCubit() : super(StateMixin<AutomatonGraphEntity>.loading());
}
