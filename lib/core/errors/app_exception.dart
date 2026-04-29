/// Exception class for the application.
///
/// This class is used to handle the exceptions in the application.
class AppException implements Exception {
  /// Exception class for the application.
  ///
  /// This class is used to handle the exceptions in the application.
  AppException({
    this.title = "Error",
    this.message =
        "Ocurrió un error inesperado. Por favor, intenta nuevamente.",
  });

  /// The title of the exception.
  final String title;

  /// The message of the exception.
  final String message;
}

/// Exception thrown when a connection with the environment fails.
class EnvironmentException extends AppException {
  /// Exception thrown when a connection with the environment fails.
  EnvironmentException({
    super.title = "Error de ambiente",
    super.message =
        "Ocurrió un error con el ambiente. Por favor, intenta nuevamente.",
  });
}
