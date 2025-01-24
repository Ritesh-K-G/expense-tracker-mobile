import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;

  const ExpenseCard({super.key, required this.expenses});

  double getTotalExpenses() {
    return expenses.fold(0.0, (sum, item) => sum + item["amount"]);
  }

  double getTodayExpenses() {
    DateTime today = DateTime.now();
    return expenses.where((expense) {
      DateTime expenseDate = DateTime.fromMillisecondsSinceEpoch(expense["date"]);
      return expenseDate.day == today.day &&
          expenseDate.month == today.month &&
          expenseDate.year == today.year;
    }).fold(0.0, (sum, item) => sum + item["amount"]);
  }

  double getMonthExpenses() {
    DateTime today = DateTime.now();
    return expenses.where((expense) {
      DateTime expenseDate = DateTime.fromMillisecondsSinceEpoch(expense["date"]);
      return expenseDate.month == today.month &&
          expenseDate.year == today.year;
    }).fold(0.0, (sum, item) => sum + item["amount"]);
  }

  Map<String, double> getCategoryWiseExpenses() {
    Map<String, double> categoryExpenses = {};
    for (var expense in expenses) {
      String category = expense["category"];
      categoryExpenses[category] = (categoryExpenses[category] ?? 0.0) + expense["amount"];
    }
    return categoryExpenses;
  }

  @override
  Widget build(BuildContext context) {
    double totalExpenses = getTotalExpenses();
    double todayExpenses = getTodayExpenses();
    double monthExpenses = getMonthExpenses();
    Map<String, double> categoryExpenses = getCategoryWiseExpenses();

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with a gradient underline
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Text(
                  "Expense Summary",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 4,
                  width: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Total Expenses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Expenses",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "₹${totalExpenses.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey[700],
              height: 20,
            ),

            // Today's Expenses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Expenses",
                  style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                ),
                Text(
                  "₹${todayExpenses.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.orangeAccent),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Month's Expenses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Month's Expenses",
                  style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                ),
                Text(
                  "₹${monthExpenses.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.purpleAccent),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Category-wise Expenses with icons
            Text(
              "Category-wise Expenses:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: categoryExpenses.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.blueAccent, size: 10),
                          SizedBox(width: 8),
                          Text(
                            entry.key,
                            style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                          ),
                        ],
                      ),
                      Text(
                        "₹${entry.value.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.tealAccent),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
