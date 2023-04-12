import 'package:flutter/material.dart';

class UVLightPage extends StatelessWidget {
  const UVLightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UV Light Page'),
      ),
      body: const Center(
        child: Text ('This is the UV light page.',
              style: TextStyle(fontSize: 24)),
      ),
    );
  }
}