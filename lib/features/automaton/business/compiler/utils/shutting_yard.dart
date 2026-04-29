int _precedence(String op) => switch (op) {
      "|" => 1,
      "." => 2,
      "*" || "+" || "?" => 3,
      _ => 0,
    };

bool _isLeftAssociative(String op) => op != "*" && op != "+" && op != "?";

Either<LanguageFailure, String> _toPostfix(String regexWithConcat) {
  final output = StringBuffer();
  final stack = <String>[];

  for (int i = 0; i < regexWithConcat.length; i++) {
    final token = regexWithConcat[i];

    if (_isOperand(token)) {
      // Operando: va directo al output
      output.write(token);
    } else if (token == "(") {
      stack.add(token);
    } else if (token == ")") {
      // Vaciar stack hasta encontrar '('
      bool foundOpen = false;
      while (stack.isNotEmpty) {
        final top = stack.removeLast();
        if (top == "(") {
          foundOpen = true;
          break;
        }
        output.write(top);
      }
      if (!foundOpen) {
        return left(InvalidRegexFailure(
          "Paréntesis desbalanceados al procesar postfix.",
        ));
      }
    } else if (_operators.contains(token)) {
      // Operador: respetar precedencia y asociatividad
      while (stack.isNotEmpty &&
          stack.last != "(" &&
          (_precedence(stack.last) > _precedence(token) ||
              (_precedence(stack.last) == _precedence(token) &&
                  _isLeftAssociative(token)))) {
        output.write(stack.removeLast());
      }
      stack.add(token);
    }
  }

  // Vaciar el stack restante
  while (stack.isNotEmpty) {
    final op = stack.removeLast();
    if (op == "(" || op == ")") {
      return left(InvalidRegexFailure(
        "Paréntesis sin cerrar al finalizar la expresión.",
      ));
    }
    output.write(op);
  }

  return right(output.toString());
}
