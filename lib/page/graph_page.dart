import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);
  @override
  State<GraphPage> createState() => _GraphPage();
}

class _GraphPage extends State<GraphPage> {
  late List<ChartData> _waterData;
  @override
  void initState() {
    _waterData = waterUsed();
    super.initState();
  }

  /*final List<chartData> waterUsed = [
    chartData('Sep', 10),
    chartData('Oct', 30),
    chartData('Nov', 70),
    chartData('Dec', 100),
  ];*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallons Used'),
      ), //AppBar
      body: Center(
          child: SfCartesianChart(
            series: <ChartSeries>[
              StackedColumnSeries<ChartData, DateTime>(
                  dataSource: _waterData,
                  xValueMapper: (ChartData ch, _) => ch.months,
                  yValueMapper: (ChartData ch, _) =>
                      ch.data), //StackComlumnSeries
            ], //ChartSeries
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMM(),
              majorGridLines: const MajorGridLines(width: 0),
            ),
          ), //SfCartesianChart
      ), //Container //Center
    ); //Scaffold
  }

  List<ChartData> waterUsed() {
    return <ChartData>[
      ChartData(months: DateTime(2023, 9, 30), data: 10),
      ChartData(months: DateTime(2023, 10, 31), data: 40),
      ChartData(months: DateTime(2023, 11, 31), data: 40),
      ChartData(months: DateTime(2023, 12, 31), data: 40), //ChartData
    ];
  }
}

class ChartData {
  final DateTime? months;
  final num? data;
  ChartData({this.months, this.data});
}