import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'ChartData.dart';

class CategoryDistributionPieChart extends StatefulWidget {
  final List<Map<String, dynamic>> expenses;

  const CategoryDistributionPieChart({super.key, required this.expenses});

  @override
  State<CategoryDistributionPieChart> createState() => _CategoryDistributionPieChartState();
}

class _CategoryDistributionPieChartState extends State<CategoryDistributionPieChart> {

  List<ChartData> pieChartData = [];

  @override
  void initState() {
    super.initState();
    pieChartData = getCategoricalExpenses();
    setState(() {});
  }

  List<ChartData> getCategoricalExpenses() {
    Map<String, double> categoryTotals = {};
    for (var item in widget.expenses) {
      String category = item['category'];

      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + item['amount'];
      } else {
        categoryTotals[category] = item['amount'].toDouble();
      }
    }

    List<ChartData> chartData = categoryTotals.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
    return chartData;
  }

  List<Color> defaultColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.white
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: SfCircularChart(
            title: const ChartTitle(
              text: 'Expense Distribution',
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.right,
              alignment: ChartAlignment.center,
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              iconWidth: 16,
              iconHeight: 16,
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: '',
              textStyle: const TextStyle(color: Colors.black),
              color: Colors.white,
              borderColor: Colors.blue,
              borderWidth: 1.5,
            ),
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                dataSource: pieChartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                pointColorMapper: (ChartData data, index) => defaultColors[index % defaultColors.length],
                radius: '75%',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(fontSize: 12, color: Colors.black),
                ),
                explode: true,
                explodeIndex: 1,
              )
            ]
        )
    );
  }
}

/*

    child: SfCircularChart(
        title: const ChartTitle(
          text: 'Expense Distribution',
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
          alignment: ChartAlignment.center,
          textStyle: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          iconWidth: 16,
          iconHeight: 16,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          textStyle: const TextStyle(color: Colors.black),
          color: Colors.white,
          borderColor: Colors.blue,
          borderWidth: 1.5,
        ),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: pieChartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(fontSize: 12, color: Colors.black),
            ),
            explode: true,
            explodeIndex: 1,
          ),
        ],
      ),
* */