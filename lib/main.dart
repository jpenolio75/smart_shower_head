import 'package:flutter/material.dart';
import 'package:smart_shower_head/blconnect_page.dart';
import 'package:smart_shower_head/flow_page.dart';
import 'package:smart_shower_head/humid_page.dart';
import 'package:smart_shower_head/temp_page.dart';
import 'package:smart_shower_head/uvlight_page.dart';
import 'package:smart_shower_head/wateruse_page.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

void main() {
  runApp(const SmartShowerHead());
}

Future<void> _callNumber() async { 
    {
      //911 calls can only be placed on physical devices
      //use another number for testing
      const number = '1234567890';
      bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    }
}

class SmartShowerHead extends StatelessWidget {
  const SmartShowerHead({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Shower Head',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SmartShowerHeadPage(title: 'Smart Shower Head'),
    );
  }
}

class SmartShowerHeadPage extends StatefulWidget {
  const SmartShowerHeadPage({super.key, required this.title});
  final String title;

  @override
  State<SmartShowerHeadPage> createState() => _SmartShowerHeadPageState();
}

class _SmartShowerHeadPageState extends State<SmartShowerHeadPage> {
  _SmartShowerHeadPageState() {
    /// Init Alan Button with project key from Alan Studio      
    AlanVoice.addButton("67b683a94fac7b8b8f9d910996c042832e956eca572e1d8b807a3e2338fdd0dc/stage", 
    buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  //This function handles calling the command voice functions
  //only emergency calling for now
  void _handleCommand(Map<String, dynamic> command) {
    switch(command["command"]) {
      case "Emergency Call":
        _callNumber();
        break;
      default:
        debugPrint("Unknown command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,

      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Shower Head'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // implement GridView.builder
        child: GridView.count(
            primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            InkWell(
              child: Container (
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(255, 10, 131, 230),
                child: const Text("Temperature Page"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TemperaturePage()),
                );
              },
            ),
            InkWell(
              child: Container (
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(255, 10, 131, 230),
                child: const Text("Humidity Page"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HumidityPage()),
                );
              },
            ),
            InkWell(
              child: Container (
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(255, 10, 131, 230),
                child: const Text("Flow Meter Page"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FlowMeterPage()),
                );
              },
            ),
            InkWell(
              child: Container (
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(255, 10, 131, 230),
                child: const Text("Water Usage Page"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WaterUsePage()),
                );
              },
            ),
            InkWell(
              child: Container (
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(255, 10, 131, 230),
                child: const Text("UV light Page"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UVLightPage()),
                );
              },
            ),
            InkWell(
              child: Container (
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(255, 10, 131, 230),
                child: const Text("Bluetooth Connect Page"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BluetoothConnectPage()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: _callNumber,
        tooltip: 'Emergency Call',
        child: Icon(Icons.call),
      ),
    );
  }
}