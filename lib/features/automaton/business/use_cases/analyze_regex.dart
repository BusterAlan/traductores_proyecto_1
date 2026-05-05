import "package:flutter_common_classes/constants/classes/use_case.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/languaje_failures.dart";
import "../../data/models/params/parse_regex_params.dart";
import "../compiler/lexer/regex_lexer.dart";
import "../compiler/parser/regex_parser.dart";
import "../compiler/semantic/regex_semantic_analysis.dart";
import "../compiler/semantic/regex_semantic_analyzer.dart";

/// Analiza sintáctica y semántica de una expresión regular.
///
/// Devuelve el AST validado, el alfabeto inferido y la forma postfix.
class AnalyzeRegex extends UseCase<RegexSemanticAnalysis, ParseRegexParams> {
  /// Analiza sintáctica y semántica de una expresión regular.
  ///
  /// Devuelve el AST validado, el alfabeto inferido y la forma postfix.
  AnalyzeRegex();

  @override
  Either<LanguageFailure, RegexSemanticAnalysis> call({
    required ParseRegexParams params,
  }) {
    try {
      final tokens = RegexLexer().tokenize(params.rawRegex);
      final ast = RegexParser(tokens).parse();
      return RegexSemanticAnalyzer().analyze(ast);
    } on FormatException catch (e) {
      return left(InvalidRegexFailure(e.message));
    }
  }
}
