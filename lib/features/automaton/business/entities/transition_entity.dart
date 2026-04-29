import "package:equatable/equatable.dart";

/// Representa una transición entre estados.
/// [symbol] es `null` para ε-transiciones (solo válido en NFA).
class TransitionEntity extends Equatable {
  /// Representa una transición entre estados.
  /// [symbol] es `null` para ε-transiciones (solo válido en NFA).
  const TransitionEntity({
    required this.fromStateId,
    required this.toStateId,
    this.symbol,
  });

  /// From state identifier value
  final String fromStateId;

  /// Symbol value
  final String? symbol;

  /// To state identifier value
  final String toStateId;

  /// Getter to expose if a transition is epsilon
  bool get isEpsilon => symbol == null;

  @override
  List<Object?> get props => [fromStateId, symbol, toStateId];

  @override
  String toString() => '$fromStateId --${symbol ?? 'ε'}--> $toStateId';
}
