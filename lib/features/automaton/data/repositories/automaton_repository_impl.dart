import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/languaje_failures.dart";
import "../../business/compiler/lexer/regex_lexer.dart";
import "../../business/compiler/parser/regex_parser.dart";
import "../../business/entities/automaton_graph_entity.dart";
import "../../business/entities/regex_expression_entity.dart";
import "../../business/repositories/automaton_repository.dart";
import "../../business/use_cases/analyze_regex.dart";
import "../../business/use_cases/build_nfa.dart";
import "../../business/use_cases/convert_to_dfa.dart";
import "../../business/use_cases/generate_dot.dart";
import "../../data/data_sources/local/automaton_local_data_source.dart";
import "../../data/models/params/convert_to_dfa_params.dart";
import "../../data/models/params/generate_dot_params.dart";
import "../models/params/build_nfa_params.dart";
import "../models/params/parse_regex_params.dart";

/// Implementación concreta del repositorio de autómatas.
///
/// Orquesta los use cases y encapsula la lógica de negocio para la capa de presentación.
/// Actúa como intermediario entre la capa de datos/negocio y la presentación.
class AutomatonRepositoryImpl implements AutomatonRepository {
  /// Crea una instancia de AutomatonRepositoryImpl.
  AutomatonRepositoryImpl({
    required this.localDataSource,
    AnalyzeRegex? analyzeRegex,
    BuildNfa? buildNfa,
    ConvertToDfa? convertToDfa,
    GenerateDot? generateDot,
  })  : _analyzeRegex = analyzeRegex ?? AnalyzeRegex(),
        _buildNfa = buildNfa ?? BuildNfa(),
        _convertToDfa = convertToDfa ?? ConvertToDfa(),
        _generateDot = generateDot ?? GenerateDot();

  /// Data source local
  final AutomatonLocalDataSource localDataSource;

  /// Use case para análisis semántico
  final AnalyzeRegex _analyzeRegex;

  /// Use case para construcción de NFA
  final BuildNfa _buildNfa;

  /// Use case para construcción de subconjuntos
  final ConvertToDfa _convertToDfa;

  /// Use case para generación de DOT
  final GenerateDot _generateDot;

  @override
  Either<Failure, RegexExpressionEntity> parseRegex(
    String rawRegex,
  ) {
    try {
      final semanticResult = _analyzeRegex.call(
        params: ParseRegexParams(rawRegex: rawRegex),
      );

      if (semanticResult.isLeft()) {
        return left<Failure, RegexExpressionEntity>(
          semanticResult.getLeft().toNullable()!,
        );
      }

      final analysis = semanticResult.getRight().toNullable()!;
      return right<Failure, RegexExpressionEntity>(
        RegexExpressionEntity(
          raw: rawRegex,
          postfix: analysis.postfix,
          alphabet: analysis.alphabet,
          semanticAnalysis: analysis,
        ),
      );
    } catch (e) {
      return left(NfaBuildFailure("Error inesperado: $e"));
    }
  }

  @override
  Either<Failure, AutomatonGraphEntity> buildNfa(
    RegexExpressionEntity expression,
  ) {
    try {
      final ast = expression.semanticAnalysis?.ast ??
          RegexParser(RegexLexer().tokenize(expression.raw)).parse();
      return _buildNfa.call(
        params: BuildNfaParams(expression: expression, ast: ast),
      );
    } on FormatException catch (e) {
      return left(InvalidRegexFailure(e.message));
    } catch (e) {
      return left(NfaBuildFailure("Error inesperado: $e"));
    }
  }

  @override
  Either<Failure, AutomatonGraphEntity> convertToDfa(
    AutomatonGraphEntity nfa,
  ) {
    final result = _convertToDfa.call(
      params: ConvertToDfaParams(graph: nfa),
    );
    return result.fold(
      left,
      right,
    );
  }

  @override
  Either<Failure, String> generateDot(AutomatonGraphEntity graph) {
    final result = _generateDot.call(
      params: GenerateDotParams(graph: graph),
    );
    return result.fold(
      left,
      right,
    );
  }
}
