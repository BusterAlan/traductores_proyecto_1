LanguageFailure? _validateParentheses(String regex) {
  int depth = 0;
  for (int i = 0; i < regex.length; i++) {
    if (regex[i] == "(") {
      depth++;
    }
    if (regex[i] == ")") {
      depth--;
    }
    if (depth < 0) {
      return InvalidRegexFailure(
        "Paréntesis de cierre sin apertura en posición $i.",
      );
    }
  }
  if (depth != 0) {
    return InvalidRegexFailure(
      "Faltan paréntesis de cierre.",
    );
  }
  return null;
}
