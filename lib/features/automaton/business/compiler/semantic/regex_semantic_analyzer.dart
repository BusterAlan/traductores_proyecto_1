import "package:fpdart/fpdart.dart";

import "../../../../../core/errors/languaje_failures.dart";
import "../ast/base_node.dart";
import "../ast/nodes.dart";
import "regex_semantic_analysis.dart";

/// Analiza semánticamente el AST de una expresión regular.
///
/// Genera la tabla de símbolos, los primeros/últimos conjuntos y el
/// `followpos`, que son datos estructurales útiles para validación y
/// documentación del compilador.
class RegexSemanticAnalyzer {
  /// Analiza [ast] y devuelve los resultados semánticos.
  Either<LanguageFailure, RegexSemanticAnalysis> analyze(RegexNode ast) {
    _reset();

    final semantic = _analyzeNode(ast);
    return right(
      RegexSemanticAnalysis(
        ast: ast,
        alphabet: _alphabet,
        postfix: semantic.postfix,
        nullable: semantic.nullable,
        positions: Map.unmodifiable(_positions),
        firstpos: _firstpos
            .map((key, value) => MapEntry(key, Set.unmodifiable(value))),
        lastpos: _lastpos
            .map((key, value) => MapEntry(key, Set.unmodifiable(value))),
        followpos: _followpos
            .map((key, value) => MapEntry(key, Set.unmodifiable(value))),
      ),
    );
  }

  final Map<int, String> _positions = {};
  final Map<RegexNode, Set<int>> _firstpos = {};
  final Map<RegexNode, Set<int>> _lastpos = {};
  final Map<int, Set<int>> _followpos = {};
  final Set<String> _alphabet = {};
  int _nextPosition = 0;

  void _reset() {
    _positions.clear();
    _firstpos.clear();
    _lastpos.clear();
    _followpos.clear();
    _alphabet.clear();
    _nextPosition = 0;
  }

  _SemanticNodeInfo _analyzeNode(RegexNode node) {
    if (node is CharNode) {
      final position = _nextPosition++;
      _alphabet.add(node.value);
      _positions[position] = node.value;

      final first = {position};
      final last = {position};

      _firstpos[node] = first;
      _lastpos[node] = last;

      return _SemanticNodeInfo(
        nullable: false,
        firstpos: first,
        lastpos: last,
        postfix: node.value,
      );
    }

    if (node is ConcatNode) {
      final left = _analyzeNode(node.left);
      final right = _analyzeNode(node.right);

      final firstPositions = left.nullable
          ? {...left.firstpos, ...right.firstpos}
          : {...left.firstpos};
      final lastPositions = right.nullable
          ? {...left.lastpos, ...right.lastpos}
          : {...right.lastpos};

      for (final position in left.lastpos) {
        _followpos.update(
          position,
          (existing) => {...existing, ...right.firstpos},
          ifAbsent: () => {...right.firstpos},
        );
      }

      _firstpos[node] = firstPositions;
      _lastpos[node] = lastPositions;

      return _SemanticNodeInfo(
        nullable: left.nullable && right.nullable,
        firstpos: firstPositions,
        lastpos: lastPositions,
        postfix: "${left.postfix}${right.postfix}.",
      );
    }

    if (node is OrNode) {
      final left = _analyzeNode(node.left);
      final right = _analyzeNode(node.right);

      final firstPositions = {...left.firstpos, ...right.firstpos};
      final lastPositions = {...left.lastpos, ...right.lastpos};

      _firstpos[node] = firstPositions;
      _lastpos[node] = lastPositions;

      return _SemanticNodeInfo(
        nullable: left.nullable || right.nullable,
        firstpos: firstPositions,
        lastpos: lastPositions,
        postfix: "${left.postfix}${right.postfix}|",
      );
    }

    if (node is StarNode) {
      final child = _analyzeNode(node.node);
      final firstPositions = {...child.firstpos};
      final lastPositions = {...child.lastpos};

      for (final position in child.lastpos) {
        _followpos.update(
          position,
          (existing) => {...existing, ...child.firstpos},
          ifAbsent: () => {...child.firstpos},
        );
      }

      _firstpos[node] = firstPositions;
      _lastpos[node] = lastPositions;

      return _SemanticNodeInfo(
        nullable: true,
        firstpos: firstPositions,
        lastpos: lastPositions,
        postfix: "${child.postfix}*",
      );
    }

    if (node is PlusNode) {
      final child = _analyzeNode(node.node);
      final firstPositions = {...child.firstpos};
      final lastPositions = {...child.lastpos};

      for (final position in child.lastpos) {
        _followpos.update(
          position,
          (existing) => {...existing, ...child.firstpos},
          ifAbsent: () => {...child.firstpos},
        );
      }

      _firstpos[node] = firstPositions;
      _lastpos[node] = lastPositions;

      return _SemanticNodeInfo(
        nullable: child.nullable,
        firstpos: firstPositions,
        lastpos: lastPositions,
        postfix: "${child.postfix}+",
      );
    }

    if (node is QuestionNode) {
      final child = _analyzeNode(node.node);
      _firstpos[node] = {...child.firstpos};
      _lastpos[node] = {...child.lastpos};

      return _SemanticNodeInfo(
        nullable: true,
        firstpos: {...child.firstpos},
        lastpos: {...child.lastpos},
        postfix: "${child.postfix}?",
      );
    }

    return const _SemanticNodeInfo(
      nullable: false,
      firstpos: {},
      lastpos: {},
      postfix: "",
    );
  }
}

class _SemanticNodeInfo {
  const _SemanticNodeInfo({
    required this.nullable,
    required this.firstpos,
    required this.lastpos,
    required this.postfix,
  });

  final bool nullable;
  final Set<int> firstpos;
  final Set<int> lastpos;
  final String postfix;
}
