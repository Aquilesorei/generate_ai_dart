/// Represents the threshold for some [HarmCategory] that is allowed and blocked by [SafetySetting]s.
enum  BlockThreshold {
/// The threshold was not specified.
UNSPECIFIED,

/// Content with negligible harm is allowed.
LOW_AND_ABOVE,

/// Content with negligible to low harm is allowed.
MEDIUM_AND_ABOVE,

/// Content with negligible to medium harm is allowed.
ONLY_HIGH,

/// All content is allowed regardless of harm.
NONE
}
