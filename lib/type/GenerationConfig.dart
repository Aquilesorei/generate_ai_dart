/// Represents configuration parameters used for content generation.
class GenerationConfig {
  /// The temperature value for content generation.
  final double? temperature;

  /// The top-k value for content generation.
  final int? topK;

  /// The top-p value for content generation.
  final double? topP;

  /// The candidate count for content generation.
  final int? candidateCount;

  /// The maximum number of output tokens for content generation.
  final int? maxOutputTokens;

  /// The stop sequences for content generation.
  final List<String>? stopSequences;

  GenerationConfig({
    this.temperature,
    this.topK,
    this.topP,
    this.candidateCount,
    this.maxOutputTokens,
    this.stopSequences,
  });

  /// Constructs a [GenerationConfig] instance using the provided builder.
  factory GenerationConfig.fromBuilder(GenerationConfigBuilder builder) {
    return GenerationConfig(
      temperature: builder.temperature,
      topK: builder.topK,
      topP: builder.topP,
      candidateCount: builder.candidateCount,
      maxOutputTokens: builder.maxOutputTokens,
      stopSequences: builder.stopSequences,
    );
  }
}

/// Helper method to construct a [GenerationConfig] in a DSL-like manner.
GenerationConfig generationConfig(void Function(GenerationConfigBuilder) init) {
  var builder = GenerationConfigBuilder();
  init(builder);
  return builder.build();
}

/// A builder class to construct [GenerationConfig] objects.
class GenerationConfigBuilder {
  double? temperature;
  int? topK;
  double? topP;
  int? candidateCount;
  int? maxOutputTokens;
  List<String>? stopSequences;

  /// Constructs a [GenerationConfig] instance using the current builder state.
  GenerationConfig build() {
    return GenerationConfig(
      temperature: temperature,
      topK: topK,
      topP: topP,
      candidateCount: candidateCount,
      maxOutputTokens: maxOutputTokens,
      stopSequences: stopSequences,
    );
  }
}
