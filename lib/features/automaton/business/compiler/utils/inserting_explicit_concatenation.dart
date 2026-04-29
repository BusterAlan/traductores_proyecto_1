String _insertConcatenation(String regex) {
  final buffer = StringBuffer();

  for (int i = 0; i < regex.length; i++) {
    final curr = regex[i];
    buffer.write(curr);

    if (i + 1 < regex.length) {
      final next = regex[i + 1];
      if (_shouldInsertConcat(curr, next)) {
        buffer.write(".");
      }
    }
  }

  return buffer.toString();
}

bool _shouldInsertConcat(String curr, String next) {
  final currIsOperand = _isOperand(curr);
  final currIsClose = curr == ")";
  final currIsUnary = _unaryPostfix.contains(curr);

  final nextIsOperand = _isOperand(next);
  final nextIsOpen = next == "(";

  final leftOk = currIsOperand || currIsClose || currIsUnary;
  final rightOk = nextIsOperand || nextIsOpen;

  return leftOk && rightOk;
}

bool _isOperand(String ch) =>
    !_operators.contains(ch) && ch != "(" && ch != ")";
