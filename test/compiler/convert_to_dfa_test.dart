// fvm flutter test test/compiler/convert_to_dfa_test.dart

import "package:flutter_test/flutter_test.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/lexer/regex_lexer.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/parser/regex_parser.dart";
import "package:traductores_proyecto_1/features/automaton/business/entities/automaton_graph_entity.dart";
import "package:traductores_proyecto_1/features/automaton/business/entities/regex_expression_entity.dart";
import "package:traductores_proyecto_1/features/automaton/business/use_cases/build_nfa.dart";
import "package:traductores_proyecto_1/features/automaton/business/use_cases/convert_to_dfa.dart";
import "package:traductores_proyecto_1/features/automaton/data/models/params/build_nfa_params.dart";
import "package:traductores_proyecto_1/features/automaton/data/models/params/convert_to_dfa_params.dart";

// ── Pipeline completo regex → NFA → DFA ──────────────────────────────────────

AutomatonGraphEntity buildDfa(String raw) {
  final tokens = RegexLexer().tokenize(raw);
  final ast = RegexParser(tokens).parse();

  final alphabet = raw.split("").where((c) => !"()|*+?".contains(c)).toSet();

  final expression = RegexExpressionEntity(
    raw: raw,
    postfix: "",
    alphabet: alphabet,
  );

  final nfa = BuildNfa()
      .call(
        params: BuildNfaParams(
          expression: expression,
          ast: ast,
        ),
      )
      .getOrElse((f) => throw Exception(f.message));

  return ConvertToDfa()
      .call(
        params: ConvertToDfaParams(
          graph: nfa,
        ),
      )
      .getOrElse((f) => throw Exception(f.message));
}

/// Simula el DFA sobre [input] y retorna true si lo acepta.
bool accepts(AutomatonGraphEntity dfa, String input) {
  var current = dfa.initialStateId;

  for (final char in input.split("")) {
    final state = dfa.dfaStates.firstWhere((s) => s.id == current);
    final next = state.targetOn(char);
    if (next == null) {
      return false;
    }
    current = next;
  }

  return dfa.acceptingStateIds.contains(current);
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group("Estructura básica del DFA", () {
    test("tiene exactamente un estado inicial", () {
      final dfa = buildDfa("a");
      expect(dfa.initialStateId.isNotEmpty, true);
    });

    test("no tiene ε-transiciones", () {
      final dfa = buildDfa("(a|b)*abb");
      final epsilons = dfa.dfaStates
          .expand((s) => s.transitions)
          .where((t) => t.isEpsilon)
          .toList();
      expect(epsilons, isEmpty);
    });

    test("cada estado tiene como máximo una transición por símbolo", () {
      final dfa = buildDfa("(a|b)*abb");
      for (final state in dfa.dfaStates) {
        final symbols = state.transitions.map((t) => t.symbol).toList();
        final unique = symbols.toSet();
        expect(
          symbols.length,
          unique.length,
          reason: "Estado ${state.id} tiene transiciones duplicadas",
        );
      }
    });
  });

  group("Literal simple — 'a'", () {
    test("acepta 'a'", () => expect(accepts(buildDfa("a"), "a"), true));
    test("rechaza ''", () => expect(accepts(buildDfa("a"), ""), false));
    test("rechaza 'b'", () => expect(accepts(buildDfa("a"), "b"), false));
    test("rechaza 'aa'", () => expect(accepts(buildDfa("a"), "aa"), false));
  });

  group("Concatenación — 'ab'", () {
    test("acepta 'ab'", () => expect(accepts(buildDfa("ab"), "ab"), true));
    test("rechaza 'a'", () => expect(accepts(buildDfa("ab"), "a"), false));
    test("rechaza 'b'", () => expect(accepts(buildDfa("ab"), "b"), false));
    test("rechaza 'ba'", () => expect(accepts(buildDfa("ab"), "ba"), false));
    test("rechaza 'abb'", () => expect(accepts(buildDfa("ab"), "abb"), false));
  });

  group("Unión — 'a|b'", () {
    test("acepta 'a'", () => expect(accepts(buildDfa("a|b"), "a"), true));
    test("acepta 'b'", () => expect(accepts(buildDfa("a|b"), "b"), true));
    test("rechaza ''", () => expect(accepts(buildDfa("a|b"), ""), false));
    test("rechaza 'ab'", () => expect(accepts(buildDfa("a|b"), "ab"), false));
  });

  group("Kleene star — 'a*'", () {
    test("acepta ''", () => expect(accepts(buildDfa("a*"), ""), true));
    test("acepta 'a'", () => expect(accepts(buildDfa("a*"), "a"), true));
    test("acepta 'aaa'", () => expect(accepts(buildDfa("a*"), "aaa"), true));
    test("rechaza 'b'", () => expect(accepts(buildDfa("a*"), "b"), false));
    test("rechaza 'ab'", () => expect(accepts(buildDfa("a*"), "ab"), false));
  });

  group("Plus — 'a+'", () {
    test("rechaza ''", () => expect(accepts(buildDfa("a+"), ""), false));
    test("acepta 'a'", () => expect(accepts(buildDfa("a+"), "a"), true));
    test("acepta 'aaa'", () => expect(accepts(buildDfa("a+"), "aaa"), true));
    test("rechaza 'b'", () => expect(accepts(buildDfa("a+"), "b"), false));
  });

  group("Question — 'a?'", () {
    test("acepta ''", () => expect(accepts(buildDfa("a?"), ""), true));
    test("acepta 'a'", () => expect(accepts(buildDfa("a?"), "a"), true));
    test("rechaza 'aa'", () => expect(accepts(buildDfa("a?"), "aa"), false));
  });

  group("Caso clásico Dragon Book — '(a|b)*abb'", () {
    final dfa = buildDfa("(a|b)*abb");

    test("acepta 'abb'", () => expect(accepts(dfa, "abb"), true));
    test("acepta 'aabb'", () => expect(accepts(dfa, "aabb"), true));
    test("acepta 'babb'", () => expect(accepts(dfa, "babb"), true));
    test("acepta 'ababb'", () => expect(accepts(dfa, "ababb"), true));
    test("acepta 'aababb'", () => expect(accepts(dfa, "aababb"), true));
    test("rechaza ''", () => expect(accepts(dfa, ""), false));
    test("rechaza 'ab'", () => expect(accepts(dfa, "ab"), false));
    test("rechaza 'abba'", () => expect(accepts(dfa, "abba"), false));
    test("rechaza 'b'", () => expect(accepts(dfa, "b"), false));
    test("tiene 5 estados", () => expect(dfa.dfaStates.length, 5));
  });
}
