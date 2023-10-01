import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatefulWidget {
  @override
  _GraphPage createState() => _GraphPage();
}

class _GraphPage extends State<GraphPage> {
  late List<chartData> _waterData;
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
      )), //Container //Center
    ); //Scaffold
  }

  List<chartData> waterUsed() {
    return <chartData>[
      chartData(months: DateTime(2023, 9, 30), data: 10),
      chartData(months: DateTime(2023, 10, 31), data: 40),
      chartData(months: DateTime(2023, 11, 31), data: 40),
      chartData(months: DateTime(2023, 12, 31), data: 40), //ChartData
    ];
  }
}

class chartData {
  final DateTime? months;
  final num? data;
  chartData({this.months, this.data});
}
