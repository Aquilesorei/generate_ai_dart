import 'dart:typed_data';

import 'package:generate_ai_dart/internal/utils/conversions.dart';
import 'package:generate_ai_dart/type/type.dart';
import 'package:rxdart/rxdart.dart';

import 'Chat.dart';
import 'internal/api/APIController.dart';
import 'internal/api/Request.dart' show GenerateContentRequest,CountTokensRequest;
import 'model.dart';


/// A facilitator for a given multimodal model (eg; Gemini).
///
/// [modelName] name of the model in the backend
/// [apiKey] authentication key for interacting with the backend
/// [generationConfig] configuration parameters to use for content generation
/// [safetySettings] the safety bounds to use during alongside prompts during content generation
class GenerativeModel {
  final String modelName;
  final String apiKey;
  final GenerationConfig? generationConfig;
  final List<SafetySetting>? safetySettings;
  final APIController _controller;

  GenerativeModel(
      this.modelName,
      this.apiKey, {
        this.generationConfig,
        this.safetySettings,
      }) : _controller = APIController(apiKey,modelName);



  /// Generates a response from the backend with the provided [Content]s.
  /// [prompt] A group of [Content]s to send to the model.
  /// Returns a [GenerateContentResponse] after some delay. Function should be called within a async function
  Future<GenerateContentResponse> generateContent(List<Content> prompt) async {
    try {
      return (await _controller.generateContent(await _buildRequest(prompt))).toPublic().validate();
    } catch (e) {
      throw GoogleGenerativeAIException.from(e);
    }
  }


  /// Generates a streaming response from the backend with the provided [Content]s.
  ///
  /// [prompt] A group of [Content]s to send to the model.
  /// Returns a [Stream] which will emit responses as they are returned from the model.
  /// TODO : implement and handle response with json stream parser
  Future<Stream<GenerateContentResponse>> generateContentStream(List<Content> prompt) async {
    throw UnimplementedError("no implemented yet ");
  }

  /// Generates a response from the backend with the provided text represented [Content].
  ///
  /// [prompt] The text to be converted into a single piece of [Content] to send to the model.
  /// Returns a [GenerateContentResponse] after some delay. Function should be called within a
  ///  async function to properly manage concurrency.
  Future<GenerateContentResponse> generateContentFromText(String prompt) async {
    return generateContent([content(init: (builder){
      builder.text(prompt);
    })]);
  }

  /// Generates a response from the backend with the provided image  represented [Content].
  ///
  /// [prompt] The image to be converted into a single piece of [Content] to send to the model.
  /// Returns a [GenerateContentResponse] after some delay. Function should be called within a async function
  Future<GenerateContentResponse> generateContentFromImage(Uint8List prompt) async {
    return generateContent([content(init: (builder){
      builder.image(prompt);
    })]);
  }

  /// Creates a chat instance which internally tracks the ongoing conversation with the model.
  Chat startChat({List<Content> history = const []}) {
    return Chat(this, history: history);
  }

  /// Counts the number of tokens used in a prompt.
  ///
  /// [prompt] A group of [Content]s to count tokens of.
  /// Returns a [CountTokensResponse] containing the number of tokens in the prompt.
  Future<CountTokensResponse> countTokens(List<Content> prompt) async {
    return (await _controller.countTokens( await _constructCountTokensRequest(prompt))).toPublic();
  }

  Future<GenerateContentRequest> _buildRequest(List<Content> prompt) async {

    final cont =  await Future.wait(prompt.map((content) async => await content.toInternal()).toList());


// Check if modelName is correct for the given items
    if (cont.any((item) => item.containsBlobPart() && modelName != Model.geminiProVision ||
        !item.containsBlobPart() && modelName != Model.geminiPro)) {
      throw InvalidStateException(
          "You specified the wrong gemini model.");
    }

    return GenerateContentRequest(
      model: modelName,
      contents:  cont,
     safetySettings:  safetySettings?.map((setting) => setting.toInternal()).toList(),
     generationConfig:   generationConfig?.toInternal(),
    );
  }

  Future<CountTokensRequest> _constructCountTokensRequest(List<Content> prompt) async {
    final cont =  await Future.wait(prompt.map((content) async => await content.toInternal()).toList());
    return CountTokensRequest(
      model: modelName,
     contents:  cont,
    );
  }
}

extension on GenerateContentResponse {
  GenerateContentResponse validate(){
    if (candidates.isEmpty && promptFeedback == null) {
      throw SerializationException("Error deserializing response, found no valid fields");
    }

    if (promptFeedback?.blockReason != null) {
      throw PromptBlockedException(this);
    }
    var finishReason = candidates
        .map((candidate) => candidate.finishReason)
        .firstWhere((finishReason) => finishReason != FinishReason.STOP, orElse: () => null);
    if (finishReason != null) {
      throw ResponseStoppedException(this);
    }
    return this;
  }
}

