

import 'dart:convert';

import 'package:generate_ai_dart/internal/api/shared/Types.dart';

import 'client/Types.dart';

abstract class Request {
  // Implement common methods or properties if needed
  Map<String, dynamic> toJson();
}

class GenerateContentRequest extends Request {
  final String model;
  final List<InternalContent> contents;
  final List<InternalSafetySetting>? safetySettings;
  final InternalGenerationConfig? generationConfig;

  GenerateContentRequest({
    required this.model,
    required this.contents,
    this.safetySettings,
    this.generationConfig,
  });

  factory GenerateContentRequest.fromJson(Map<String, dynamic> json) {
    return GenerateContentRequest(
      model: json['model'],
      contents: List<InternalContent>.from(
          json['contents'].map((x) => InternalContent.fromJson(x))),
      safetySettings: json['safety_settings'] != null
          ? List<InternalSafetySetting>.from(
          json['safety_settings'].map((x) => InternalSafetySetting.fromJson(x)))
          : null,
      generationConfig: json['generation_config'] != null
          ? InternalGenerationConfig.fromJson(json['generation_config'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'model': model,
      'contents': contents.map((x) => x.toJson()).toList(),
    };
    if (safetySettings != null) {
      data['safety_settings'] =
          safetySettings?.map((x) => x.toJson()).toList();
    }
    if (generationConfig != null) {
      data['generation_config'] = generationConfig?.toJson();
    }
    return data;
  }
}

class CountTokensRequest extends Request {
  final String model;
  final List<InternalContent> contents;

  CountTokensRequest({
    required this.model,
    required this.contents,
  });

  factory CountTokensRequest.fromJson(Map<String, dynamic> json) {
    return CountTokensRequest(
      model: json['model'],
      contents: List<InternalContent>.from(
          json['contents'].map((x) => InternalContent.fromJson(x))),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'contents': contents.map((x) => x.toJson()).toList(),
    };
  }
}
