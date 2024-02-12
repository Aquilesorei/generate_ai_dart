import 'dart:async';

import 'package:generate_ai_dart/type/type.dart';

import '../Chat.dart';



abstract class ChatFutures {

  /// Generates a response from the backend with the provided [Content], and any previous ones
  /// sent/returned from this chat.
  ///
  /// @param prompt A [Content] to send to the model.
  Future<GenerateContentResponse> sendMessage(Content prompt);
  /// Generates a streaming response from the backend with the provided [Content]s.
  ///
  /// @param prompt A [Content] to send to the model.
  Stream<GenerateContentResponse> sendMessageStream(Content prompt);

  /// Returns the [Chat] instance that was used to create this instance
  Chat getChat();
  /// @return a [ChatFutures] created around the provided [Chat]
  static ChatFutures from(Chat chat) {
    return _FuturesImpl(chat);
  }
}

class _FuturesImpl extends ChatFutures {
  final Chat _chat;

  _FuturesImpl(this._chat);

  @override
  Future<GenerateContentResponse> sendMessage(Content prompt) async {
    return _chat.sendMessage(prompt);
  }

  @override
  Stream<GenerateContentResponse> sendMessageStream(Content prompt) {
    //TODO : implement and handle response with json stream parser
    throw UnimplementedError("no implemented yet ");
  }

  @override
  Chat getChat() {
    return _chat;
  }
}
