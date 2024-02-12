
import 'type.dart';

/// Parent class for any errors that occur from [GenerativeModel].
class GoogleGenerativeAIException implements Exception {
  final String message;
  final dynamic cause;

  GoogleGenerativeAIException(this.message, [this.cause]);


  /// Converts a [Throwable] to a [GoogleGenerativeAIException].
  static GoogleGenerativeAIException from(dynamic cause) {
    if (cause is GoogleGenerativeAIException) {
      return cause;
    } else if ( cause is SerializationException) {
      return SerializationException("Something went wrong while trying to deserialize a response from the server.", cause);
    } else {
      return UnknownException("Something unexpected happened.", cause);
    }
  }

  @override
  String toString() {
    return 'GoogleGenerativeAIException: $message';
  }
}



/// Something went wrong while trying to deserialize a response from the server.
class SerializationException extends GoogleGenerativeAIException {
  SerializationException(super.message, [super.cause]);
}

/// The server responded with a non 200 response code.
class ServerException extends GoogleGenerativeAIException {
  ServerException(super.message, [super.cause]);
}

/// A request was blocked for some reason.
///
/// See the [response's][response] `promptFeedback.blockReason` for more information.
class PromptBlockedException extends GoogleGenerativeAIException {
  final GenerateContentResponse response;

  PromptBlockedException(this.response, [dynamic cause])
      : super("Prompt was blocked: ${response.promptFeedback?.blockReason?.name}", cause);
}

/// Some form of state occurred that shouldn't have.
///
/// Usually indicative of consumer error.
class InvalidStateException extends GoogleGenerativeAIException {
  InvalidStateException(super.message, [super.cause]);
}

/// A request was stopped during generation for some reason.
class ResponseStoppedException extends GoogleGenerativeAIException {
  final GenerateContentResponse response;

  ResponseStoppedException(this.response, [dynamic cause])
      : super("Content generation stopped. Reason: ${response.candidates.first.finishReason?.name}", cause);
}

/// Catch all case for exceptions not explicitly expected.
class UnknownException extends GoogleGenerativeAIException {
  UnknownException(super.message, [super.cause]);
}

/// Converts a [dynamic] to a [GoogleGenerativeAIException].
///
/// Will populate default messages as expected, and propagate the provided [cause] through the
/// resulting exception.
GoogleGenerativeAIException from(dynamic cause) {
  if (cause is GoogleGenerativeAIException) {
    return cause;
  } else  if ( cause is SerializationException) {
    return SerializationException(
      "Something went wrong while trying to deserialize a response from the server.",
      cause,
    );
  } else {
    return UnknownException("Something unexpected happened.", cause);
  }

}