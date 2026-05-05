import "token_type.dart";

/// Token class
class Token {
  /// Token class
  const Token(this.type, this.value);

  /// Token type value
  final TokenType type;

  /// Value
  final String value;
}
