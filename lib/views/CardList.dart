import 'package:expense_tracker/views/Card.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CardListPage extends StatefulWidget {
  const CardListPage({super.key});

  @override
  State<CardListPage> createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  late List<Map<String, dynamic>> _expenses = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<String> _categories = ['Food', 'Snacks', 'Travel', 'Daily Goods', 'PG Rent', 'Miscellaneous'];
  String _selectedCategory = 'Food';
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    pref = await SharedPreferences.getInstance();
    _expenses = loadData();
    setState(() {});
  }

  void saveData() async {
    String encodedData = json.encode(_expenses);
    await pref.setString('expense_data_test', encodedData);
    setState(() {});
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

  void _addExpense() {
    final double? amount = double.tryParse(_amountController.text);
    final String description = _descriptionController.text;

    if (amount != null) {
      setState(() {
        _expenses.add({
          'amount': amount,
          'category': _selectedCategory,
          'description': description,
          'date': _selectedDate.millisecondsSinceEpoch,
        });
      });
      _amountController.clear();
      _descriptionController.clear();
      saveData();
    }
  }

  Map<String, double> get _monthlyData {
    final Map<String, double> data = {};

    for (var expense in _expenses) {
      final date = DateTime.fromMillisecondsSinceEpoch(expense['date']);
      final key = '${date.month}/${date.year}';
      data[key] = (data[key] ?? 0) + expense['amount'];
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Expenses List',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                final formattedDate = DateTime.fromMillisecondsSinceEpoch(expense['date']);
                final date = formattedDate.toLocal().toString().split(' ')[0];
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: MyCard.gradientCardSample(
                      expense['category'],
                      expense['description'],
                      expense['amount'].toStringAsFixed(2),
                      date,
                      context,
                          () {
                        setState(() {
                          _expenses.removeAt(index);
                          saveData();
                        });
                      },
                    ));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Add Expense',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(ctx).size.height * 0.6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _selectedDate = pickedDate;
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: const Text('Select Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addExpense();
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add Expense', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}