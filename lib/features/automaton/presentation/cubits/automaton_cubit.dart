import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/cubit_states/state_mixin.dart";

import "../../../../core/errors/languaje_failures.dart";
import "../../business/compiler/ast/base_node.dart";
import "../../business/compiler/lexer/regex_lexer.dart";
import "../../business/compiler/parser/regex_parser.dart";
import "../../business/entities/automaton_result_entity.dart";
import "../../business/entities/regex_expression_entity.dart";
import "../../business/use_cases/build_nfa.dart";
import "../../business/use_cases/convert_to_dfa.dart";
import "../../business/use_cases/layout_automaton.dart";
import "../../data/models/params/build_nfa_params.dart";
import "../../data/models/params/convert_to_dfa_params.dart";
import "../../data/models/params/layout_automaton_params.dart";

/// Cubit que orquesta el pipeline completo:
/// Regex string → NFA → DFA → Offsets de layout
class AutomatonCubit extends Cubit<StateMixin<AutomatonResultEntity>> {
  /// Cubit que orquesta el pipeline completo.
  AutomatonCubit({
    BuildNfa? buildNfa,
    ConvertToDfa? convertToDfa,
    LayoutAutomaton? layoutAutomaton,
  })  : _buildNfa = buildNfa ?? BuildNfa(),
        _convertToDfa = convertToDfa ?? ConvertToDfa(),
        _layoutAutomaton = layoutAutomaton ?? LayoutAutomaton(),
        super(StateMixin.initial());

  final BuildNfa _buildNfa;
  final ConvertToDfa _convertToDfa;
  final LayoutAutomaton _layoutAutomaton;

  /// Ejecuta el pipeline completo a partir de [rawRegex].
  ///
  /// Emite [StateMixin.loading] al inicio y luego
  /// [StateMixin.success] o [StateMixin.failure] según el resultado.
  void buildAutomaton(String rawRegex) {
    if (rawRegex.trim().isEmpty) {
      return;
    }

    emit(StateMixin.loading());

    // ── 1. Lexer + Parser → AST ──────────────────────────────────────────────
    final tokens = RegexLexer().tokenize(rawRegex);

    final RegexNode ast;
    try {
      ast = RegexParser(tokens).parse();
    } on FormatException catch (e) {
      emit(
        StateMixin.failure(
          InvalidRegexFailure(e.message),
        ),
      );
      return;
    }

    // Inferimos el alfabeto de la regex cruda
    final alphabet = rawRegex
        .split("")
        .where(
          (c) => !"()|*+?".contains(c),
        )
        .toSet();
    final expression = RegexExpressionEntity(
      raw: rawRegex,
      postfix: "",
      alphabet: alphabet,
    );

    // ── 2. Thompson's Construction → NFA ─────────────────────────────────────
    final nfaResult = _buildNfa.call(
      params: BuildNfaParams(expression: expression, ast: ast),
    );

    if (nfaResult.isLeft()) {
      emit(StateMixin.failure(nfaResult.getLeft().toNullable()!));
      return;
    }

    final nfa = nfaResult.getRight().toNullable()!;

    // ── 3. Construcción de subconjuntos → DFA ────────────────────────────────
    final dfaResult = _convertToDfa.call(
      params: ConvertToDfaParams(
        graph: nfa,
      ),
    );

    if (dfaResult.isLeft()) {
      emit(StateMixin.failure(dfaResult.getLeft().toNullable()!));
      return;
    }

    final dfa = dfaResult.getRight().toNullable()!;

    // ── 4. Layout BFS ────────────────────────────────────────────────────────
    final nfaLayoutResult = _layoutAutomaton.call(
      params: LayoutAutomatonParams(graph: nfa),
    );

    if (nfaLayoutResult.isLeft()) {
      emit(StateMixin.failure(nfaLayoutResult.getLeft().toNullable()!));
      return;
    }

    final dfaLayoutResult = _layoutAutomaton.call(
      params: LayoutAutomatonParams(graph: dfa),
    );

    if (dfaLayoutResult.isLeft()) {
      emit(StateMixin.failure(dfaLayoutResult.getLeft().toNullable()!));
      return;
    }

    emit(
      StateMixin.success(
        AutomatonResultEntity(
          nfa: nfa,
          dfa: dfa,
          nfaOffsets: nfaLayoutResult.getRight().toNullable()!,
          dfaOffsets: dfaLayoutResult.getRight().toNullable()!,
        ),
      ),
    );
  }

  /// Resetea el estado al inicial.
  void reset() => emit(StateMixin.initial());
}
