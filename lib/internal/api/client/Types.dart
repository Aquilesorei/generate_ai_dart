
class InternalGenerationConfig {
  final double? temperature;
  final double? topP;
  final int? topK;
  final int? candidateCount;
  final int? maxOutputTokens;
  final List<String>? stopSequences;

  InternalGenerationConfig({
    this.temperature,
    this.topP,
    this.topK,
    this.candidateCount,
    this.maxOutputTokens,
    this.stopSequences,
  });

  factory InternalGenerationConfig.fromJson(Map<String, dynamic> json) {
    return InternalGenerationConfig(
      temperature: json['temperature']?.toDouble(),
      topP: json['top_p']?.toDouble(),
      topK: json['top_k']?.toInt(),
      candidateCount: json['candidate_count']?.toInt(),
      maxOutputTokens: json['max_output_tokens']?.toInt(),
      stopSequences: (json['stop_sequences'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'top_p': topP,
      'top_k': topK,
      'candidate_count': candidateCount,
      'max_output_tokens': maxOutputTokens,
      'stop_sequences': stopSequences,
    }..removeWhere((key, value) => value == null);
  }
}
