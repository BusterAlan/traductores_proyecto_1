import "../../../business/entities/transition_entity.dart";

/// DTO para representar una transición en almacenamiento.
class TransitionModel {
  /// Constructor del modelo de transición.
  TransitionModel({
    required this.fromStateId,
    required this.toStateId,
    this.symbol,
  });

  /// Crea un modelo desde JSON.
  factory TransitionModel.fromJson(Map<String, dynamic> json) =>
      TransitionModel(
        fromStateId: json["fromStateId"] as String? ?? "",
        toStateId: json["toStateId"] as String? ?? "",
        symbol: json["symbol"] as String?,
      );

  /// Crea un modelo desde la entidad de negocio.
  factory TransitionModel.fromEntity(TransitionEntity entity) =>
      TransitionModel(
        fromStateId: entity.fromStateId,
        toStateId: entity.toStateId,
        symbol: entity.symbol,
      );

  /// ID del estado origen.
  final String fromStateId;

  /// ID del estado destino.
  final String toStateId;

  /// Símbolo de la transición (null para ε).
  final String? symbol;

  /// Convierte el modelo a JSON.
  Map<String, dynamic> toJson() => {
        "fromStateId": fromStateId,
        "toStateId": toStateId,
        "symbol": symbol,
      };

  /// Convierte el modelo a entidad de negocio.
  TransitionEntity toEntity() => TransitionEntity(
        fromStateId: fromStateId,
        toStateId: toStateId,
        symbol: symbol,
      );
}
