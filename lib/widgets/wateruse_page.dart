import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class WaterUsePage extends StatefulWidget {
  const WaterUsePage({Key? key}) : super(key: key);
  @override
  State<WaterUsePage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterUsePage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Usage Page'),
      ),
      body: Center (
        child: FirebaseAnimatedList(
          query: databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            Object? water = snapshot.child('WaterUsage/AppData').value;
            double water2 = double.parse(water.toString());
            String water3 = water2.toStringAsFixed(2);

            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(100.0),
              children: [
                Text( '$water3 Gallons',
                  textAlign: TextAlign.center, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50)
                ),
              ]
            );
          },
        )
      )
    );
  }
}