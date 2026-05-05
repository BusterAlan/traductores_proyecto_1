import "package:flutter_test/flutter_test.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/lexer/regex_lexer.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/parser/regex_parser.dart";
import "package:traductores_proyecto_1/features/automaton/business/compiler/semantic/regex_semantic_analyzer.dart";

void main() {
  test("Analizador semántico produce tabla de símbolos para 'ab'", () {
    final tokens = RegexLexer().tokenize("ab");
    final ast = RegexParser(tokens).parse();
    final result = RegexSemanticAnalyzer().analyze(ast);

    expect(result.isRight(), isTrue);
    final analysis = result.getRight().toNullable()!;

    expect(analysis.alphabet, equals({"a", "b"}));
    expect(analysis.postfix, equals("ab."));
    expect(analysis.nullable, isFalse);
    expect(analysis.positions.length, equals(2));
    expect(analysis.positions[0], equals("a"));
    expect(analysis.positions[1], equals("b"));
    expect(analysis.followpos[0], equals({1}));
    expect(analysis.followpos.containsKey(1), isFalse);
  });

  test("Analizador semántico marca nullable en 'a*' y genera followpos", () {
    final tokens = RegexLexer().tokenize("a*");
    final ast = RegexParser(tokens).parse();
    final result = RegexSemanticAnalyzer().analyze(ast);

    expect(result.isRight(), isTrue);
    final analysis = result.getRight().toNullable()!;

    expect(analysis.alphabet, equals({"a"}));
    expect(analysis.postfix, equals("a*"));
    expect(analysis.nullable, isTrue);
    expect(analysis.positions.length, equals(1));
    expect(analysis.followpos[0], equals({0}));
  });
}
