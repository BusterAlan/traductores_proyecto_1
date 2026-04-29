// ignore_for_file: avoid_print, library_private_types_in_public_api

import "package:traductores_proyecto_1/features/automaton/business/compiler/lexer/regex_lexer.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/parser/regex_parser.dart";
import "package:traductores_proyecto_1/features/automaton/business/entities/nfa_state_entity.dart";
import "package:traductores_proyecto_1/features/automaton/business/entities/regex_expression_entity.dart";
import "package:traductores_proyecto_1/features/automaton/business/use_cases/build_nfa.dart";
import "package:traductores_proyecto_1/features/automaton/data/models/params/build_nfa_params.dart";

class _NfaResult {
  _NfaResult(this.initial, this.accepting, this.states);
  final String initial;
  final Set<String> accepting;
  final List<NfaStateEntity> states;

  NfaStateEntity stateById(String id) => states.firstWhere((s) => s.id == id);

  bool hasTransition(String from, String? symbol, String to) =>
      states.any((s) =>
          s.id == from &&
          s.transitions.any((t) => t.symbol == symbol && t.toStateId == to),);
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group("Estructura básica del NFA", () {
    check(
      "tiene exactamente un estado inicial",
      "a",
      (nfa) {
        expect(nfa.initial.isNotEmpty, "initialStateId vacío");
      },
    );

    check("tiene exactamente un estado de aceptación", "a", (nfa) {
      expect(nfa.accepting.length == 1,
          "esperado 1 accepting, got ${nfa.accepting.length}",);
    });

    check("el estado inicial NO es de aceptación en 'a'", "a", (nfa) {
      expect(!nfa.accepting.contains(nfa.initial),
          "inicial no debe ser accepting",);
    });
  });

  group("CharNode — transición por símbolo", () {
    check("'a' genera transición a→ estado final", "a", (nfa) {
      final end = nfa.accepting.first;
      expect(
        nfa.hasTransition(nfa.initial, "a", end),
        "esperaba transición '${nfa.initial}' --a--> '$end'",
      );
    });

    check("'a' genera exactamente 2 estados", "a", (nfa) {
      expect(nfa.states.length == 2,
          "esperado 2 estados, got ${nfa.states.length}",);
    });
  });

  group("ConcatNode", () {
    check(
        "'ab' — estado inicial conecta via 'a', luego 'b' llega al final", "ab",
        (nfa) {
      // El inicial debe tener transición 'a' hacia algún estado intermedio
      final fromInitial = nfa.states
          .firstWhere((s) => s.id == nfa.initial)
          .transitions
          .where((t) => t.symbol == "a")
          .toList();
      expect(fromInitial.isNotEmpty, "no hay transición 'a' desde el inicio");

      // Debe haber algún estado con transición 'b' hacia el estado de aceptación
      final end = nfa.accepting.first;
      final toEnd = nfa.states
          .expand((s) => s.transitions)
          .where((t) => t.symbol == "b" && t.toStateId == end)
          .toList();
      expect(toEnd.isNotEmpty, "no hay transición 'b' hacia el estado final");
    });
  });

  group("OrNode", () {
    check("'a|b' — inicial tiene dos ε-transiciones", "a|b", (nfa) {
      final epsilons = nfa
          .stateById(nfa.initial)
          .transitions
          .where((t) => t.isEpsilon)
          .toList();
      expect(epsilons.length == 2,
          "esperado 2 ε desde inicial, got ${epsilons.length}",);
    });

    check("'a|b' — estado de aceptación no tiene transiciones salientes", "a|b",
        (nfa) {
      final end = nfa.stateById(nfa.accepting.first);
      expect(end.transitions.isEmpty,
          "el estado final no debe tener transiciones",);
    });
  });

