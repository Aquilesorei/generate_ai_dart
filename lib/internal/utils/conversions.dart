import 'dart:typed_data';

import 'package:generate_ai_dart/internal/api/client/Types.dart';
import 'package:generate_ai_dart/internal/api/server/Types.dart';
import 'package:generate_ai_dart/internal/api/shared/Types.dart';
import 'package:generate_ai_dart/type/type.dart' as public_types;
import 'dart:convert';
import 'package:generate_ai_dart/internal/api/Response.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';


extension ContentInternal on public_types.Content {


  Future<InternalContent> toInternal() async {
   final res = await Future.wait(parts.map((part) async => await part.toInternal()).toList());
    return InternalContent(role: role,parts:res );
  }
}



extension  PartInternal  on public_types.Part{

  Future<InternalPart> toInternal() async {
    if(this is public_types.TextPart){
      return InternalTextPart(asTextOrNull()!);
    }else if(this is public_types.ImagePart){
      final compressed = await compressToJpg(asImageOrNull()!);
     return InternalBlobPart(InternalBlob( mimeType: 'image/jpeg', data: base64Encode(compressed)));
    }else if(this is public_types.BlobPart){
      final t = this as public_types.BlobPart;
      return InternalBlobPart(InternalBlob( mimeType: t.mimeType, data: base64Encode(t.blob)));
    }
    else{
      throw public_types.SerializationException(
          "The given subclass of Part (${runtimeType.toString()}) is not supported in the serialization yet."
      );
    }
  }
}


extension Sa on public_types.SafetySetting {

  InternalSafetySetting   toInternal(){

    return InternalSafetySetting(category: harmCategory.toInternal(), threshold: threshold.toInternal());
  }
}

extension GC on public_types.GenerationConfig {

  InternalGenerationConfig   toInternal()  => InternalGenerationConfig(
      temperature: temperature,
      topP: topP,
      topK: topK,
      candidateCount: candidateCount,
      maxOutputTokens: maxOutputTokens,
      stopSequences: stopSequences
    );

}

extension  Ha on public_types.HarmCategory {

  /// Maps the external HarmCategory enum to the internal HarmCategory enum.
  InternalHarmCategory toInternal() {
    switch (this) {
      case public_types.HarmCategory.HARASSMENT:
        return InternalHarmCategory.HARASSMENT;
      case public_types.HarmCategory.HATE_SPEECH:
        return InternalHarmCategory.HATE_SPEECH;
      case public_types.HarmCategory.SEXUALLY_EXPLICIT:
        return InternalHarmCategory.SEXUALLY_EXPLICIT;
      case public_types.HarmCategory.DANGEROUS_CONTENT:
        return InternalHarmCategory.DANGEROUS_CONTENT;
      case public_types.HarmCategory.UNKNOWN:
        return InternalHarmCategory.UNKNOWN;
    }
  }

}

extension Bl on public_types.BlockThreshold {

  /// Maps the external BlockThreshold enum to the internal HarmBlockThreshold enum.
  InternalHarmBlockThreshold toInternal() {
    switch (this) {
      case public_types.BlockThreshold.NONE:
        return InternalHarmBlockThreshold.BLOCK_NONE;
      case public_types.BlockThreshold.ONLY_HIGH:
        return InternalHarmBlockThreshold.BLOCK_ONLY_HIGH;
      case public_types.BlockThreshold.MEDIUM_AND_ABOVE:
        return InternalHarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE;
      case public_types.BlockThreshold.LOW_AND_ABOVE:
        return InternalHarmBlockThreshold.BLOCK_LOW_AND_ABOVE;
      case public_types.BlockThreshold.UNSPECIFIED:
        return InternalHarmBlockThreshold.UNSPECIFIED;
    }
  }

}


extension ContentExternal on InternalContent {
  public_types.Content toPublic(){
    return public_types.Content(role: role, parts: parts!.map((e) => e.toPublic()).toList());
  }
}

extension PartExternal on InternalPart {
  public_types.Part toPublic(){
    if(this is InternalTextPart){
      final t = this as InternalTextPart;
      return public_types.TextPart(t.text);
    } else if(this is InternalBlobPart){
      final t = this as InternalBlobPart;
      return public_types.BlobPart(t.inlineData.mimeType,base64Decode(t.inlineData.data));
    } else {
      throw public_types.SerializationException(
          "The given subclass of Part (${runtimeType.toString()}) is not supported in the serialization yet."
      );
    }
  }
}

extension SafetySettingExternal on InternalSafetySetting {
  public_types.SafetySetting toPublic(){
    return public_types.SafetySetting(harmCategory: category.toPublic(), threshold: threshold.toPublic());
  }
}

extension GenerationConfigExternal on InternalGenerationConfig {
  public_types.GenerationConfig toPublic(){
    return public_types.GenerationConfig(
        temperature: temperature,
        topP: topP,
        topK: topK,
        candidateCount: candidateCount,
        maxOutputTokens: maxOutputTokens,
        stopSequences: stopSequences
    );
  }
}

