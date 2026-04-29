import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../business/entities/automaton_graph_entity.dart";
import "../../business/entities/regex_expression_entity.dart";
import "../../business/repositories/automaton_repository.dart";
import "../data_sources/local/automaton_local_data_source.dart";

/// Data operations for the Automaton collection
class AutomatonRepositoryImpl implements AutomatonRepository {
  /// Data operations for the Automaton collection
  AutomatonRepositoryImpl({    
    required this.localDataSource,
  });
  
  /// Local data source value
  final AutomatonLocalDataSource localDataSource;

  @override
  Either<Failure, AutomatonGraphEntity> buildNfa(RegexExpressionEntity expression) {
    // TODO: implement buildNfa
    throw UnimplementedError();
  }

  @override
  Either<Failure, AutomatonGraphEntity> convertToDfa(AutomatonGraphEntity nfa) {
    // TODO: implement convertToDfa
    throw UnimplementedError();
  }

  @override
  Either<Failure, String> generateDot(AutomatonGraphEntity graph) {
    // TODO: implement generateDot
    throw UnimplementedError();
  }

  @override
  Either<Failure, RegexExpressionEntity> parseRegex(String rawRegex) {
    // TODO: implement parseRegex
    throw UnimplementedError();
  }

  /*
  A repository is a collection of data operations. It is responsible for 
  abstracting the data layer from the business logic layer.
  */
}
