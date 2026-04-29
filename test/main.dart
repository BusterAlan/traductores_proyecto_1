// ignore_for_file: avoid_print

import "package:traductores_proyecto_1/features/automaton/business/compiler/ast/base_node.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/ast/nodes.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/lexer/regex_lexer.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/parser/regex_parser.dart";

void main() {
  void check(String input, String expected) {
    final tokens = RegexLexer().tokenize(input);
    final node = RegexParser(tokens).parse();
    final actual = _describe(node);
    final ok = actual == expected;
    print(
      '${ok ? "✓" : "✗"} "$input" → $actual ${ok ? "" : "(esperado: $expected)"}',
    );
  }

  check("ab*", "concat(a, star(b))");
  check("ab|c", "or(concat(a,b), c)");
  check("abc", "concat(concat(a,b), c)");
  check("a|b|c", "or(or(a,b), c)");
  check("a*b*", "concat(star(a), star(b))");
  check("(a|b)*c", "concat(star(or(a,b)), c)");
}

String _describe(RegexNode node) => switch (node) {
      final CharNode n => n.value,
      final StarNode n => "star(${_describe(n.node)})",
      final ConcatNode n =>
        "concat(${_describe(n.left)},${_describe(n.right)})",
      final OrNode n => "or(${_describe(n.left)},${_describe(n.right)})",
      _ => "?",
    };
