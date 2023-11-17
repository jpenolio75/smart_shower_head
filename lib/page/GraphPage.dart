import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';

/*class chart extends StatelessWidget {
  const chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: GraphPage());
  }
}

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  _GraphPage createState() => _GraphPage();
}

class _GraphPage extends State<GraphPage> {
  List<_ChartData> chartData = <_ChartData>[];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        .collection("Temperature/AppData")
        .get();
    List<_ChartData> list = snapShotsValue.docs
        .map((e) => _ChartData(
            x: DateTime.fromMillisecondsSinceEpoch(
                e.data()['x'].millisecondsSinceEpoch),
            y: e.data()['y']))
        .toList();
    setState(() {
      chartData = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showChart();
  }

  Widget _showChart() {
    return Scaffold(
      appBar: AppBar(),
      body: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<_ChartData, DateTime>>[
            ChartSeries<_ChartData, DateTime>(
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y)
          ]),
    );
  }
}

class _ChartData {
  final DateTime? x; //month
  final num? y; //data
  _ChartData({this.x, this.y});
}*/

double water2 = 0;

class GraphPage extends StatefulWidget {
  @override
  _GraphPage createState() => _GraphPage();
}

class _GraphPage extends State<GraphPage> {
  //final databaseReference = FirebaseDatabase.instance.ref();
  late List<chartData> _waterData;
  @override
  void initState() {
    _waterData = waterUsed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallons Used'),
      ), //AppBar
      body: Center(
          child: Container(
        child: SfCartesianChart(
          series: <ChartSeries>[
            StackedColumnSeries<chartData, DateTime>(
                dataSource: _waterData,
                xValueMapper: (chartData ch, _) => ch.months,
                yValueMapper: (chartData ch, _) =>
                    ch.data), //StackComlumnSeries
          ], //ChartSeries
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat.MMM(),
            majorGridLines: MajorGridLines(width: 0),
            title: AxisTitle(text: 'Months'),
          ),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
              title: AxisTitle(text: 'Data')),
        ), //SfCartesianChart
      )),
      //Container //Center
    ); //Scaffold
  }

  void waterdatafire(DataSnapshot snapshot) {
    Object? water = snapshot.child('WaterUsage/AppData').value;
    water2 = double.parse(water.toString());
  }

  List<chartData> waterUsed() {
    return <chartData>[
      chartData(months: DateTime(2023, 9, 30), data: 10),
      chartData(months: DateTime(2023, 10, 31), data: 20),
      chartData(months: DateTime(2023, 11, 31), data: water2),
      chartData(months: DateTime(2023, 12, 31), data: water2), //ChartData
    ];
  }
}

class chartData {
  final DateTime? months;
  final num? data;
  chartData({this.months, this.data});
}
