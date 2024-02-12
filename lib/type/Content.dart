
import 'dart:typed_data';
import 'Part.dart';
/// Represents content sent to and received from the model.
///
/// Contains a collection of text, image, and binary parts.
///
/// [Content] can be constructed using the [content] function in a DSL-like manner.
class Content {
  final String? role;
  final List<Part> parts;

  Content({this.role, required this.parts});
}




/// Represents image data sent to and received from requests.
/// Function to construct content sent to and received
///
/// Contains a collection of text, image, and binary parts.

Content content({String? role, required Function(ContentBuilder) init}) {
  final builder = ContentBuilder();
  builder.role = role;
  init(builder);
  return builder.build();
}

/// Builder class for constructing [Content] objects.
class ContentBuilder {
  String? role;
  final List<Part> parts = [];

  /// Adds a text part to the content.
  void text(String text) {
    parts.add(TextPart(text));
  }

  /// Adds an image part to the content.
  void image(Uint8List image) {
    parts.add(ImagePart(image));
  }

  /// Adds a blob part to the content.
  void blob(String mimeType, Uint8List blob) {
    parts.add(BlobPart(mimeType, blob));
  }

  /// Builds the [Content] object.
  Content build() {
    return Content(role : role , parts : parts);
  }
}
