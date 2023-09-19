import 'package:smart_shower_head/widgets/flow_page.dart';
import 'package:smart_shower_head/widgets/temp_page.dart';
import 'package:smart_shower_head/widgets/wateruse_page.dart';
import 'package:flutter/material.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  State<HomeScreenPage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenPage> {
  _HomeScreenState();

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
                  color: Colors.blue, // button color
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
                  color: Colors.blue, // button color
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
                  color: Colors.blue, // button color
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
          ],
        ),
      ),
    );
  }
}