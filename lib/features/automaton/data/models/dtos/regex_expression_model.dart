import "../../../business/entities/regex_expression_entity.dart";

/// DTO para representar una expresión regular en almacenamiento.
class RegexExpressionModel {
  /// Constructor del modelo de expresión regular.
  RegexExpressionModel({
    required this.raw,
    required this.postfix,
    required this.alphabet,
  });

  /// Crea un modelo desde la entidad de negocio.
  factory RegexExpressionModel.fromEntity(RegexExpressionEntity entity) =>
      RegexExpressionModel(
        raw: entity.raw,
        postfix: entity.postfix,
        alphabet: entity.alphabet.toList(),
      );

  /// Crea un modelo desde JSON.
  factory RegexExpressionModel.fromJson(Map<String, dynamic> json) =>
      RegexExpressionModel(
        raw: json["raw"] as String? ?? "",
        postfix: json["postfix"] as String? ?? "",
        alphabet: List<String>.from(
          json["alphabet"] as List<dynamic>? ?? [],
        ),
      );

  /// Expresión regular cruda (ej: "(a|b)*abb")
  final String raw;

  /// Expresión en notación postfix
  final String postfix;

  /// Alfabeto inferido
  final List<String> alphabet;

  /// Convierte el modelo a JSON.
  Map<String, dynamic> toJson() => {
        "raw": raw,
        "postfix": postfix,
        "alphabet": alphabet,
      };

  /// Convierte el modelo a entidad de negocio.
  RegexExpressionEntity toEntity() => RegexExpressionEntity(
        raw: raw,
        postfix: postfix,
        alphabet: alphabet.toSet(),
      );
}
