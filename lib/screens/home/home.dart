
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/income.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:myapp/widgets/add_expense.dart';
import 'package:myapp/widgets/add_income.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final firestoreService = FirestoreService();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: <Widget>[
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          TextButton.icon(
            icon: const Icon(Icons.person, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: user != null
          ? StreamBuilder<List<Income>>(
              stream: firestoreService.getIncome(user.uid),
              builder: (context, incomeSnapshot) {
                return StreamBuilder<List<Expense>>(
                  stream: firestoreService.getExpenses(user.uid),
                  builder: (context, expenseSnapshot) {
                    if (incomeSnapshot.hasError || expenseSnapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    }
                    if (incomeSnapshot.connectionState == ConnectionState.waiting ||
                        expenseSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final incomeList = incomeSnapshot.data ?? [];
                    final expenseList = expenseSnapshot.data ?? [];

                    final totalIncome = incomeList.fold(0.0, (sum, item) => sum + item.amount);
                    final totalExpense = expenseList.fold(0.0, (sum, item) => sum + item.amount);
                    final total = totalIncome - totalExpense;

                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total: \$${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),
                        const Divider(),
                        Text('Income', style: Theme.of(context).textTheme.titleLarge),
                        Expanded(
                          child: IncomeList(incomeList: incomeList),
                        ),
                        const Divider(),
                        Text('Expenses', style: Theme.of(context).textTheme.titleLarge),
                        Expanded(
                          child: ExpenseList(expenseList: expenseList, firestoreService: firestoreService),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          : Container(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => AddIncome(userId: user!.uid),
              );
            },
            heroTag: 'addIncome',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => AddExpense(userId: user!.uid),
              );
            },
            heroTag: 'addExpense',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class IncomeList extends StatelessWidget {
  final List<Income> incomeList;
  const IncomeList({super.key, required this.incomeList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: incomeList.length,
      itemBuilder: (context, index) {
        final income = incomeList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text(income.source, style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text('\$${income.amount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
          ),
        );
      },
    );
  }
}

class ExpenseList extends StatelessWidget {
  final List<Expense> expenseList;
  final FirestoreService firestoreService;
  const ExpenseList({super.key, required this.expenseList, required this.firestoreService});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenseList.length,
      itemBuilder: (context, index) {
        final expense = expenseList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text(expense.category, style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text('\$${expense.amount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                firestoreService.deleteExpense(expense.id);
              },
            ),
          ),
        );
      },
    );
  }
}
