import 'dart:typed_data';

/// Interface representing data sent to and received from requests.
///
/// One of:
/// * [TextPart] representing text or string based data.
/// * [ImagePart] representing image data.
/// * [BlobPart] representing MIME typed binary data.
abstract class Part {


  /// Returns the part as a [String] if it represents text, and null otherwise.
  String? asTextOrNull(){
    throw UnimplementedError();
  }

  /// Returns the part as a [Uint8List] if it represents an image, and null otherwise.
  Uint8List? asImageOrNull(){
    throw UnimplementedError();
  }
  /// Returns the part as a [BlobPart] if it represents a blob, and null otherwise.
  BlobPart? asBlobPartOrNull(){
    throw UnimplementedError();
  }
}

/// Represents text or string based data sent to and received from requests.
class TextPart implements Part {
  final String text;

  TextPart(this.text);

  @override
  BlobPart? asBlobPartOrNull() {
   return null;
  }

  @override
  Uint8List? asImageOrNull() {
    return null;
  }

  @override
  String? asTextOrNull() {
    return text;
  }
}

/// Represents image data sent to and received from requests.
///
/// When this is sent to the server it is converted to jpeg encoding at 80% quality.
class ImagePart implements Part {
  final Uint8List image;

  ImagePart(this.image);

  @override
  BlobPart? asBlobPartOrNull() {
    return null;
  }

  @override
  Uint8List? asImageOrNull() {
    return image;
  }

  @override
  String? asTextOrNull() {
   return  null;
  }
}

/// Represents binary data with an associated MIME type sent to and received from requests.
class BlobPart implements Part {
  final String mimeType;
  final Uint8List blob;

  BlobPart(this.mimeType, this.blob);

  @override
  BlobPart? asBlobPartOrNull() {
     return this;
  }

  @override
  Uint8List? asImageOrNull() {
    return null;
  }

  @override
  String? asTextOrNull() {
     return null;
  }
}
