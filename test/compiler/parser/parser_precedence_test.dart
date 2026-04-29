// Corre con: dart test/compiler/parser_precedence_test.dart
//
// No necesita flutter_test ni ningún framework — es Dart puro.
// Verifica que el parser respeta precedencia y asociatividad correctamente.

// ignore_for_file: avoid_print

import "package:traductores_proyecto_1/features/automaton/business/compiler/ast/base_node.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/ast/nodes.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/lexer/regex_lexer.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/parser/regex_parser.dart";

// ── Helper: convierte el AST a string legible ─────────────────────────────

String describe(RegexNode node) => switch (node) {
      final CharNode n     => n.value,
      final StarNode n     => "star(${describe(n.node)})",
      final PlusNode n     => "plus(${describe(n.node)})",
      final QuestionNode n => "q(${describe(n.node)})",
      final ConcatNode n   => "cat(${describe(n.left)},${describe(n.right)})",
      final OrNode n       => "or(${describe(n.left)},${describe(n.right)})",
      _              => "?",
    };

RegexNode parse(String input) {
  final tokens = RegexLexer().tokenize(input);
  return RegexParser(tokens).parse();
}

// ── Runner minimalista ────────────────────────────────────────────────────

int _pass = 0;
int _fail = 0;

void check(String label, String input, String expected) {
  try {
    final actual = describe(parse(input));
    if (actual == expected) {
      print("  ✓  $label");
      _pass++;
    } else {
      print("  ✗  $label");
      print("       input:    $input");
      print("       esperado: $expected");
      print("       actual:   $actual");
      _fail++;
    }
  } catch (e) {
    print("  ✗  $label  [EXCEPCIÓN: $e]");
    _fail++;
  }
}

void checkThrows(String label, String input) {
  try {
    describe(parse(input));
    print("  ✗  $label  [debió lanzar excepción pero no lo hizo]");
    _fail++;
  } catch (_) {
    print("  ✓  $label  (lanzó excepción correctamente)");
    _pass++;
  }
}

void group(String name, void Function() body) {
  print("\n$name");
  body();
}

// ── Tests ─────────────────────────────────────────────────────────────────

void main() {
  group("Literales básicos", () {
    check("char solo",       "a",   "a");
    check("dos chars",       "ab",  "cat(a,b)");
    check("tres chars",      "abc", "cat(cat(a,b),c)");
  });

  group("Operadores unarios — precedencia mayor que concat", () {
    // * debe aplicarse solo a b, no a todo ab
    check("star solo",       "a*",   "star(a)");
    check("plus solo",       "a+",   "plus(a)");
    check("question solo",   "a?",   "q(a)");

    // En ab*, el * es solo sobre b
    check("* solo sobre b en ab*",   "ab*",  "cat(a,star(b))");
    check("+ solo sobre b en ab+",   "ab+",  "cat(a,plus(b))");
    check("? solo sobre b en ab?",   "ab?",  "cat(a,q(b))");
  });

  group("Asociatividad izquierda — concat", () {
    // abc debe agrupar como (ab)c, no a(bc)
    check("abc left-assoc",  "abc",  "cat(cat(a,b),c)");
    check("abcd left-assoc", "abcd", "cat(cat(cat(a,b),c),d)");
  });

  group("Asociatividad izquierda — unión", () {
    // a|b|c debe agrupar como (a|b)|c, no a|(b|c)
    check("a|b|c left-assoc",    "a|b|c",    "or(or(a,b),c)");
    check("a|b|c|d left-assoc",  "a|b|c|d",  "or(or(or(a,b),c),d)");
  });

  group("Precedencia concat > unión", () {
    // ab|c debe ser (ab)|c, no a(b|c)
    check("ab|c",   "ab|c",   "or(cat(a,b),c)");
    check("a|bc",   "a|bc",   "or(a,cat(b,c))");
    check("ab|cd",  "ab|cd",  "or(cat(a,b),cat(c,d))");
  });

  group("Paréntesis cambian la precedencia", () {
    check("(ab)*",        "(ab)*",      "star(cat(a,b))");
    check("(a|b)*",       "(a|b)*",     "star(or(a,b))");
    check("(a|b)*c",      "(a|b)*c",    "cat(star(or(a,b)),c)");
    check("a(b|c)",       "a(b|c)",     "cat(a,or(b,c))");
    check("(a|b)(c|d)",   "(a|b)(c|d)", "cat(or(a,b),or(c,d))");
  });

  group("Caso clásico del Dragon Book", () {
    // (a|b)*abb
    check(
      "(a|b)*abb",
      "(a|b)*abb",
      "cat(cat(cat(star(or(a,b)),a),b),b)",
    );
  });

  group("Errores — el parser debe lanzar excepción", () {
    checkThrows("operador sin operando: *",   "*");
    checkThrows("operador sin operando: +",   "+");
    checkThrows("operador sin operando: |a",  "|a");
    checkThrows("paréntesis sin cerrar",      "(ab");
    checkThrows("paréntesis de más",          "ab)");
    checkThrows("doble operador a**",         "a**");
  });

  // ── Resultado final ───────────────────────────────────────────────────────
  print("\n${"-" * 45}");
  print("  $_pass passed  |  $_fail failed  |  ${_pass + _fail} total");
  if (_fail == 0) {
    print("  ✓ Precedencia y asociatividad correctas.");
  } else {
    print("  ✗ Hay fallos — revisa los casos marcados.");
  }
}
