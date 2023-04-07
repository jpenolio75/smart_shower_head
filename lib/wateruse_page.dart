import 'package:flutter/material.dart';

class WaterUsePage extends StatelessWidget {
  const WaterUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Usage Page'),
      ),
      body: const Center(
        child: Text ('This is the water usage page.',
              style: TextStyle(fontSize: 24)),
      ),
    );
  }
}