import "package:equatable/equatable.dart";

/// Representa una expresión regular ya validada y procesada.
///
/// [raw] es el string original del usuario, ej: `(a|b)*abb`
/// [postfix] es la forma postfix lista para Thompson's Construction,
/// ej: `ab|*a.b.b.`
///
/// El punto `.` representa concatenación explícita — el parser
/// lo inserta al convertir a postfix.
class RegexExpressionEntity extends Equatable {
  /// Representa una expresión regular ya validada y procesada.
  ///
  /// [raw] es el string original del usuario, ej: `(a|b)*abb`
  /// [postfix] es la forma postfix lista para Thompson's Construction,
  /// ej: `ab|*a.b.b.`
  ///
  /// El punto `.` representa concatenación explícita — el parser
  /// lo inserta al convertir a postfix.
  const RegexExpressionEntity({
    required this.raw,
    required this.postfix,
    required this.alphabet,
  });

  /// Raw user expression
  final String raw;

  /// Post fix form
  final String postfix;

  /// Alfabeto inferido: todos los símbolos literales en la expresión,
  /// excluyendo operadores (|, *, +, ?, .) y paréntesis.
  final Set<String> alphabet;

  @override
  List<Object?> get props => [raw, postfix, alphabet];

  @override
  String toString() =>
      'RegexExpression(raw: "$raw", postfix: "$postfix", alphabet: $alphabet)';
}
