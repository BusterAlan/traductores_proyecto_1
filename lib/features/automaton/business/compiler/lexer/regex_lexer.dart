import "token.dart";
import "token_type.dart";

/// Regular expression lexer class
class RegexLexer {
  /// Tokenize method, returns a list of tokens, needs to pass it a String input
  List<Token> tokenize(String input) {
    final tokens = <Token>[];

    for (int i = 0; i < input.length; i++) {
      final c = input[i];

      switch (c) {
        case "(":
          tokens.add(Token(TokenType.lParen, c));
        case ")":
          tokens.add(Token(TokenType.rParen, c));
        case "|":
          tokens.add(Token(TokenType.or, c));
        case "*":
          tokens.add(Token(TokenType.star, c));
        case "+":
          tokens.add(Token(TokenType.plus, c));
        case "?":
          tokens.add(Token(TokenType.question, c));
        default:
          tokens.add(Token(TokenType.char, c));
      }
    }

    return tokens;
  }
}
