import 'package:expense_tracker/views/CardList.dart';
import 'package:expense_tracker/views/TotalExpenseCard.dart';
import 'package:expense_tracker/views/charts/CategoryDistributionPieChart.dart';
import 'package:expense_tracker/views/charts/CumulativeLineChart.dart';
import 'package:expense_tracker/views/charts/DailyLineChart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  late List<Map<String, dynamic>> _expenses = [];
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadData() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      _expenses = loadData();
      print(_expenses);
    });
  }

  List<Map<String, dynamic>> loadData() {
    String encodedMap = pref.getString('expense_data_test') ?? '';
    if (encodedMap != '') {
      List<Map<String, dynamic>> decodedMap =
          (json.decode(encodedMap) as List<dynamic>)
              .map((item) => item as Map<String, dynamic>)
              .toList();
      decodedMap.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        DateTime dateA = DateTime.fromMicrosecondsSinceEpoch(a['date']);
        DateTime dateB = DateTime.fromMicrosecondsSinceEpoch(b['date']);
        return dateA.compareTo(dateB);
      });
      return decodedMap;
    }
    List<Map<String, dynamic>> x = [];
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Expense Tracker',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () async {
                _loadData();
              },
            ),
            IconButton(
              icon: const Icon(Icons.list, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CardListPage()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExpenseCard(
                key: ValueKey('ExpenseCard_${_expenses.hashCode}'),
                expenses: _expenses,
              ),
              CategoryDistributionPieChart(
                key: ValueKey('CategoryDistribution_${_expenses.hashCode}'),
                expenses: _expenses,
              ),
              Cumulativelinechart(
                  key: ValueKey('CumulativeLineChart_${_expenses.hashCode}'),
                  expenses: _expenses),
              Dailylinechart(
                key: ValueKey('DailyLineChart_${_expenses.hashCode}'),
                expenses: _expenses,
              ),
            ],
          ),
        ));
  }
}
