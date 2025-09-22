
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
    final theme = Theme.of(context);

    // Pastel & Friendly Theme Colors
    const Color incomeColor = Color(0xFF6EE7B7); // Soft Mint Green
    const Color expenseColor = Color(0xFFFCA5A5); // Soft Coral Red
    const Color savingsColor = Color(0xFF93C5FD); // Pastel Blue

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
                              _buildSummary('Income', '\$${monthlyIncome.toStringAsFixed(2)}', incomeColor),
                              _buildSummary('Expenses', '\$${monthlyExpense.toStringAsFixed(2)}', expenseColor),
                              _buildSummary('Savings', '\$${monthlySavings.toStringAsFixed(2)}', savingsColor),
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
                           calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
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
                                      color: event == 'income' ? incomeColor : expenseColor,
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
                              ...selectedDayIncomes.map((income) => IncomeTransactionListTile(income: income, firestoreService: firestoreService)),
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
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
        const SizedBox(height: 4),
        Text(amount, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class IncomeTransactionListTile extends StatelessWidget {
  final Income income;
  final FirestoreService firestoreService;
  const IncomeTransactionListTile({super.key, required this.income, required this.firestoreService});

 @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: const Icon(Icons.attach_money, color: Color(0xFF6EE7B7)),
        title: Text(income.source, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${income.amount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
            if (income.notes?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  income.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Color(0xFFFCA5A5)),
          onPressed: () async {
            final confirm = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Deletion'),
                content: const Text('Are you sure you want to delete this income?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              firestoreService.deleteIncome(income.id);
            }
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
        leading: const Icon(Icons.money_off, color: Color(0xFFFCA5A5)),
        title: Text(expense.category, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${expense.amount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
            if (expense.notes?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  expense.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Color(0xFFFCA5A5)),
          onPressed: () async {
            final confirm = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Deletion'),
                content: const Text('Are you sure you want to delete this expense?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              firestoreService.deleteExpense(expense.id);
            }
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
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Add a new transaction', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text('Add Income', style: Theme.of(context).textTheme.labelLarge),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6EE7B7), minimumSize: const Size(double.infinity, 50)),
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
            label: Text('Add Expense', style: Theme.of(context).textTheme.labelLarge),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFCA5A5), minimumSize: const Size(double.infinity, 50)),
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
