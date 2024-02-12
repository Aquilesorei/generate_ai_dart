import 'dart:async';


import '../GenerativeModel.dart';
import '../type/type.dart';
import 'ChatFutures.dart';

abstract class GenerativeModelFutures {
  /// Generates a response from the backend with the provided [Content]s.
  ///
  /// [prompt] is a group of [Content]s to send to the model.
  Future<GenerateContentResponse> generateContent(List<Content> prompt);

  /// Generates a streaming response from the backend with the provided [Content]s.
  ///
  /// [prompt] is a group of [Content]s to send to the model.
  Future<Stream<GenerateContentResponse>> generateContentStream(List<Content> prompt);

  /// Counts the number of tokens used in a prompt.
  ///
  /// [prompt] is a group of [Content]s to count tokens of.
  Future<CountTokensResponse> countTokens(List<Content> prompt);

  /// Creates a chat instance which internally tracks the ongoing conversation with the model.
  ChatFutures startChat();

  /// Creates a chat instance which internally tracks the ongoing conversation with the model.
  ///
  /// [history] is an existing history of context to use as a starting point.
  ChatFutures startChatWithHistory(List<Content> history);

  /// Returns the [GenerativeModel] instance that was used to create this object.
  GenerativeModel getGenerativeModel();

  static GenerativeModelFutures from(GenerativeModel model) {
  return _FuturesImpl(model);
  }
}

class _FuturesImpl extends GenerativeModelFutures {
  final GenerativeModel _model;

  _FuturesImpl(this._model);

  @override
  Future<GenerateContentResponse> generateContent(List<Content> prompt) async {
    return _model.generateContent(prompt);
  }

  @override
  Future<Stream<GenerateContentResponse>> generateContentStream(List<Content> prompt) async {

    return await _model.generateContentStream(prompt);
  }

  @override
  Future<CountTokensResponse> countTokens(List<Content> prompt) async {
    return _model.countTokens(prompt);
  }

  @override
  ChatFutures startChat() {
    return startChatWithHistory([]);
  }

  @override
  ChatFutures startChatWithHistory(List<Content> history) {
    return ChatFutures.from(_model.startChat(history: history));
  }

  @override
  GenerativeModel getGenerativeModel() {
    return _model;
  }
}
