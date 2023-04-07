import 'package:flutter/material.dart';

class HumidityPage extends StatelessWidget {
  const HumidityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Humidity Page'),
      ),
      body: const Center(
        child: Text ('This is the humidity page.',
              style: TextStyle(fontSize: 24)),
      ),
    );
  }
}