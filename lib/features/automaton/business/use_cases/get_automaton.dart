import "package:flutter_common_classes/constants/classes/use_case.dart";
import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/automaton_params.dart";
import "../entities/automaton_graph_entity.dart";
import "../repositories/automaton_repository.dart";

/// Get automaton use case
class GetAutomaton implements UseCase<AutomatonGraphEntity, AutomatonParams> {
  /// Get automaton use case
  GetAutomaton({required this.automatonRepository});

  /// Automaton repository value
  final AutomatonRepository automatonRepository;

  @override
  Either<Failure, AutomatonGraphEntity> call({
    required AutomatonParams params,
  }) {
    // TODO: implement call
    throw UnimplementedError();
  }

  @override
  Failure? failure;
}
