import 'dart:developer' as developer;

import 'Part.dart';
import 'Candidate.dart';
import 'PromptFeedBack.dart';
/// Represents a response from the model.
class GenerateContentResponse {
  /// A list of possible responses generated from the model
  final List<Candidate> candidates;

  /// Optional feedback for the given prompt. When streaming, it's only populated in the first response.
  final PromptFeedback? promptFeedback;

  GenerateContentResponse({required this.candidates, this.promptFeedback});

  /// Convenience field representing the first text part in the response, if it exists.
  String? get text {
    return _firstPartAs<TextPart>()?.text;
  }

  T? _firstPartAs<T extends Part>() {
    if (candidates.isEmpty) {
      _warn("No candidates were found, but was asked to get a candidate.");
      return null;
    }

    final parts = candidates.first.content.parts.whereType<T>();
    final otherParts = candidates.first.content.parts.where((part) => part is! T).toList();
    final type = T.toString();

    if (parts.isEmpty) {
      if (otherParts.isNotEmpty) {
        _warn(
            "We didn't find any $type, but we did find other part types. Did you ask for the right type?");
      }
      return null;
    }

    if (parts.length > 1) {
      _warn("Multiple $type were found, returning the first one.");
    } else if (otherParts.isNotEmpty) {
      _warn("Returning the only $type found, but other part types were present as well.");
    }

    return parts.first;
  }

  void _warn(String message) {
    developer.log(message, name: 'GenerateContentResponse');
  }
}
