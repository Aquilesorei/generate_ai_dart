

import '../shared/Types.dart';

class InternalPromptFeedback {
  final InternalBlockReason? blockReason;
  final List<InternalSafetyRating>? safetyRatings;

  InternalPromptFeedback({this.blockReason, this.safetyRatings});

  factory InternalPromptFeedback.fromJson(Map<String, dynamic> json) {
    return InternalPromptFeedback(
      blockReason: json['blockReason'] != null
          ? InternalBlockReason.fromJson(json['blockReason'])
          : null,
      safetyRatings: json['safetyRatings'] != null
          ? List<InternalSafetyRating>.from(
          json['safetyRatings'].map((x) => InternalSafetyRating.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (blockReason != null) {
      data['blockReason'] = blockReason?.toJson();
    }
    if (safetyRatings != null) {
      data['safetyRatings'] =
          safetyRatings?.map((x) => x.toJson()).toList();
    }
    return data;
  }
}

enum InternalBlockReason {

  UNKNOWN,
  UNSPECIFIED,
  SAFETY,
  OTHER;

  String toJson() {
    final res = values.byName(name);
    switch (res) {
      case UNSPECIFIED: return 'BLOCKED_REASON_UNSPECIFIED';
      default: return res.name;
    }

  }
  static InternalBlockReason fromJson(String json)  {
    switch (json) {
      case 'BLOCKED_REASON_UNSPECIFIED':
        return InternalBlockReason.UNSPECIFIED;
      default:
        return  values.byName(json);
    }
  }
}

class InternalSafetyRating {
  final InternalHarmCategory category;
  final InternalHarmProbability probability;
  final bool? blocked;

  InternalSafetyRating({
    required this.category,
    required this.probability,
    this.blocked,
  });

  factory InternalSafetyRating.fromJson(Map<String, dynamic> json) {
    return InternalSafetyRating(
      category: InternalHarmCategory.fromJson(json['category']),
      probability: HarmProbabilityExtension.fromString(json['probability']),
      blocked: json['blocked'] != null ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.toJson(),
      'probability': probability.value,
      'blocked': blocked,
    };
  }
}


enum InternalHarmProbability {
  UNKNOWN,
  UNSPECIFIED,
  NEGLIGIBLE,
  LOW,
  MEDIUM,
  HIGH,
}

extension HarmProbabilityExtension on InternalHarmProbability {
  String get value {
    switch (this) {
      case InternalHarmProbability.UNKNOWN:
        return 'UNKNOWN';
      case InternalHarmProbability.UNSPECIFIED:
        return 'UNSPECIFIED';
      case InternalHarmProbability.NEGLIGIBLE:
        return 'NEGLIGIBLE';
      case InternalHarmProbability.LOW:
        return 'LOW';
      case InternalHarmProbability.MEDIUM:
        return 'MEDIUM';
      case InternalHarmProbability.HIGH:
        return 'HIGH';
    }
  }

  static InternalHarmProbability fromString(String value) {
    switch (value) {
      case 'UNKNOWN':
        return InternalHarmProbability.UNKNOWN;
      case 'UNSPECIFIED':
        return InternalHarmProbability.UNSPECIFIED;
      case 'NEGLIGIBLE':
        return InternalHarmProbability.NEGLIGIBLE;
      case 'LOW':
        return InternalHarmProbability.LOW;
      case 'MEDIUM':
        return InternalHarmProbability.MEDIUM;
      case 'HIGH':
        return InternalHarmProbability.HIGH;
      default:
        throw ArgumentError('Invalid value: $value');
    }
  }
}


class InternalCandidate {
  final InternalContent? content;
  final InternalFinishReason? finishReason;
  final List<InternalSafetyRating>? safetyRatings;
  final InternalCitationMetadata? citationMetadata;

  InternalCandidate({
    this.content,
    this.finishReason,
    this.safetyRatings,
    this.citationMetadata,
  });

  factory InternalCandidate.fromJson(Map<String, dynamic> json){
    return InternalCandidate(
      content: InternalContent.fromJson(json['content']),
      finishReason:  InternalFinishReason.fromJson(json['finishReason']),
      safetyRatings: json['safetyRatings'] != null
          ? List<InternalSafetyRating>.from(
          json['safetyRatings'].map((x) => InternalSafetyRating.fromJson(x)))
          : null,
      citationMetadata:json['citationMetadata'] != null ? InternalCitationMetadata.fromJson(json['citationMetadata'])  : null
    );
  }

  Map<String, dynamic> toJson() {
   return {
     'content' : content?.toJson(),
     'finishReason' : finishReason?.toJson(),
     'safetyRatings' : safetyRatings?.map((e) => e.toJson()).toList(),
     'citationMetadata' : citationMetadata?.toJson(),
   };
  }
}


class InternalCitationMetadata {
  final List<InternalCitationSources>? citationSources;

  InternalCitationMetadata({required this.citationSources});

  factory InternalCitationMetadata.fromJson(Map<String, dynamic> json) {
   return InternalCitationMetadata(
      citationSources: json['citationSources'] != null
          ? List<InternalCitationSources>.from(
          json['citationSources'].map((x) => InternalCitationSources.fromJson(x)))
          : null,
    );
  }


  Map<String, dynamic> toJson() {
   return {
     'citationSources' : citationSources?.map((e) => e.toJson()).toList(),
   };
  }
}


class InternalCitationSources {
  final int startIndex;
  final int endIndex;
  final String uri;
  final String license;

  InternalCitationSources({
    required this.startIndex,
    required this.endIndex,
    required this.uri,
    required this.license,
  });

  factory InternalCitationSources.fromJson(Map<String, dynamic> json) {
    return InternalCitationSources(startIndex: json['startIndex'], endIndex: json['endIndex,'] ,uri: json['uri'], license: json['licence']);
  }
  Map<String, dynamic> toJson(){
    return {
      'startIndex' : startIndex,
      'endIndex' : endIndex,
      'uri' : uri,
      'license' : license
    };
  }
}




class InternalGRpcError {
  final int code;
  final String message;

  InternalGRpcError({
    required this.code,
    required this.message,
  });
  factory InternalGRpcError.fromJson(Map<String, dynamic> json) {
    return InternalGRpcError(code: json['code'], message: json['message']);
  }
  Map<String, dynamic> toJson(){
    return {
      'code' : code,
      'message' : message,
    };
  }
}

enum InternalFinishReason {
  UNKNOWN,
  UNSPECIFIED,
  STOP,
  MAX_TOKENS,
  SAFETY,
  RECITATION,
  OTHER;


  String toJson() {
    final res = values.byName(name);
    switch (res) {
      case UNSPECIFIED: return 'FINISH_REASON_UNSPECIFIED';
      default: return res.name;
    }

  }
  static InternalFinishReason fromJson(String json)  {
    switch (json) {
      case 'FINISH_REASON_UNSPECIFIED':
        return InternalFinishReason.UNSPECIFIED;
      default:
        return  values.byName(json);
    }
  }
}
