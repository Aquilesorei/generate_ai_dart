import 'package:flutter/material.dart';
import 'package:generate_ai_dart/generate_ai_dart.dart';

import 'data.dart';

class GeminiProExample extends StatefulWidget {
  const GeminiProExample({super.key});

  @override
  State<GeminiProExample> createState() => _GeminiProExampleState();
}

class _GeminiProExampleState extends State<GeminiProExample> {
  final TextEditingController _textController = TextEditingController();
  String response = '';
  bool processing = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text to Server')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Enter text to send to server',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: handleGenerate,
                child: const Text('generate'),
              ),
              const SizedBox(height: 20.0),
              processing
                  ? const CircularProgressIndicator()
                  : Text(response),
              if (_errorMessage.isNotEmpty) Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
    
    
  }

  void handleGenerate() async {
    
      setState(() {
        processing = true;
      });


      final config = generationConfig((builder) {
        builder.temperature = 0.7;
      });

      final model =
      GenerativeModel(Model.geminiPro, key, generationConfig: config);
      await model.generateContentFromText(_textController.text).then((value) => setState(() {
        response = value.text ?? "";
        processing = false;
      }));

    
        
    
  }
}
