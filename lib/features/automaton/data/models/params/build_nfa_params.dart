import "package:flutter_common_classes/constants/classes/params.dart";

import "../../../business/compiler/ast/base_node.dart";
import "../../../business/entities/regex_expression_entity.dart";

/// Build nfa params class
class BuildNfaParams extends Params {
  /// Build nfa params class
  BuildNfaParams({required this.expression, required this.ast});

  /// Regular expression entity value
  final RegexExpressionEntity expression;

  /// Abstract syntax tree value
  final RegexNode ast;
}
