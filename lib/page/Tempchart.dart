import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

class Tempchart extends StatefulWidget {
  @override
  _Tempchart createState() => _Tempchart();
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
            color: const Color.fromRGBO(192, 108, 132, 1),
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
}
