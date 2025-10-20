/// Represents an error or failure in the application.
///
/// This class is used to encapsulate details of failures that occur during
/// execution of the application. It contains a message that can provide
/// more information about the failure.
class Failure {
  /// Creates a [Failure] instance with an optional error [message].
  ///
  /// If no message is provided, a default message is used.
  Failure([this.message = 'An unexpected error has occurred.']);

  /// A message that describes the failure.
  ///
  /// This message provides additional information about what went wrong.
  /// Defaults to a generic error message if not specified.
  final String message;
}
