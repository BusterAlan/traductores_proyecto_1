import "../ast/base_node.dart";

/// Resultado del análisis semántico de una expresión regular.
///
/// Incluye la tabla de símbolos, el alfabeto inferido, la forma postfix
/// y los conjuntos de posiciones utilizados en algoritmos de análisis.
class RegexSemanticAnalysis {
  /// Resultado del análisis semántico de una expresión regular.
  ///
  /// Incluye la tabla de símbolos, el alfabeto inferido, la forma postfix
  /// y los conjuntos de posiciones utilizados en algoritmos de análisis.
  const RegexSemanticAnalysis({
    required this.ast,
    required this.alphabet,
    required this.postfix,
    required this.nullable,
    required this.positions,
    required this.firstpos,
    required this.lastpos,
    required this.followpos,
  });

  /// AST original de la expresión regular.
  final RegexNode ast;

  /// Alfabeto inferido de la expresión.
  final Set<String> alphabet;

  /// Expresión en notación postfix con concatenación explícita.
  final String postfix;

  /// Si la expresión puede aceptar la cadena vacía.
  final bool nullable;

  /// Tabla de símbolos: posición → símbolo literal.
  final Map<int, String> positions;

  /// Conjunto de posiciones `firstpos` por nodo.
  final Map<RegexNode, Set<int>> firstpos;

  /// Conjunto de posiciones `lastpos` por nodo.
  final Map<RegexNode, Set<int>> lastpos;

  /// Tabla `followpos` para cada posición.
  final Map<int, Set<int>> followpos;

  @override
  String toString() =>
      "RegexSemanticAnalysis(alphabet: $alphabet, postfix: $postfix, nullable: $nullable, positions: $positions, followpos: $followpos)";
}
