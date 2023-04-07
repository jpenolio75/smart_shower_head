import 'package:flutter/material.dart';

class BluetoothConnectPage extends StatelessWidget {
  const BluetoothConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Connect Page'),
      ),
      body: const Center(
        child: Text ('This is the bluetooth connect page.',
              style: TextStyle(fontSize: 24)),
      ),
    );
  }
}