const _operators = {"|", "*", "+", "?", "."};
const _unaryPostfix = {"*", "+", "?"};

LanguageFailure? _validateCharacters(String regex) {
  // Permite letras, dígitos, operadores, paréntesis y ε (epsilon literal)
  final allowed = RegExp(r"^[a-zA-Z0-9|*+?()\.\u03b5]+$");
  if (!allowed.hasMatch(regex)) {
    return InvalidRegexFailure(
      'Carácter no soportado en: "$regex". '
      "Usa letras, dígitos y operadores: | * + ? ( )",
    );
  }
  return null;
}
