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

/// Nodo de cerradura positiva — una o más repeticiones.
/// Equivalente a `aa*`.
/// Ejemplo: `a+` → PlusNode(CharNode(a))
class PlusNode extends RegexNode {
  /// Nodo de cerradura positiva — una o más repeticiones.
  PlusNode(this.node);
 
  /// Subexpresión sobre la que se aplica.
  final RegexNode node;
}
 
/// Nodo opcional — cero o una ocurrencia.
/// Equivalente a `(a|ε)`.
/// Ejemplo: `a?` → QuestionNode(CharNode(a))
class QuestionNode extends RegexNode {
  /// Nodo opcional — cero o una ocurrencia.
  QuestionNode(this.node);
 
  /// Subexpresión sobre la que se aplica.
  final RegexNode node;
}
