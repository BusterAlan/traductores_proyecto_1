import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/cubit_states/state_mixin.dart";

import "../../business/entities/automaton_result_entity.dart";
import "../../business/entities/regex_expression_entity.dart";
import "../../business/use_cases/analyze_regex.dart";
import "../../business/use_cases/build_nfa.dart";
import "../../business/use_cases/convert_to_dfa.dart";
import "../../business/use_cases/layout_automaton.dart";
import "../../data/models/params/build_nfa_params.dart";
import "../../data/models/params/convert_to_dfa_params.dart";
import "../../data/models/params/layout_automaton_params.dart";
import "../../data/models/params/parse_regex_params.dart";

/// Cubit que orquesta el pipeline completo:
/// Regex string → NFA → DFA → Offsets de layout
class AutomatonCubit extends Cubit<StateMixin<AutomatonResultEntity>> {
  /// Cubit que orquesta el pipeline completo.
  AutomatonCubit({
    AnalyzeRegex? analyzeRegex,
    BuildNfa? buildNfa,
    ConvertToDfa? convertToDfa,
    LayoutAutomaton? layoutAutomaton,
  })  : _analyzeRegex = analyzeRegex ?? AnalyzeRegex(),
        _buildNfa = buildNfa ?? BuildNfa(),
        _convertToDfa = convertToDfa ?? ConvertToDfa(),
        _layoutAutomaton = layoutAutomaton ?? LayoutAutomaton(),
        super(StateMixin.initial());

  final AnalyzeRegex _analyzeRegex;
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

    final analysisResult = _analyzeRegex.call(
      params: ParseRegexParams(rawRegex: rawRegex),
    );

    if (analysisResult.isLeft()) {
      emit(StateMixin.failure(analysisResult.getLeft().toNullable()!));
      return;
    }

    final analysis = analysisResult.getRight().toNullable()!;
    final expression = RegexExpressionEntity(
      raw: rawRegex,
      postfix: analysis.postfix,
      alphabet: analysis.alphabet,
      semanticAnalysis: analysis,
    );

    final ast = analysis.ast;

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
