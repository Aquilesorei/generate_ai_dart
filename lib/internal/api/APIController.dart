import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../type/Exceptions.dart';
import 'Request.dart';
import 'Response.dart' as Resp;

const DOMAIN = "https://generativelanguage.googleapis.com/v1";

const JSON = JsonCodec();

class APIController {
  final String key;
  final String model;
  final Dio _dio;

  APIController(this.key, this.model) : _dio = Dio();

  Future<Resp.GenerateContentResponse> generateContent(
      GenerateContentRequest request,
      ) async {
    try {
      final response = await _dio.post(
        "$DOMAIN/${_fullModelName(model)}:generateContent",
        data: request.toJson(),
        options: _createCommonOptions(),
      );

      _validateResponse(response);
      return Resp.GenerateContentResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (error) {
      print("error ${error.toString()}");
      rethrow;
    }
  }

  //TODO : implement and handle response with json stream parser
  Stream<Resp.GenerateContentResponse> generateContentStream(
      GenerateContentRequest request,
      ) async* {
      throw UnimplementedError("no implemented yet ");
  }

  Future<Resp.CountTokensResponse> countTokens(CountTokensRequest request) async {
    try {
      final response = await _dio.post(
        "$DOMAIN/${_fullModelName(model)}:countTokens",
        data: request.toJson(),
        options: _createCommonOptions(),
      );
      _validateResponse(response);
      return Resp.CountTokensResponse.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Options _createCommonOptions() {
    return Options(
      headers: {
        "x-goog-api-key": key,
       // "x-goog-api-client": "genai-android/${BuildConfig.VERSION_NAME}",
      },
    );
  }
}

String _fullModelName(String name) {
  return name.startsWith("models/") ? name : "models/$name";
}

void _validateResponse(Response<dynamic> response) {
  if (response.statusCode != 200) {
    final text = response.data.toString();
    final message = tryDecodeGRpcErrorResponse(text)?.error.message ??
        "Unexpected Response:\n$text";
    throw ServerException(message);
  }
}

Resp.GRpcErrorResponse? tryDecodeGRpcErrorResponse(String text) {
  try {
    return Resp.GRpcErrorResponse.fromJson(JSON.decode(text));
  } catch (e) {
    return null;
  }
}
