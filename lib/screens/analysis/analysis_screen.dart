
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  DateTime _selectedMonth = DateTime.now();

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final firestoreService = FirestoreService();
    final theme = Theme.of(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Expense>>(
              stream: firestoreService.getExpenses(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allExpenses = snapshot.data!;
                final monthlyExpenses = allExpenses
                    .where((e) =>
                        e.date.month == _selectedMonth.month &&
                        e.date.year == _selectedMonth.year)
                    .toList();

                final spendingByCategory = <String, double>{};
                for (var expense in monthlyExpenses) {
                  spendingByCategory.update(
                    expense.category,
                    (value) => value + expense.amount,
                    ifAbsent: () => expense.amount,
                  );
                }

                final pieChartSections = spendingByCategory.entries.map((entry) {
                  final categoryIndex = categoryProvider.categories.indexOf(entry.key);
                  return PieChartSectionData(
                    color: _getColorForCategory(categoryIndex),
                    value: entry.value,
                    title: '${(entry.value / monthlyExpenses.fold(0.0, (sum, item) => sum + item.amount) * 100).toStringAsFixed(0)}%',
                    radius: 100,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList();

                return Column(
                  children: [
                    // Month Selector
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: _previousMonth,
                          ),
                          Text(
                            DateFormat('MMMM yyyy').format(_selectedMonth),
                            style: theme.textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: _nextMonth,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Pie Chart
                    SizedBox(
                      height: 250,
                      child: monthlyExpenses.isEmpty
                          ? const Center(child: Text("No expenses for this month"))
                          : PieChart(
                              PieChartData(
                                sections: pieChartSections,
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                              ),
                            ),
                    ),
                     const SizedBox(height: 20),
                    // Legend
                    Expanded(
                      child: ListView(
                        children: spendingByCategory.entries.map((entry) {
                           final categoryIndex = categoryProvider.categories.indexOf(entry.key);
                          return ListTile(
                            leading: Container(
                              width: 20,
                              height: 20,
                              color: _getColorForCategory(categoryIndex),
                            ),
                            title: Text(entry.key),
                            trailing: Text(
                              '\$${entry.value.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Color _getColorForCategory(int categoryIndex) {
    final colors = [
      Colors.red, 
      Colors.blue, 
      Colors.green, 
      Colors.orange, 
      Colors.purple, 
      Colors.brown, 
      Colors.teal, 
      Colors.pink,
      Colors.indigo,
      Colors.cyan
    ];
    return colors[categoryIndex % colors.length];
  }
}
