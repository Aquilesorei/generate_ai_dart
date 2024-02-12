import 'dart:async';
import 'dart:typed_data';

import 'package:generate_ai_dart/role.dart';
import 'package:generate_ai_dart/type/type.dart';
import 'package:mutex/mutex.dart';

import 'GenerativeModel.dart';

/// Representation of a back and forth interaction with a model.
///
/// Handles the capturing and storage of the communication with the model, providing methods for
/// further interaction.
///
/// Note: This object is not thread-safe, and calling [sendMessage] multiple times without waiting
/// for a response will throw an [InvalidStateException].
class Chat {
  final GenerativeModel model;
  final List<Content> history;

  final _lock = Mutex();

  /// Creates a [Chat] instance.
  ///
  /// [model] is the model to use for the interaction.
  /// [history] is the previous interactions with the model.
  Chat(this.model, {required this.history});

  /// Generates a response from the backend with the provided [Content], and any previous ones
  /// sent/returned from this chat.
  ///
  /// [prompt] is a [Content] to send to the model.
  ///
  /// Throws [InvalidStateException] if the prompt is not coming from the 'user' role
  /// or if the [Chat] instance has an active request.
  Future<GenerateContentResponse> sendMessage(Content prompt) async {
    _assertComesFromUser(prompt);
    await _attemptLock();
    try {
      final response = await model.generateContent([...history, prompt]);
      history.add(prompt);
      history.add(response.candidates.first.content);
      return  Future.value(response as FutureOr<GenerateContentResponse>?);
    } finally {
      _lock.release();
    }
  }

  /// Generates a response from the backend with the provided text represented [Content].
  ///
  /// [prompt] is the text to be converted into a single piece of [Content] to send to the model.
  ///
  /// Throws [InvalidStateException] if the [Chat] instance has an active request.
  Future<GenerateContentResponse> sendMessageText(String prompt) =>
      sendMessage(content(role : Role.user, init: (ContentBuilder builder){
        builder.text(prompt);
      }));

  /// Generates a response from the backend with the provided image represented [Content].
  ///
  /// [prompt] is the image to be converted into a single piece of [Content] to send to the model.
  ///
  /// Throws [InvalidStateException] if the [Chat] instance has an active request.
  Future<GenerateContentResponse> sendMessageImage(Uint8List prompt) =>
      sendMessage(content(role : Role.user,
          init:(ContentBuilder builder){
           builder.image(prompt);
          }));

  /// Generates a streaming response from the backend with the provided [Content]s.
  ///
  /// [prompt] is a [Content] to send to the model.
  ///
  /// Returns a [Stream] which will emit responses as they are returned from the model.
  ///
  /// Throws [InvalidStateException] if the prompt is not coming from the 'user' role
  /// or if the [Chat] instance has an active request.
  Future<Stream<GenerateContentResponse>> sendMessageStream(Content prompt) async {
    _assertComesFromUser(prompt);
    _attemptLock();

    final resp =await  model.generateContentStream([...history, prompt]);
    final images = <Uint8List>[];
    final blobs = <BlobPart>[];
    final text = StringBuffer();

    return resp.transform(
      StreamTransformer.fromHandlers(
        handleData: (GenerateContentResponse response, EventSink<GenerateContentResponse> sink) {
          for (final part in response.candidates.first.content.parts) {
            if (part is TextPart) {
              text.write(part.text);
            } else if (part is ImagePart) {
              images.add(part.image);
            } else if (part is BlobPart) {
              blobs.add(part);
            }
          }
          sink.add(response);
        },
        handleDone: (sink) {
          _lock.release();
          if (images.isNotEmpty || blobs.isNotEmpty || text.isNotEmpty) {
            final newContent = content(role : Role.model,init: (builder){
              for (final img in images) {
                builder.image(img);
              }
              for (final blob in blobs) {
                builder.blob(blob.mimeType, blob.blob);
              }
              if (text.isNotEmpty) {
                builder.text(text.toString());
              }
            });

            history.add(prompt);
            history.add(newContent);
          }
        },
      ),
    );
  }

  /// Generates a streaming response from the backend with the provided text represented [Content].
  ///
  /// [prompt] is the text to be converted into a single piece of [Content] to send to the model.
  ///
  /// Returns a [Stream] which will emit responses as they are returned from the model.
  ///
  /// Throws [InvalidStateException] if the [Chat] instance has an active request.
  Future<Stream<GenerateContentResponse>> sendMessageTextStream(String prompt) async =>
      await sendMessageStream(content(role : Role.user, init: (ContentBuilder builder){
        builder.text(prompt);
      }));

  /// Generates a streaming response from the backend with the provided image represented [Content].
  ///
  /// [prompt] is the image to be converted into a single piece of [Content] to send to the model.
  ///
  /// Returns a [Stream] which will emit responses as they are returned from the model.
  ///
  /// Throws [InvalidStateException] if the [Chat] instance has an active request.
  Future<Stream<GenerateContentResponse>> sendMessageImageStream(Uint8List prompt) async =>
     await sendMessageStream(content(role : Role.user, init: (ContentBuilder builder){
        builder.image(prompt);
      }));

  void _assertComesFromUser(Content prompt) {
    if (prompt.role != Role.user) {
      throw InvalidStateException('Chat prompts should come from the \'user\' role.');
    }
  }

  Future<void> _attemptLock() async {

    await _lock.acquire();
 /*   if (!) {
      throw InvalidStateException(
        'This chat instance currently has an ongoing request, please wait for it to complete '
            'before sending more messages',
      );
    }*/
  }
}



