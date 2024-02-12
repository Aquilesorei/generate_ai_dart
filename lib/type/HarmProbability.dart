/// Represents the probability that some [HarmCategory] is applicable in a [SafetyRating].
enum  HarmProbability {
/// A new and not yet supported value.
UNKNOWN,

/// Probability for harm is unspecified.
UNSPECIFIED,

/// Probability for harm is negligible.
NEGLIGIBLE,

/// Probability for harm is low.
LOW,

/// Probability for harm is medium.
MEDIUM,

/// Probability for harm is high.
HIGH,
}
