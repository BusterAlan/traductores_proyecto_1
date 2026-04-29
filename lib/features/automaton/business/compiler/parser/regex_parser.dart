import "../ast/base_node.dart";
import "../ast/nodes.dart";
import "../lexer/token.dart";
import "../lexer/token_type.dart";

/// Regualar expression parser class
class RegexParser {
  /// Regualar expression parser class
  RegexParser(this.tokens);

  /// Tokens list value
  final List<Token> tokens;

  /// Current counter
  int current = 0;

  /// Parse method that returns a base node
  RegexNode parse() => _expression();

  /// "Or expression"
  RegexNode _expression() {
    var node = _term();

    while (_match(TokenType.or)) {
      final right = _term();
      node = OrNode(node, right);
    }

    return node;
  }

  /// "Concat expression"
  RegexNode _term() {
    var node = _factor();

    while (_canStartFactor()) {
      final right = _factor();
      node = ConcatNode(node, right);
    }

    return node;
  }

  /// "Kleene expression"
  RegexNode _factor() {
    var node = _primary();

    while (_match(TokenType.star)) {
      node = StarNode(node);
    }

    return node;
  }

  /// "Expression" (Base)
  RegexNode _primary() {
    if (_match(TokenType.char)) {
      return CharNode(_previous().value);
    }

    if (_match(TokenType.lParen)) {
      final expr = _expression();

      if (!_match(TokenType.rParen)) {
        throw Exception("Missing ')'");
      }

      return expr;
    }

    throw Exception("Unexpected token");
  }

  bool _match(TokenType type) {
    if (_check(type)) {
      current++;
      return true;
    }
    return false;
  }

  bool _check(TokenType type) {
    if (_isAtEnd()) {
      return false;
    }
    return tokens[current].type == type;
  }

  Token _previous() => tokens[current - 1];

  bool _isAtEnd() => current >= tokens.length;

  bool _canStartFactor() {
    if (_isAtEnd()) {
      return false;
    }

    final type = tokens[current].type;

    return type == TokenType.char || type == TokenType.lParen;
  }
}
