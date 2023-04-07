import 'package:flutter/material.dart';

class FlowMeterPage extends StatelessWidget {
  const FlowMeterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow Meter Page'),
      ),
      body: const Center(
        child: Text ('This is the flow meter page.',
              style: TextStyle(fontSize: 24)),
      ),
    );
  }
}