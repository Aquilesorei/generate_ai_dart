
import 'HarmCategory.dart';
import 'BlockThreshold.dart';
/// A configuration for a [BlockThreshold] of some [HarmCategory] allowed and blocked in responses.
class SafetySetting {
  /// The relevant [HarmCategory].
  final HarmCategory harmCategory;

  /// The threshold form harm allowable.
  final BlockThreshold threshold;

  SafetySetting({
    required this.harmCategory,
    required this.threshold,
  });
}
