import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
//import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';

class chart extends StatelessWidget {
  const chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Tempchart());
  }
}

class Tempchart extends StatefulWidget {
  const Tempchart({Key? key}) : super(key: key);

  @override
  _TempchartState createState() => _TempchartState();
}

class _TempchartState extends State<Tempchart> {
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
          series: <LineSeries<_ChartData, DateTime>>[
            LineSeries<_ChartData, DateTime>(
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y)
          ]),
    );
  }
}

class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final double? y; //temp
}

/*class Tempchart extends StatefulWidget {
  @override
  _Tempchartstate createState() => _Tempchartstate();
}



class _Tempchart extends State<Tempchart> {
  late List<TempData> chartdata;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    chartdata = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SfCartesianChart(
        series: <LineSeries<TempData, int>>[
          LineSeries<TempData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartdata,
            color: Color.fromARGB(255, 245, 11, 11),
            xValueMapper: (TempData temp, _) => temp.time,
            yValueMapper: (TempData temp, _) => temp.temp,
          ) //LineSeries
        ], //<LineSeries<TempData, int>>
        primaryXAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            interval: 3,
            title: AxisTitle(text: 'Time (seconds)')), //NumericAxis
        primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
            title: AxisTitle(text: 'Temperature F')), //NumericAxis
      ), //SfCartesianChart
    )); //Scaffold //SafeArea
  }

  int time = 7;
  void updateDataSource(Timer timer) {
    chartdata.add(TempData(time++, (math.Random().nextInt(60) + 30)));
    chartdata.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartdata.length - 1, removedDataIndex: 0);
  }

  List<TempData> getChartData() {
    return <TempData>[
      TempData(0, 85),
      TempData(1, 85.1),
      TempData(2, 85.4),
      TempData(3, 85.9),
      TempData(4, 86),
      TempData(5, 86.5),
      TempData(6, 10),
    ];
  }
}

class TempData {
  TempData(this.time, this.temp);
  final int time;
  final double temp;
}*/
