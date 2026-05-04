// fvm flutter test test/compiler/layout_automaton_test.dart

import "package:flutter_test/flutter_test.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/lexer/regex_lexer.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/parser/regex_parser.dart";
import "package:traductores_proyecto_1/features/automaton/business/entities/automaton_graph_entity.dart";
import "package:traductores_proyecto_1/features/automaton/business/entities/regex_expression_entity.dart";
import "package:traductores_proyecto_1/features/automaton/business/use_cases/build_nfa.dart";
import "package:traductores_proyecto_1/features/automaton/business/use_cases/convert_to_dfa.dart";
import "package:traductores_proyecto_1/features/automaton/business/use_cases/layout_automaton.dart";
import "package:traductores_proyecto_1/features/automaton/data/models/params/build_nfa_params.dart";
import "package:traductores_proyecto_1/features/automaton/data/models/params/convert_to_dfa_params.dart";
import "package:traductores_proyecto_1/features/automaton/data/models/params/layout_automaton_params.dart";

// ── Pipeline ──────────────────────────────────────────────────────────────────

AutomatonGraphEntity buildDfa(String raw) {
  final tokens = RegexLexer().tokenize(raw);
  final ast = RegexParser(tokens).parse();
  final alphabet = raw.split("").where((c) => !"()|*+?".contains(c)).toSet();
  final expr = RegexExpressionEntity(raw: raw, postfix: "", alphabet: alphabet);

  final nfa = BuildNfa()
      .call(
        params: BuildNfaParams(
          expression: expr,
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

Map<String, Offset> layout(AutomatonGraphEntity graph) => LayoutAutomaton()
    .call(
      params: LayoutAutomatonParams(
        graph: graph,
      ),
    )
    .getOrElse((f) => throw Exception(f.message));

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group("Cobertura de estados", () {
    test("todos los estados tienen un offset asignado", () {
      final dfa = buildDfa("(a|b)*abb");
      final offsets = layout(dfa);
      final stateIds = dfa.dfaStates.map((s) => s.id).toSet();

      expect(offsets.keys.toSet(), equals(stateIds));
    });

    test("literal 'a' — 2 estados DFA, ambos con offset", () {
      final dfa = buildDfa("a");
      final offsets = layout(dfa);
      expect(offsets.length, dfa.dfaStates.length);
    });
  });

  group("Estado inicial en x=0", () {
    test("el estado inicial siempre está en x=0", () {
      final dfa = buildDfa("(a|b)*abb");
      final offsets = layout(dfa);
      expect(offsets[dfa.initialStateId]!.dx, 0.0);
    });

    test("'a|b' — inicial en x=0", () {
      final dfa = buildDfa("a|b");
      final offsets = layout(dfa);
      expect(offsets[dfa.initialStateId]!.dx, 0.0);
    });
  });

  group("Layout de izquierda a derecha", () {
    test("estados en niveles distintos tienen x distintas", () {
      final dfa = buildDfa("(a|b)*abb");
      final offsets = layout(dfa);

      // Con 5 estados y el caso clásico debe haber al menos 2 valores de x distintos
      final xValues = offsets.values.map((o) => o.dx).toSet();
      expect(xValues.length, greaterThan(1));
    });

    test("x aumenta o se mantiene — nunca decrece entre niveles BFS", () {
      final dfa = buildDfa("(a|b)*abb");
      final offsets = layout(dfa);

      // El inicial es nivel 0, todos los demás deben tener x >= 0
      for (final offset in offsets.values) {
        expect(offset.dx, greaterThanOrEqualTo(0.0));
      }
    });
  });

  group("Spacing configurable", () {
    test("horizontalSpacing se respeta entre niveles", () {
      const spacing = 300.0;
      final dfa =
          buildDfa("ab"); // inicial → intermedio → final: 3 niveles al menos

      final offsets = LayoutAutomaton(horizontalSpacing: spacing)
          .call(
            params: LayoutAutomatonParams(
              graph: dfa,
            ),
          )
          .getOrElse((f) => throw Exception(f.message));

      final xValues = offsets.values.map((o) => o.dx).toSet().toList()..sort();

      // La diferencia entre niveles consecutivos debe ser exactamente [spacing]
      for (int i = 1; i < xValues.length; i++) {
        expect(xValues[i] - xValues[i - 1], closeTo(spacing, 0.001));
      }
    });
  });

  group("Offsets únicos", () {
    test("no hay dos estados con el mismo Offset", () {
      final dfa = buildDfa("(a|b)*abb");
      final offsets = layout(dfa);

      final values = offsets.values.toList();
      final unique = offsets.values.toSet();
      expect(values.length, unique.length);
    });
  });
}
