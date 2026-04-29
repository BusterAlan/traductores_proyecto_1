import "package:flutter_common_classes/errors/failure.dart";

/// Base class of failure about languaje
abstract class LanguageFailure extends Failure {
  /// Base class of failure about languaje
  LanguageFailure({required super.message, required super.title});
}

/// Failure for invalid regex syntax
class InvalidRegexFailure extends LanguageFailure {
  /// Failure for invalid regex syntax
  InvalidRegexFailure(String message)
      : super(
          message: message,
          title: "Expresión regular inválida",
        );
}

/// Failure for non-regular language
class NonRegularLanguageFailure extends LanguageFailure {
  /// Failure for non-regular language
  NonRegularLanguageFailure(String message)
      : super(
          message: message,
          title: "Lenguaje no regular",
        );
}

/// Failure during NFA construction
class NfaBuildFailure extends LanguageFailure {
  /// Failure during NFA construction
  NfaBuildFailure(String message)
      : super(
          message: message,
          title: "Error en construcción de NFA",
        );
}

/// Failure during DFA conversion
class DfaConversionFailure extends LanguageFailure {
  /// Failure during DFA conversion
  DfaConversionFailure(String message)
      : super(
          message: message,
          title: "Error en conversión a DFA",
        );
}

/// Failure during DOT generation
class DotGenerationFailure extends LanguageFailure {
  /// Failure during DOT generation
  DotGenerationFailure(String message)
      : super(
          message: message,
          title: "Error en generación de DOT",
        );
}
