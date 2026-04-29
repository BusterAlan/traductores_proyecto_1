import "package:equatable/equatable.dart";

import "transition_entity.dart";

/// Estado de un Autómata Finito Determinista.
/// Cada símbolo del alfabeto tiene como máximo una transición saliente.
/// No admite ε-transiciones.
///
/// La igualdad se basa únicamente en [id].
class DfaStateEntity extends Equatable {
  /// Estado de un Autómata Finito Determinista.
  /// Cada símbolo del alfabeto tiene como máximo una transición saliente.
  /// No admite ε-transiciones.
  ///
  /// La igualdad se basa únicamente en [id].
  const DfaStateEntity({
    required this.id,
    this.isAccepting = false,
    this.nfaStateIds = const {},
    this.transitions = const [],
  });

  /// Identifier value
  final String id;

  /// If state is accepting
  final bool isAccepting;

  /// Los estados NFA que este estado DFA representa (subconjunto).
  /// Útil para trazabilidad y para mostrar la construcción de subconjuntos.
  final Set<String> nfaStateIds;

  /// List of transitions value
  final List<TransitionEntity> transitions;

  /// Devuelve el único estado destino para [symbol], o null si no existe.
  String? targetOn(String symbol) {
    final matches = transitions.where((t) => t.symbol == symbol);
    return matches.isEmpty ? null : matches.first.toStateId;
  }

  /// TODO: Move into a mapper with copyWith available
  DfaStateEntity copyWith({
    String? id,
    bool? isAccepting,
    Set<String>? nfaStateIds,
    List<TransitionEntity>? transitions,
  }) =>
      DfaStateEntity(
        id: id ?? this.id,
        isAccepting: isAccepting ?? this.isAccepting,
        nfaStateIds: nfaStateIds ?? this.nfaStateIds,
        transitions: transitions ?? this.transitions,
      );

  @override
  List<Object?> get props => [id];

  @override
  String toString() => "DfaState($id, accepting: $isAccepting)";
}
