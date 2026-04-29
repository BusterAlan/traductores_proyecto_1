import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../entities/automaton_graph_entity.dart";
import "../entities/regex_expression_entity.dart";

/// Contrato que la capa de datos debe cumplir.
/// Los use cases solo conocen esta interfaz — nunca la implementación.
abstract interface class AutomatonRepository {
  /// Parsea [rawRegex] y lo convierte a postfix con el alfabeto inferido.
  Either<Failure, RegexExpressionEntity> parseRegex(String rawRegex);

  /// Construye un NFA a partir de [expression] usando Thompson's Construction.
  Either<Failure, AutomatonGraphEntity> buildNfa(
    RegexExpressionEntity expression,
  );

  /// Convierte [nfa] a DFA determinista usando construcción de subconjuntos.
  Either<Failure, AutomatonGraphEntity> convertToDfa(
    AutomatonGraphEntity nfa,
  );

  /// Genera el string en lenguaje DOT a partir de [graph].
  Either<Failure, String> generateDot(AutomatonGraphEntity graph);
}
