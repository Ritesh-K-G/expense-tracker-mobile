import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'ChartData.dart';

class Cumulativelinechart extends StatefulWidget {
  final List<Map<String, dynamic>> expenses;

  const Cumulativelinechart({super.key, required this.expenses});

  @override
  State<Cumulativelinechart> createState() => _CumulativelinechartState();
}

class _CumulativelinechartState extends State<Cumulativelinechart> {

  List<ChartData> lineChartData = [];

  @override
  void initState() {
    super.initState();
    lineChartData = getDailyExpenses();
  }

  List<ChartData> getDailyExpenses() {
    Map<String, double> dailyTotals = {};
    for (var item in widget.expenses) {
      String date = DateTime.fromMillisecondsSinceEpoch(item['date'])
          .toLocal()
          .toIso8601String()
          .split('T')[0];

      if (dailyTotals.containsKey(date)) {
        dailyTotals[date] = dailyTotals[date]! + item['amount'];
      } else {
        dailyTotals[date] = item['amount'].toDouble();
      }
    }
    List<MapEntry<String, double>> entries = dailyTotals.entries.toList();

    Map<String, double> prefixSumMap = {};
    double cumulativeSum = 0;
    for (var entry in entries) {
      cumulativeSum += entry.value;
      prefixSumMap[entry.key] = cumulativeSum;
    }

    List<ChartData> chartData = prefixSumMap.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      backgroundColor: Colors.black,
      plotAreaBorderColor:
      Colors.transparent,
      primaryXAxis: CategoryAxis(
        axisLine:
        const AxisLine(color: Colors.white),
        labelStyle: const TextStyle(
            color: Colors.white),
        majorGridLines:
        const MajorGridLines(color: Colors.grey),
        interval: lineChartData.length > 5
            ? (lineChartData.length / 5)
            : 1
      ),
      primaryYAxis: const NumericAxis(
        axisLine:
        AxisLine(color: Colors.white),
        labelStyle: TextStyle(
            color: Colors.white),
        majorGridLines:
        MajorGridLines(color: Colors.grey), // Grid lines
      ),
      title: const ChartTitle(
        text: 'Cumulative Expenses',
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        textStyle: const TextStyle(color: Colors.black),
        color: Colors.white,
        borderColor: Colors.blue,
        borderWidth: 1.5,
      ),
      series: <CartesianSeries>[
        FastLineSeries<ChartData, String>(
          dataSource: lineChartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          color: Colors.blue,
          width: 2,
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            color: Colors.orange,
            borderColor: Colors.white,
            borderWidth: 2,
          ),
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
          enableTooltip: true,
        ),
      ],
    );
  }
}
