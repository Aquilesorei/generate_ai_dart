
import 'Content.dart';
import 'HarmCategory.dart';
import 'HarmProbability.dart';
/// A piece of a response from the model. Contains safety ratings, citation metadata,
/// and an optional finish reason in addition to the content of the response.
class Candidate {
  final Content content;
  final List<SafetyRating> safetyRatings;
  final List<CitationMetadata> citationMetadata;
  final FinishReason? finishReason;

  Candidate(
      {required this.content,
      required this.safetyRatings,
      required this.citationMetadata,
      this.finishReason});
}

/// Rating for a particular harm category with a provided harm probability.
class SafetyRating {
  final HarmCategory category;
  final HarmProbability probability;

  SafetyRating(this.category, this.probability);
}

/// Provides citation metadata for sourcing of content provided by the model between a given
/// start index and end index.
class CitationMetadata {
  final int startIndex;
  final int endIndex;
  final String uri;
  final String license;

  CitationMetadata({required this.startIndex, required this.endIndex, required this.uri, required this.license});
}

/// The reason for content finishing.
enum FinishReason {
  /// A new and not yet supported value.
  UNKNOWN,

  /// Reason is unspecified.
  UNSPECIFIED,

  /// Model finished successfully and stopped.
  STOP,

  /// Model hit the token limit.
  MAX_TOKENS,

  /// Safety settings prevented the model from outputting content.
  SAFETY,

  /// Model began looping.
  RECITATION,

  /// Model stopped for another reason.
  OTHER
}
