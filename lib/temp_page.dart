import 'package:flutter/material.dart';

class TemperaturePage extends StatelessWidget {
  const TemperaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Page'),
      ),
      body: const Center(
        child: Text ('This is the temperature page.',
              style: TextStyle(fontSize: 24)),
      ),
    );
  }
}