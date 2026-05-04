import "package:equatable/equatable.dart";

import "transition_entity.dart";

/// Estado de un Autómata Finito No Determinista.
/// Puede tener múltiples transiciones con el mismo símbolo
/// y transiciones ε (epsilon).
///
/// La igualdad se basa únicamente en [id] — dos estados con el mismo
/// id son el mismo estado, independientemente de sus transiciones.
class NfaStateEntity extends Equatable {
  /// Estado de un Autómata Finito No Determinista.
  /// Puede tener múltiples transiciones con el mismo símbolo
  /// y transiciones ε (epsilon).
  ///
  /// La igualdad se basa únicamente en [id] — dos estados con el mismo
  /// id son el mismo estado, independientemente de sus transiciones.
  const NfaStateEntity({
    required this.id,
    this.isAccepting = false,
    this.transitions = const [],
  });

  /// Identifier value
  final String id;

  /// Boolean flag if its accepting
  final bool isAccepting;

  /// List of transitions
  final List<TransitionEntity> transitions;

  /// Devuelve los estados destino alcanzables con [symbol] desde este estado.
  List<String> targetsOn(String symbol) => transitions
      .where((t) => t.symbol == symbol)
      .map((t) => t.toStateId)
      .toList();

  /// Devuelve los estados destino alcanzables por ε desde este estado.
  List<String> get epsilonTargets => transitions
      .where((t) => t.isEpsilon)
      .map((t) => t.toStateId)
      .toList();

  /// Copy with method helper
  NfaStateEntity copyWith({
    String? id,
    bool? isAccepting,
    List<TransitionEntity>? transitions,
  }) =>
      NfaStateEntity(
        id: id ?? this.id,
        isAccepting: isAccepting ?? this.isAccepting,
        transitions: transitions ?? this.transitions,
      );

  @override
  List<Object?> get props => [id];

  @override
  String toString() => "NfaState($id, accepting: $isAccepting)";
}
