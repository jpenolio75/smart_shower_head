import 'package:flutter/material.dart';
import 'package:smart_shower_head/widgets/blconnect_page.dart';
import 'package:smart_shower_head/widgets/flow_page.dart';
import 'package:smart_shower_head/widgets/humid_page.dart';
import 'package:smart_shower_head/widgets/temp_page.dart';
import 'package:smart_shower_head/widgets/wateruse_page.dart';
import 'package:smart_shower_head/widgets/settings_page.dart';
import 'package:smart_shower_head/widgets/streamplat_page.dart';
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
            SizedBox.fromSize(
              size: const Size(56, 56), // button width and height
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  color: const Color.fromARGB(255, 10, 131, 230), // button color
                  child: InkWell(
                    splashColor: Colors.white, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TemperaturePage()),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text("Temperature", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Icon(Icons.thermostat, size: 100), // icon // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(56, 56), // button width and height
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  color: const Color.fromARGB(255, 10, 131, 230), // button color
                  child: InkWell(
                    splashColor: Colors.white, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WaterUsePage()),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text("Water Usage", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Icon(Icons.water_drop, size: 100), // icon // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(56, 56), // button width and height
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  color: const Color.fromARGB(255, 10, 131, 230), // button color
                  child: InkWell(
                    splashColor: Colors.white, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FlowMeterPage()),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text("Flow Rate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Icon(Icons.shower, size: 100), // icon // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(56, 56), // button width and height
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  color: const Color.fromARGB(255, 10, 131, 230), // button color
                  child: InkWell(
                    splashColor: Colors.white, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HumidityPage()),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text("Humidity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Icon(Icons.water, size: 100), // icon // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: _callNumber,
        tooltip: 'Emergency Call',
        child: Icon(Icons.call),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (value) {
          if(value == 1) {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StreamingPlatformPage()),
              );
          } else if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BluetoothConnectPage()),
              );
          } else if (value == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
          }
        }
      ),
    );
  }
}