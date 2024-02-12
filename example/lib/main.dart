
import 'package:flutter/material.dart';

import 'ChatExample.dart';
import 'GeminiProExample.dart';
import 'VisionProExample.dart';

void main() {
  runApp(const MaterialApp(home: MainPage(),debugShowCheckedModeBanner: false,));
}


class MainPage extends StatelessWidget {


  const MainPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Gemini ProVision example"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VisionProExample()),
                );
              },
              child: const Text('test'),
            ),
            const SizedBox(height: 20),
            const Text("Gemini Pro example"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GeminiProExample()),
                );
              },
              child: const Text('test'),
            ),

            const Text("Chat  example"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              child: const Text('test'),
            ),
          ],
        ),
      ),
    );
  }
}
