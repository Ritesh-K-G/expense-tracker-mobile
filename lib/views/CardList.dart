import 'package:expense_tracker/views/Card.dart';
import 'package:flutter/foundation.dart';
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
  late List<Map<String, dynamic>> _filteredExpenses = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<String> _categories = [
    'Food',
    'Snacks',
    'Travel',
    'Daily Goods',
    'Entertainment',
    'Bills',
    'Miscellaneous'
  ];
  String _selectedCategory = 'Food';
  late SharedPreferences pref;

  String _toFilterCategory = 'All';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    pref = await SharedPreferences.getInstance();
    _expenses = loadData();
    setState(() {
      _filteredExpenses = _expenses;
    });
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
        DateTime dateA = DateTime.fromMillisecondsSinceEpoch(a['date']);
        DateTime dateB = DateTime.fromMillisecondsSinceEpoch(b['date']);
        return dateB.compareTo(dateA);
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
        _expenses.insert(0, {
          'amount': amount,
          'category': _selectedCategory,
          'description': description,
          'date': _selectedDate.millisecondsSinceEpoch,
        });
        _filteredExpenses = _expenses;
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

  void _applyFilters() {
    setState(() {
      _filteredExpenses = _expenses.where((expense) {
        DateTime expenseDate =
            DateTime.fromMillisecondsSinceEpoch(expense['date']);
        bool matchesDate = true;

        if (_startDate != null) {
          DateTime expenseDateOnly =
              DateTime(expenseDate.year, expenseDate.month, expenseDate.day);
          DateTime startDateOnly =
              DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
          if (expenseDateOnly.isBefore(startDateOnly)) {
            matchesDate = false;
          }
        }

        if (matchesDate && _endDate != null) {
          DateTime endDateBoundary = DateTime(
              _endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59, 999);
          if (expenseDate.isAfter(endDateBoundary)) {
            matchesDate = false;
          }
        }

        bool matchesCategory = _toFilterCategory == 'All' ||
            (expense['category'] != null &&
                expense['category'] == _toFilterCategory);
        return matchesDate && matchesCategory;
      }).toList();
    });
  }

  Future<void> _pickStartDate() async {
    DateTime initialDate = _startDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _pickEndDate() async {
    DateTime initialDate = _endDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedCategory = 'All';
      _filteredExpenses = _expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Expense List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
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
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
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
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
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
                                icon:
                                    const Icon(Icons.calendar_today, size: 16),
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
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
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
                      child: const Text('Add Expense',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                  initiallyExpanded: false,
                  title: const Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white70,
                  backgroundColor: Colors.black,
                  collapsedBackgroundColor: Colors.black87,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          TextButton(
                            onPressed: () {
                              _clearFilters();
                            },
                            child: const Text(
                              'Clear Filters',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _pickStartDate,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[700]!),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _startDate == null
                                            ? 'Start Date'
                                            : _startDate!
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: _pickEndDate,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[700]!),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _endDate == null
                                            ? 'End Date'
                                            : _endDate!
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[700]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _toFilterCategory,
                            dropdownColor: Colors.grey[900],
                            iconEnabledColor: Colors.white70,
                            isExpanded: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            items: <String>[
                              'All',
                              'Food',
                              'Snacks',
                              'Travel',
                              'Daily Goods',
                              'Entertainment',
                              'Bills',
                              'Miscellaneous'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _toFilterCategory = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[850],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        onPressed: () {
                          _applyFilters();
                        },
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredExpenses.length,
                itemBuilder: (context, index) {
                  final expense = _filteredExpenses[index];
                  final formattedDate =
                      DateTime.fromMillisecondsSinceEpoch(expense['date']);
                  final date = formattedDate.toLocal().toString().split(' ')[0];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: MyCard.gradientCardSample(
                        expense['category'],
                        expense['description'],
                        expense['amount'].toStringAsFixed(2),
                        date,
                        context,
                        () {
                          setState(() {
                            _expenses.removeWhere(
                                (element) => mapEquals(element, expense));
                            _filteredExpenses.removeAt(index);
                            saveData();
                          });
                        },
                      ));
                },
              ),
            ),
          ],
        ));
  }
}
