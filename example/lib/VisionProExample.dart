import 'dart:typed_data';

import 'package:flimer/flimer.dart';
import 'package:flutter/material.dart';
import 'package:generate_ai_dart/generate_ai_dart.dart';

import 'data.dart';
class VisionProExample extends StatefulWidget {
  const VisionProExample({super.key});

  @override
  State<VisionProExample> createState() => _State();
}

class _State extends State<VisionProExample>  {
  XFile? image;
  late Uint8List imageBytes;
  bool processing = false;

  String response = "";
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    if(processing) {
      return const Center(child: CircularProgressIndicator(),);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini ai  example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            if (image != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.memory(imageBytes),
              ),

            if(response.isNotEmpty) Center(child: Text(response),),
            Row(
              children: [
              Center(
                child: IconButton(
                  onPressed:handleOpenGallery,
                  icon: const Icon(Icons.add),
                )
              ),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Question',
                  border: OutlineInputBorder(),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child:  IconButton(
                    onPressed:handleGenerate,
                    icon: const Icon(Icons.send),
                  ),
                ),
              ),
            ],)
          ],
        ),
      ),
    );
  }

  handleOpenGallery() async {
    final xFile = await flimer.pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      imageBytes = (await xFile.readAsBytes());
      setState(() {
        image = xFile;

      });
    }
  }

  handleGenerate() async {

    if(image != null) {
      setState(() {
        processing = true;
      });

      final config = generationConfig((builder) {
        builder.temperature = 0.7;
      });

      final model =
      GenerativeModel(Model.geminiProVision, key, generationConfig: config);
      // model.generateContentFromText("hello guy").then((value) => print(value.text));

      await model
          .generateContent([content(init: (builder){
            builder.text(_textController.text);
            builder.image(imageBytes);
      })])
          .then((value) => setState(() {
        response = value.text ?? "";
        processing = false;
      }));
    }
  }
}
