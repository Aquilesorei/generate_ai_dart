
import 'Candidate.dart';
/// Feedback on the prompt provided in the request.
class PromptFeedback {
  /// The reason that content was blocked, if at all.
  final BlockReason? blockReason;

  /// A list of relevant safety ratings.
  final List<SafetyRating> safetyRatings;

  PromptFeedback({
    this.blockReason,
    required this.safetyRatings,
  });
}

/// Describes why content was blocked.
enum BlockReason {
  /// A new and not yet supported value.
  UNKNOWN,

  /// Content was blocked for an unspecified reason.
  UNSPECIFIED,

  /// Content was blocked for violating provided safety settings.
  SAFETY,

  /// Content was blocked for another reason.
  OTHER,
}
