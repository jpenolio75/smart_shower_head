import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class FlowMeterPage extends StatefulWidget {
  const FlowMeterPage({Key? key}) : super(key: key);
  @override
  State<FlowMeterPage> createState() => _FlowPageState();
}


class _FlowPageState extends State<FlowMeterPage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow Rate Page'),
      ),
      body: Center (
        child: FirebaseAnimatedList(
          query: databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            Object? flow = snapshot.child('FlowRate/AppData').value;
            double flow2 = double.parse(flow.toString());
            String flow3 = flow2.toStringAsFixed(2);

            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(100.0),
              children: [
                Text( '$flow3 Gal/min',
                  textAlign: TextAlign.center, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50)
                ),
              ]
            );
          }
        )
      )
    );
  }
}