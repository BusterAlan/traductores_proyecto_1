import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../business/entities/automaton_graph_entity.dart";
import "../../business/entities/regex_expression_entity.dart";
import "../../business/repositories/automaton_repository.dart";
import "../../business/use_cases/convert_to_dfa.dart";
import "../../business/use_cases/generate_dot.dart";
import "../../data/data_sources/local/automaton_local_data_source.dart";
import "../../data/models/params/convert_to_dfa_params.dart";
import "../../data/models/params/generate_dot_params.dart";

/// Implementación concreta del repositorio de autómatas.
///
/// Orquesta los use cases y encapsula la lógica de negocio para la capa de presentación.
/// Actúa como intermediario entre la capa de datos/negocio y la presentación.
class AutomatonRepositoryImpl implements AutomatonRepository {
  /// Crea una instancia de AutomatonRepositoryImpl.
  AutomatonRepositoryImpl({
    required this.localDataSource,
    ConvertToDfa? convertToDfa,
    GenerateDot? generateDot,
  })  :
        _convertToDfa = convertToDfa ?? ConvertToDfa(),
        _generateDot = generateDot ?? GenerateDot();

  /// Data source local (SharedPreferences, SQLite, etc.)
  final AutomatonLocalDataSource localDataSource;

  /// Use case para construcción de subconjuntos
  final ConvertToDfa _convertToDfa;

  /// Use case para generación de DOT
  final GenerateDot _generateDot;

  @override
  Either<Failure, RegexExpressionEntity> parseRegex(String rawRegex) {
    // Parsing simple: inferir alfabeto desde la regex cruda
    final alphabet = rawRegex
        .split("")
        .where(
          (c) => !r"()|*+?\".contains(c),
        )
        .toSet();

    try {
      return right(
        RegexExpressionEntity(
          raw: rawRegex,
          postfix: "", // TODO: implementar conversión a postfix si es necesario
          alphabet: alphabet,
        ),
      );
    } catch (e) {
      return left(
        AppFailure(
          title: "Error parseando regex",
          message: e.toString(),),
      );
    }
  }

  @override
  Either<Failure, AutomatonGraphEntity> buildNfa(
    RegexExpressionEntity expression,
  ) {
    // Aquí deberíamos crear el AST desde expression.raw
    // Por ahora, delegamos al use case si tenemos el AST
    // Este es un punto donde se requiere sincronización con el parser
    try {
      // TODO: Requiere el AST desde RegexExpressionEntity
      return left(
        AppFailure(
          title: "Método buildNfa requiere AST completo",
          message:
              "Use AutomatonCubit directamente",
        ),
      );
    } catch (e) {
      return left(
        AppFailure(
          title: "Error construyendo NFA",
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Either<Failure, AutomatonGraphEntity> convertToDfa(
    AutomatonGraphEntity nfa,
  ) {
    try {
      final result = _convertToDfa.call(
        params: ConvertToDfaParams(graph: nfa),
      );
      return result.fold(
        left,
        right,
      );
    } catch (e) {
      return left(
        AppFailure(
          title: "Error convirtiendo a DFA",
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Either<Failure, String> generateDot(AutomatonGraphEntity graph) {
    try {
      final result = _generateDot.call(
        params: GenerateDotParams(graph: graph),
      );
      return result.fold(
        left,
        right,
      );
    } catch (e) {
      return left(
        AppFailure(
          title: "Error generando DOT",
          message: e.toString(),
        ),
      );
    }
  }
}
