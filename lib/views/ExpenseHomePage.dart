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
  List<Map<String, dynamic>> _allExpenses = [];
  List<Map<String, dynamic>> _filteredExpenses = [];
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
  String _selectedAddCategory = 'Food';
  late SharedPreferences pref;

  String _selectedCategory = 'All';
  DateTime? _startDate;
  DateTime? _endDate;

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
    List<Map<String, dynamic>> expenses = loadData();
    setState(() {
      _allExpenses = expenses;
      _filteredExpenses = expenses;
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

  void _applyFilters() {
    setState(() {
      _filteredExpenses = _allExpenses.where((expense) {
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

        bool matchesCategory = _selectedCategory == 'All' ||
            (expense['category'] != null &&
                expense['category'] == _selectedCategory);
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
      _filteredExpenses = _allExpenses;
    });
  }

  void saveData() async {
    String encodedData = json.encode(_allExpenses);
    await pref.setString('expense_data_test', encodedData);
    setState(() {});
  }

  void _addExpense() {
    final double? amount = double.tryParse(_amountController.text);
    final String description = _descriptionController.text;

    if (amount != null) {
      setState(() {
        _allExpenses.insert(0, {
          'amount': amount,
          'category': _selectedAddCategory,
          'description': description,
          'date': _selectedDate.millisecondsSinceEpoch,
        });
        _filteredExpenses = _allExpenses;
      });
      _amountController.clear();
      _descriptionController.clear();
      saveData();
    }
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
                            value: _selectedAddCategory,
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
                                _selectedAddCategory = newValue!;
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
                                    border:
                                        Border.all(color: Colors.grey[700]!),
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
                                    border:
                                        Border.all(color: Colors.grey[700]!),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[700]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
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
                                    _selectedCategory = newValue;
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          onPressed: () {
                            _applyFilters();
                          },
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  )),
              ExpenseCard(
                key: ValueKey('ExpenseCard_${_filteredExpenses.hashCode}'),
                expenses: _filteredExpenses,
              ),
              CategoryDistributionPieChart(
                key: ValueKey(
                    'CategoryDistribution_${_filteredExpenses.hashCode}'),
                expenses: _filteredExpenses,
              ),
              Cumulativelinechart(
                  key: ValueKey(
                      'CumulativeLineChart_${_filteredExpenses.hashCode}'),
                  expenses: _filteredExpenses),
              Dailylinechart(
                key: ValueKey('DailyLineChart_${_filteredExpenses.hashCode}'),
                expenses: _filteredExpenses,
              ),
            ],
          ),
        ));
  }
}
