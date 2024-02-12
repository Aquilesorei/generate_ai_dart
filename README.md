# Google AI SDK for flutter

The Google AI client SDK for flutter enables developers to use Google's state-of-the-art generative AI models (like Gemini) to build AI-powered features and applications. This SDK supports use cases like:
- Generate text from text-only input
- Generate text from text-and-images input (multimodal)
- Build multi-turn conversations (chat)

For example, with just a few lines of code, you can access Gemini's multimodal capabilities to generate text from text-and-image input:

```dart
const key = "Your api key";

final config = generationConfig((builder) {
  builder.temperature = 0.7;
});
 final model = GenerativeModel(Model.geminiPro, key, generationConfig: config);
model.generateContentFromText("what is flutter ?").then((value) => print(value.text));
```

## Try out the sample flutter app

This repository contains a sample app demonstrating how the SDK can access and utilize the Gemini model for various use cases.


## Installation and usage

Add the dependency `flutter pub add gemini_ai_dart`) to your flutter project.
