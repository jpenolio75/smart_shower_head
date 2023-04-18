import 'package:flutter/material.dart';

class StreamingPlatformPage extends StatelessWidget {
  const StreamingPlatformPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streaming Platform Page'),
      ),
      body: const Center(
        child: Text ('This is the streaming platform page.',
              style: TextStyle(fontSize: 24)),
      ),
    );
  }
}