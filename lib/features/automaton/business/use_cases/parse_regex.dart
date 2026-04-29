import "package:flutter_common_classes/constants/classes/use_case.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/languaje_failures.dart";
import "../../data/models/params/parse_regex_params.dart";
import "../compiler/ast/base_node.dart";
import "../compiler/lexer/regex_lexer.dart";
import "../compiler/parser/regex_parser.dart";
import "../entities/regex_expression_entity.dart";

/// Parsea una expresión regular cruda y la convierte a notación postfix
/// lista para Thompson's Construction.
///
/// Operadores soportados (por precedencia, de menor a mayor):
///   |   unión
///   .   concatenación (insertada implícitamente)
///   *   Kleene star   (unario, postfijo)
///   +   una o más     (unario, postfijo)
///   ?   cero o una    (unario, postfijo)
///
/// Ejemplo:
///   raw     →  "(a|b)*abb"
///   con '.' →  "(a|b)*.a.b.b"
///   postfix →  "ab|*a.b.b."
class ParseRegex extends UseCase<RegexNode, ParseRegexParams> {
  /// Parsea una expresión regular cruda y la convierte a notación postfix
  /// lista para Thompson's Construction.
  ///
  /// Operadores soportados (por precedencia, de menor a mayor):
  ///   |   unión
  ///   .   concatenación (insertada implícitamente)
  ///   *   Kleene star   (unario, postfijo)
  ///   +   una o más     (unario, postfijo)
  ///   ?   cero o una    (unario, postfijo)
  ///
  /// Ejemplo:
  ///   raw     →  "(a|b)*abb"
  ///   con '.' →  "(a|b)*.a.b.b"
  ///   postfix →  "ab|*a.b.b."
  ParseRegex();

  @override
  Either<LanguageFailure, RegexNode> call({
    required ParseRegexParams params,
  }) {
    final lexer = RegexLexer();
    final tokens = lexer.tokenize(params.rawRegex);

    final parser = RegexParser(tokens);
    final ast = parser.parse();

    return right(ast);
  }
}
