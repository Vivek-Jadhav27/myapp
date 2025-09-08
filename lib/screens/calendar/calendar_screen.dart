
import 'package:flutter/material.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/income.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:myapp/widgets/add_expense.dart';
import 'package:myapp/widgets/add_income.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final firestoreService = FirestoreService();

    return user == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: StreamBuilder<List<Income>>(
              stream: firestoreService.getIncome(user.uid),
              builder: (context, incomeSnapshot) {
                return StreamBuilder<List<Expense>>(
                  stream: firestoreService.getExpenses(user.uid),
                  builder: (context, expenseSnapshot) {
                    if (incomeSnapshot.connectionState == ConnectionState.waiting || expenseSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final incomeList = incomeSnapshot.data ?? [];
                    final expenseList = expenseSnapshot.data ?? [];

                    final monthlyIncome = incomeList
                        .where((i) => i.date.month == _focusedDay.month && i.date.year == _focusedDay.year)
                        .fold(0.0, (sum, item) => sum + item.amount);
                    final monthlyExpense = expenseList
                        .where((e) => e.date.month == _focusedDay.month && e.date.year == _focusedDay.year)
                        .fold(0.0, (sum, item) => sum + item.amount);
                    final monthlySavings = monthlyIncome - monthlyExpense;

                    List<String> getEventsForDay(DateTime day) {
                      final events = <String>[];
                      if (incomeList.any((income) => isSameDay(income.date, day))) {
                        events.add('income');
                      }
                      if (expenseList.any((expense) => isSameDay(expense.date, day))) {
                        events.add('expense');
                      }
                      return events;
                    }

                    final selectedDayIncomes = _selectedDay != null
                        ? incomeList.where((i) => isSameDay(i.date, _selectedDay!)).toList()
                        : <Income>[];
                    final selectedDayExpenses = _selectedDay != null
                        ? expenseList.where((e) => isSameDay(e.date, _selectedDay!)).toList()
                        : <Expense>[];

                    return Column(
                      children: [
                        // Monthly Summary
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSummary('Income', '\$${monthlyIncome.toStringAsFixed(2)}', Colors.green),
                              _buildSummary('Expenses', '\$${monthlyExpense.toStringAsFixed(2)}', Colors.red),
                              _buildSummary('Savings', '\$${monthlySavings.toStringAsFixed(2)}', Colors.blue),
                            ],
                          ),
                        ),
                        // Calendar
                        TableCalendar(
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          eventLoader: getEventsForDay,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, day, events) {
                              if (events.isEmpty) return null;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: events.map((event) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: event == 'income' ? Colors.green : Colors.red,
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: ListView(
                            children: [
                              ...selectedDayIncomes.map((income) => IncomeTransactionListTile(income: income)),
                              ...selectedDayExpenses.map((expense) => ExpenseTransactionListTile(expense: expense, firestoreService: firestoreService)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            floatingActionButton: _selectedDay != null ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => AddTransactionSheet(selectedDate: _selectedDay!, userId: user.uid),
                );
              },
              child: const Icon(Icons.add),
            ) : null,
    );
  }

  Widget _buildSummary(String title, String amount, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(amount, style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class IncomeTransactionListTile extends StatelessWidget {
  final Income income;
  const IncomeTransactionListTile({super.key, required this.income});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: const Icon(Icons.attach_money, color: Colors.green),
        title: Text(income.source),
        subtitle: Text('\$${income.amount.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            // Add delete functionality here
          },
        ),
      ),
    );
  }
}

class ExpenseTransactionListTile extends StatelessWidget {
  final Expense expense;
  final FirestoreService firestoreService;
  const ExpenseTransactionListTile({super.key, required this.expense, required this.firestoreService});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: const Icon(Icons.money_off, color: Colors.red),
        title: Text(expense.category),
        subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            firestoreService.deleteExpense(expense.id);
          },
        ),
      ),
    );
  }
}

class AddTransactionSheet extends StatelessWidget {
  final DateTime selectedDate;
  final String userId;
  const AddTransactionSheet({super.key, required this.selectedDate, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Add a new transaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Income', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                builder: (context) => AddIncome(userId: userId, selectedDate: selectedDate),
              );
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.remove, color: Colors.white),
            label: const Text('Add Expense', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 50)),
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                builder: (context) => AddExpense(userId: userId, selectedDate: selectedDate),
              );
            },
          ),
        ],
      ),
    );
  }
}