  group("StarNode", () {
    check("'a*' — inicial tiene bypass ε directo al final", "a*", (nfa) {
      final end = nfa.accepting.first;
      expect(
        nfa.hasTransition(nfa.initial, null, end),
        "esperaba bypass ε del inicial al final",
      );
    });

    check("'a*' — hay loop: el estado post-'a' regresa con ε", "a*", (nfa) {
      // Debe existir algún estado que tenga ε de vuelta hacia el inicio del fragmento A
      final loopExists = nfa.states.any((s) => s.transitions
          .any((t) => t.isEpsilon && t.toStateId != nfa.accepting.first),);
      expect(loopExists, "no encontré ε de loop");
    });
  });

  group("PlusNode", () {
    check("'a+' — inicial NO tiene bypass al final", "a+", (nfa) {
      final end = nfa.accepting.first;
      final bypass = nfa.hasTransition(nfa.initial, null, end);
      expect(!bypass, "plus no debe tener bypass del inicio al final");
    });
  });

  group("QuestionNode", () {
    check("'a?' — inicial tiene bypass ε al final", "a?", (nfa) {
      final end = nfa.accepting.first;
      expect(
        nfa.hasTransition(nfa.initial, null, end),
        "question debe tener bypass del inicio al final",
      );
    });

    check("'a?' — NO tiene loop (a diferencia de star)", "a?", (nfa) {
      // En question no debe haber ninguna ε que regrese al inicio de A
      // Solo hay bypass inicio→final y A.end→final
      final initEpsilons = nfa
          .stateById(nfa.initial)
          .transitions
          .where((t) => t.isEpsilon)
          .toList();
      // El inicial solo debe tener 2 ε: hacia A.start y hacia end (bypass)
      // No debe tener loop de vuelta
      expect(initEpsilons.length == 2,
          "question: inicial debe tener exactamente 2 ε",);
    });
  });

  group("Caso clásico — (a|b)*abb", () {
    check("se construye sin errores", "(a|b)*abb", (nfa) {
      expect(nfa.states.isNotEmpty, "NFA vacío");
    });

    check("tiene exactamente un estado de aceptación", "(a|b)*abb", (nfa) {
      expect(nfa.accepting.length == 1,
          "got ${nfa.accepting.length} accepting states",);
    });

    check("tiene más de 10 estados (complejidad esperada)", "(a|b)*abb", (nfa) {
      expect(nfa.states.length > 10, "got solo ${nfa.states.length} estados");
    });
  });

  // ── Resultado ─────────────────────────────────────────────────────────────
  print("\n${"-" * 45}");
  print("  $_pass passed  |  $_fail failed  |  ${_pass + _fail} total");
  if (_fail == 0) {
    print("  ✓ Thompson's Construction correcta.");
  } else {
    print("  ✗ Hay fallos — revisa los casos marcados.");
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

int _pass = 0;
int _fail = 0;

void group(String name, void Function() body) {
  print("\n$name");
  body();
}

/// Parsea la regex y construye el NFA. Retorna null si algo falla.
_NfaResult? buildNfa(String raw) {
  try {
    final tokens = RegexLexer().tokenize(raw);
    final ast = RegexParser(tokens).parse();

    final alphabet = raw.split("").where((c) => !"()|*+?".contains(c)).toSet();

    final expression = RegexExpressionEntity(
      raw: raw,
      postfix: "", // no usamos postfix en Ruta A
      alphabet: alphabet,
    );

    final result = BuildNfa().call(
      params: BuildNfaParams(
        expression: expression,
        ast: ast,
      ),
    );

    return result.fold(
      (failure) {
        print("    NfaBuildFailure: ${failure.message}");
        return null;
      },
      (graph) => _NfaResult(
          graph.initialStateId, graph.acceptingStateIds, graph.nfaStates,),
    );
  } catch (e) {
    print("    Excepción: $e");
    return null;
  }
}

void check(String label, String raw, void Function(_NfaResult nfa) assertions) {
  final nfa = buildNfa(raw);
  if (nfa == null) {
    print("  ✗  $label  [no se pudo construir el NFA]");
    _fail++;
    return;
  }
  try {
    assertions(nfa);
    print("  ✓  $label");
    _pass++;
  } catch (e) {
    print("  ✗  $label  [$e]");
    _fail++;
  }
}

void expect(bool condition, String message) {
  if (!condition) {
    throw Exception(message);
  }
}
