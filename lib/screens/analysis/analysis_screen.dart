
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final firestoreService = FirestoreService();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analysis'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Monthly Breakdown'),
              Tab(text: 'Spending Trends'),
            ],
          ),
        ),
        body: user == null
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder<List<Expense>>(
                stream: firestoreService.getExpenses(user.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allExpenses = snapshot.data!;

                  return TabBarView(
                    children: [
                      MonthlyBreakdownTab(allExpenses: allExpenses),
                      SpendingTrendsTab(allExpenses: allExpenses),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class MonthlyBreakdownTab extends StatefulWidget {
  final List<Expense> allExpenses;

  const MonthlyBreakdownTab({super.key, required this.allExpenses});

  @override
  State<MonthlyBreakdownTab> createState() => _MonthlyBreakdownTabState();
}

class _MonthlyBreakdownTabState extends State<MonthlyBreakdownTab> {
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
    final theme = Theme.of(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    final monthlyExpenses = widget.allExpenses
        .where((e) =>
            e.date.month == _selectedMonth.month && e.date.year == _selectedMonth.year)
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
        title:
            '${(entry.value / monthlyExpenses.fold(0.0, (sum, item) => sum + item.amount) * 100).toStringAsFixed(0)}%',
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
  }
}

class SpendingTrendsTab extends StatelessWidget {
  final List<Expense> allExpenses;

  const SpendingTrendsTab({super.key, required this.allExpenses});

  @override
  Widget build(BuildContext context) {
    final monthlyTotals = <DateTime, double>{};
    for (var expense in allExpenses) {
      final month = DateTime(expense.date.year, expense.date.month);
      monthlyTotals.update(month, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    final sortedMonths = monthlyTotals.keys.toList()..sort();
    final lastSixMonths = sortedMonths.length > 6 ? sortedMonths.sublist(sortedMonths.length - 6) : sortedMonths;

    final barChartGroups = lastSixMonths.map((month) {
      final monthIndex = lastSixMonths.indexOf(month);
      return BarChartGroupData(
        x: monthIndex,
        barRods: [
          BarChartRodData(
            toY: monthlyTotals[month]!,
            color: Colors.blue,
            width: 16,
          ),
        ],
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Monthly Spending Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (monthlyTotals.values.isEmpty ? 0 : monthlyTotals.values.reduce((a, b) => a > b ? a : b)) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final monthIndex = value.toInt();
                        if (monthIndex >= 0 && monthIndex < lastSixMonths.length) {
                          return Text(DateFormat('MMM').format(lastSixMonths[monthIndex]));
                        }
                        return const Text('');
                      },
                      reservedSize: 38,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: barChartGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
