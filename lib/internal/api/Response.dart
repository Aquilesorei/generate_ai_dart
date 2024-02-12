

import 'package:generate_ai_dart/internal/api/server/Types.dart';

abstract class Response {
  Map<String, dynamic> toJson();
}

class GenerateContentResponse extends Response {
  final List<InternalCandidate>? candidates;
  final InternalPromptFeedback? promptFeedback;

  GenerateContentResponse({this.candidates, this.promptFeedback});

  factory GenerateContentResponse.fromJson(Map<String, dynamic> json) {

    return GenerateContentResponse(
      candidates: json['candidates'] != null
          ? List<InternalCandidate>.from(
          json['candidates'].map((x) => InternalCandidate.fromJson(x)))
          : null,
      promptFeedback: json['promptFeedback'] != null
          ? InternalPromptFeedback.fromJson(json['promptFeedback'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (candidates != null) {
      data['candidates'] = candidates?.map((x) => x.toJson()).toList();
    }
    if (promptFeedback != null) {
      data['promptFeedback'] = promptFeedback?.toJson();
    }
    return data;
  }
}

class CountTokensResponse extends Response {
  final int totalTokens;

  CountTokensResponse({required this.totalTokens});

  factory CountTokensResponse.fromJson(Map<String, dynamic> json) {
    return CountTokensResponse(totalTokens: json['totalTokens']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'totalTokens': totalTokens};
  }
}

class GRpcErrorResponse extends Response {
  final InternalGRpcError error;

  GRpcErrorResponse({required this.error});

  factory GRpcErrorResponse.fromJson(Map<String, dynamic> json) {
    return GRpcErrorResponse(error: InternalGRpcError.fromJson(json['error']));
  }

  @override
  Map<String, dynamic> toJson() {
    return {'error': error.toJson()};
  }
}
