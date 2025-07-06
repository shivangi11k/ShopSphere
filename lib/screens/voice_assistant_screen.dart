import 'package:flutter/material.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  String responseText = 'Tap the mic to start';

  void simulateVoiceInteraction() {
    setState(() {
      responseText = 'Listening...';
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        responseText = 'Here is a sample voice response!';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 80,
              icon: const Icon(Icons.mic, color: Colors.deepPurple),
              onPressed: simulateVoiceInteraction,
            ),
            const SizedBox(height: 30),
            Text(
              responseText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
