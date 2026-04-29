import "../ast/base_node.dart";
import "../ast/nodes.dart";
import "../lexer/token.dart";
import "../lexer/token_type.dart";

/// Parser de expresiones regulares.
///
/// Implementa un parser recursivo descendente con la siguiente gramática:
///
/// ```
///   expression  →  term ( '|' term )*
///   term        →  factor ( factor )*
///   factor      →  primary ( '*' | '+' | '?' )?
///   primary     →  CHAR | '(' expression ')'
/// ```
///
/// La gramática codifica precedencia de forma implícita:
///   - `|` tiene la menor precedencia  (nivel expression)
///   - concat tiene precedencia media  (nivel term)
///   - `* + ?` tienen la mayor         (nivel factor)
class RegexParser {
  /// Parser de expresiones regulares.
  RegexParser(this.tokens);

  /// Lista de tokens producida por el lexer.
  final List<Token> tokens;

  /// Posición actual en la lista de tokens.
  int _current = 0;

  /// Punto de entrada público.
  RegexNode parse() {
    final node = _expression();

    // Si quedaron tokens sin consumir, la expresión es inválida.
    if (!_isAtEnd()) {
      throw FormatException(
        "Token inesperado '${tokens[_current].value}' "
        "en posición $_current.",
      );
    }

    return node;
  }

  // ── Niveles de la gramática ────────────────────────────────────────────────

  /// Nivel 1 — unión (`|`), menor precedencia, asociativa a la izquierda.
  ///
  /// `a|b|c` → OrNode(OrNode(a,b), c)
  RegexNode _expression() {
    var node = _term();

    while (_match(TokenType.or)) {
      final right = _term();
      node = OrNode(node, right);
    }

    return node;
  }

  /// Nivel 2 — concatenación implícita, precedencia media, asociativa a la izquierda.
  ///
  /// `abc` → ConcatNode(ConcatNode(a,b), c)
  RegexNode _term() {
    var node = _factor();

    while (_canStartFactor()) {
      final right = _factor();
      node = ConcatNode(node, right);
    }

    return node;
  }

  /// Nivel 3 — operadores unarios postfijos (`*`, `+`, `?`), mayor precedencia.
  ///
  /// Solo se permite UN operador por operando.
  /// `a**` → FormatException (operador aplicado sobre operador)
  ///
  /// Por qué no usamos `while` aquí:
  ///   - `*`, `+` y `?` son operadores postfijos que se aplican a un OPERANDO.
  ///   - Si ya envolvimos el nodo en StarNode, ese nodo ya no es un "primary"
  ///     válido — es un subárbol completo.
  ///   - Aceptar `a**` silenciosamente sería un error semántico:
  ///     StarNode(StarNode(a)) es redundante e indica que el input es inválido.
  ///   - Un parser de traductor estricto debe rechazarlo con un mensaje claro.
  RegexNode _factor() {
    final node = _primary();

    // Verificamos exactamente uno de los tres operadores unarios.
    if (_match(TokenType.star)) {
      return StarNode(node);
    }

    if (_match(TokenType.plus)) {
      return PlusNode(node);
    }

    if (_match(TokenType.question)) {
      return QuestionNode(node);
    }

    // Sin operador postfijo → retornamos el nodo tal cual.
    return node;
  }

  /// Nivel base — un literal o una subexpresión entre paréntesis.
  RegexNode _primary() {
    if (_match(TokenType.char)) {
      return CharNode(_previous().value);
    }

    if (_match(TokenType.lParen)) {
      final expr = _expression();

      if (!_match(TokenType.rParen)) {
        throw const FormatException("Falta paréntesis de cierre ')'.");
      }

      return expr;
    }

    // Si llegamos aquí, el token no puede iniciar una expresión válida.
    if (_isAtEnd()) {
      throw const FormatException(
        "Expresión incompleta: se esperaba un carácter o '('.",
      );
    }

    throw FormatException(
      "Token inesperado '${tokens[_current].value}' — "
      "se esperaba un carácter o '('.",
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Consume el token actual si su tipo coincide con [type].
  /// Retorna true si se consumió, false si no.
  bool _match(TokenType type) {
    if (_check(type)) {
      _current++;
      return true;
    }
    return false;
  }

  /// Verifica si el token actual es de tipo [type] sin consumirlo.
  bool _check(TokenType type) {
    if (_isAtEnd()) {
      return false;
    }
    return tokens[_current].type == type;
  }

  /// Retorna el token recién consumido.
  Token _previous() => tokens[_current - 1];

  /// Retorna true si no quedan tokens por consumir.
  bool _isAtEnd() => _current >= tokens.length;

  /// Retorna true si el token actual puede iniciar un nuevo `_factor()`.
  /// Usado por `_term()` para saber si sigue concatenando.
  bool _canStartFactor() {
    if (_isAtEnd()) {
      return false;
    }
    final type = tokens[_current].type;
    return type == TokenType.char || type == TokenType.lParen;
  }
}
