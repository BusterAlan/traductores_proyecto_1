import "base_node.dart";

/// Character node class
class CharNode extends RegexNode {
  /// Character node class
  CharNode(this.value);

  /// Value
  final String value;
}

/// Concatenation node class
class ConcatNode extends RegexNode {
  /// Concatenation node class
  ConcatNode(this.left, this.right);

  /// Left node value
  final RegexNode left;

  /// Right node value
  final RegexNode right;
}

/// Or node class
class OrNode extends RegexNode {
  /// Or node class
  OrNode(this.left, this.right);

  /// Left node value
  final RegexNode left;

  /// Right node value
  final RegexNode right;
}

/// Star node class
class StarNode extends RegexNode {
  /// Star node class
  StarNode(this.node);

  /// Node value
  final RegexNode node;
}