extension HarmCategoryExternal on InternalHarmCategory {
  public_types.HarmCategory toPublic() {
    switch (this) {
      case InternalHarmCategory.HARASSMENT:
        return public_types.HarmCategory.HARASSMENT;
      case InternalHarmCategory.HATE_SPEECH:
        return public_types.HarmCategory.HATE_SPEECH;
      case InternalHarmCategory.SEXUALLY_EXPLICIT:
        return public_types.HarmCategory.SEXUALLY_EXPLICIT;
      case InternalHarmCategory.DANGEROUS_CONTENT:
        return public_types.HarmCategory.DANGEROUS_CONTENT;
      case InternalHarmCategory.UNKNOWN:
        return public_types.HarmCategory.UNKNOWN;
    }
  }
}

extension HarmBlockThresholdExternal on InternalHarmBlockThreshold {
  public_types.BlockThreshold toPublic() {
    switch (this) {
      case InternalHarmBlockThreshold.BLOCK_NONE:
        return public_types.BlockThreshold.NONE;
      case InternalHarmBlockThreshold.BLOCK_ONLY_HIGH:
        return public_types.BlockThreshold.ONLY_HIGH;
      case InternalHarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE:
        return public_types.BlockThreshold.MEDIUM_AND_ABOVE;
      case InternalHarmBlockThreshold.BLOCK_LOW_AND_ABOVE:
        return public_types.BlockThreshold.LOW_AND_ABOVE;
      case InternalHarmBlockThreshold.UNSPECIFIED:
        return public_types.BlockThreshold.UNSPECIFIED;
    }
  }
}

extension cts on  InternalCitationSources {
  public_types.CitationMetadata toPublic(){
   return public_types.CitationMetadata(startIndex : startIndex, endIndex : endIndex, uri : uri, license : license);
  }
}

extension sfr on InternalSafetyRating {

  public_types.SafetyRating  toPublic() => public_types.SafetyRating(category.toPublic(),probability.toPublic());
}


extension hpb on InternalHarmProbability {
  /// Maps the internal HarmProbability enum to the external HarmProbability enum.
  public_types.HarmProbability toPublic() {
    switch (this) {
      case InternalHarmProbability.HIGH:
        return public_types.HarmProbability.HIGH;
      case InternalHarmProbability.MEDIUM:
        return public_types.HarmProbability.MEDIUM;
      case InternalHarmProbability.LOW:
        return public_types.HarmProbability.LOW;
      case InternalHarmProbability.NEGLIGIBLE:
        return public_types.HarmProbability.NEGLIGIBLE;
      case InternalHarmProbability.UNSPECIFIED:
        return public_types.HarmProbability.UNSPECIFIED;
      case InternalHarmProbability.UNKNOWN:
        return public_types.HarmProbability.UNKNOWN;
    }
  }
}

extension br on InternalBlockReason {
  /// Maps the internal BlockReason enum to the external BlockReason enum.
  public_types.BlockReason toPublic() {
    switch (this) {
      case InternalBlockReason.UNSPECIFIED:
        return public_types.BlockReason.UNSPECIFIED;
      case InternalBlockReason.SAFETY:
        return public_types.BlockReason.SAFETY;
      case InternalBlockReason.OTHER:
        return public_types.BlockReason.OTHER;
      case InternalBlockReason.UNKNOWN:
        return public_types.BlockReason.UNKNOWN;
    }
  }
}


extension Grc on GenerateContentResponse{

  public_types.GenerateContentResponse toPublic() => public_types.GenerateContentResponse(
    candidates: candidates!.map((e) => e.toPublic()).toList()
  );
}
extension ctr on CountTokensResponse {

  public_types.CountTokensResponse toPublic() => public_types.CountTokensResponse(totalTokens);
}
extension fnr on InternalFinishReason {

  /// Maps the internal FinishReason? enum to the external FinishReason? enum.
  public_types.FinishReason? toPublic() {
    switch (this) {
      case null:
        return null;
      case InternalFinishReason.MAX_TOKENS:
        return public_types.FinishReason.MAX_TOKENS;
      case InternalFinishReason.RECITATION:
        return public_types.FinishReason.RECITATION;
      case InternalFinishReason.SAFETY:
        return public_types.FinishReason.SAFETY;
      case InternalFinishReason.STOP:
        return public_types.FinishReason.STOP;
      case InternalFinishReason.OTHER:
        return public_types.FinishReason.OTHER;
      case InternalFinishReason.UNSPECIFIED:
        return public_types.FinishReason.UNSPECIFIED;
      case InternalFinishReason.UNKNOWN:
        return public_types.FinishReason.UNKNOWN;
    }
  }

}

extension cdt on InternalCandidate {
  /// Maps the internal Candidate to the external Candidate.
  public_types.Candidate toPublic() {
    final safetyRatings = this.safetyRatings?.map((rating) => rating.toPublic()).toList() ?? [];
    final citations = citationMetadata?.citationSources?.map((source) => source.toPublic()).toList() ?? [];
    final finishReason = this.finishReason!.toPublic();

    return public_types.Candidate(
      content : content?.toPublic() ?? public_types.content(role : "model",init :  (b) {}),
     safetyRatings:  safetyRatings,
     citationMetadata:  citations,
     finishReason:  finishReason,
    );
  }

}

Future<Uint8List> compressToJpg(Uint8List bytes ) async {
  final image = ImageFile(filePath: '', rawBytes: bytes);
  final param = ImageFileConfiguration(input: image);
 return ( await compressor.compress(param)).rawBytes;
}