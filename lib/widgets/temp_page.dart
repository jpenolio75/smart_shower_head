import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:smart_shower_head/page/Tempchart.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({Key? key}) : super(key: key);
  @override
  State<TemperaturePage> createState() => _TempPageState();
}

class _TempPageState extends State<TemperaturePage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Tempchart()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Temperature Page'),
          actions: [
            PopupMenuButton<int>(
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => const [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text('Chart'),
                      ),
                    ]),
          ],
        ),
        body: Center(
            child: FirebaseAnimatedList(
          query: databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Object? temp = snapshot.child('Temperature/AppData').value;
            double temp2 = double.parse(temp.toString());
            String temp3 = temp2.toStringAsFixed(2);

            return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(100.0),
                children: [
                  Text('$temp3°F',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 50)),
                ]);
          },
        )));
  }
}
