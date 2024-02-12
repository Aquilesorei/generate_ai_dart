import 'dart:ffi';
import 'dart:typed_data';

import 'package:generate_ai_dart/generate_ai_dart.dart';

typedef Base64 = String;
enum InternalHarmCategory {
UNKNOWN,
HARASSMENT,
 HATE_SPEECH,
SEXUALLY_EXPLICIT,
DANGEROUS_CONTENT;

  String toJson() {
    switch (values.byName(name)) {
      case UNKNOWN: return 'UNKNOWN';
      case HARASSMENT: return 'HARM_CATEGORY_HARASSMENT';
      case HATE_SPEECH: return 'HARM_CATEGORY_HATE_SPEECH';
      case SEXUALLY_EXPLICIT: return 'HARM_CATEGORY_SEXUALLY_EXPLICIT';
      case DANGEROUS_CONTENT: return 'HARM_CATEGORY_DANGEROUS_CONTENT';
      default: return 'UNKNOWN';
    }

  }
  static InternalHarmCategory fromJson(String json)  {
    switch (json) {
      case 'UNKNOWN':
        return InternalHarmCategory.UNKNOWN;
      case 'HARM_CATEGORY_HARASSMENT':
        return InternalHarmCategory.HARASSMENT;
      case 'HARM_CATEGORY_HATE_SPEECH':
        return InternalHarmCategory.HATE_SPEECH;
      case 'HARM_CATEGORY_SEXUALLY_EXPLICIT':
        return InternalHarmCategory.SEXUALLY_EXPLICIT;
      case 'HARM_CATEGORY_DANGEROUS_CONTENT':
        return InternalHarmCategory.DANGEROUS_CONTENT;
      default:
        return InternalHarmCategory.UNKNOWN;
    }
  }

}




class InternalContent {
  final String? role;
  final List<InternalPart>? parts;

  InternalContent({this.role, required this.parts});

  factory InternalContent.fromJson(Map<String, dynamic> json)  {
    return InternalContent(
      role: json['role'],
        parts: json['parts'] != null ? (json['parts'] as List<dynamic> ).map((e) => InternalPart.fromJson(e)).toList() : null,
    );
  }

  bool containsBlobPart(){
    if(parts == null) return false;
    for(final part in parts!){
      if(part is InternalBlobPart){
        return true;
      }
    }
    return false;
  }
  Map<String, dynamic> toJson()  {
    return {
      if(role != null)'role': role,
      'parts'  : parts?.map((e) => e.toJson()).toList(),

    };
  }
}


Map<String, dynamic> _serializePart(InternalPart part) {
  if (part is InternalTextPart) {
    return { 'text': part.text};
  } else if (part is InternalBlobPart) {
    return { 'inline_data': part.inlineData.toJson()}; // Convert to a list
  } else {
    throw Exception('Unsupported Part type: ${part.runtimeType}');
  }
}

InternalPart _deserializePart(Map<String, dynamic> json) {
  if(json['text'] != null){
    return InternalTextPart(json['text'] as String);
  }else if(json['inline_data'] != null){
    final data = json['inline_data'] ;
    return InternalBlobPart(InternalBlob.fromJson(data));
  }else {
    throw Exception('Unknown Part type');
  }
}

sealed class InternalPart {
  const InternalPart._(); // Private constructor to prevent direct instantiation

  factory InternalPart.fromJson(Map<String, dynamic> json) => _deserializePart(json);

  // Define factory constructors for subtypes
  factory InternalPart.text(String text) => InternalTextPart(text);
  factory InternalPart.blob(InternalBlob inlineData) => InternalBlobPart(inlineData);
  factory InternalPart.image(Uint8List img) =>InternalImagePart(img);

  // Implement a method to handle serialization
  Map<String, dynamic> toJson() => _serializePart(this);
}


class InternalTextPart extends InternalPart {
  final String text;

  InternalTextPart(this.text) : super._();
}

class InternalBlobPart extends InternalPart {
  final InternalBlob inlineData;

  InternalBlobPart(this.inlineData) : super._();

}
class InternalImagePart extends InternalPart {
  final Uint8List image;

  InternalImagePart(this.image) : super._();
}


class InternalBlob {
  final String mimeType;
  final Base64 data;

  InternalBlob({required this.mimeType, required this.data});
  factory InternalBlob.fromJson(Map<String, dynamic> json) {
    return  InternalBlob(mimeType: json['mime_type'], data: json['data']);
  }

  Map<String,dynamic> toJson(){
     return {
       'mime_type' : mimeType,
       'data' : data
     };
  }
}

class InternalSafetySetting{
  final InternalHarmCategory category ;
  final InternalHarmBlockThreshold threshold;
  InternalSafetySetting({required this.category,required this.threshold});

  factory InternalSafetySetting.fromJson(Map<String, dynamic> json){
   return   InternalSafetySetting(
     category: InternalHarmCategory.fromJson(json['category']),
     threshold: InternalHarmBlockThreshold.fromJson(json['threshold'])
   );
  }

  Map<String,dynamic> toJson() {

    return {
      'category' : category.toJson(),
      'threshold' : threshold.toJson(),
    };
  }
}

 enum InternalHarmBlockThreshold {
 UNSPECIFIED,
BLOCK_LOW_AND_ABOVE,
BLOCK_MEDIUM_AND_ABOVE,
BLOCK_ONLY_HIGH,
BLOCK_NONE;

   String toJson() {
     final res = values.byName(name);
   switch (res) {
     case UNSPECIFIED: return 'HARM_BLOCK_THRESHOLD_UNSPECIFIED';
     default: return res.name;
   }

 }
 static InternalHarmBlockThreshold fromJson(String json)  {
   switch (json) {
     case 'HARM_BLOCK_THRESHOLD_UNSPECIFIED':
       return InternalHarmBlockThreshold.UNSPECIFIED;
     default:
       return  values.byName(json);
   }
 }
}


