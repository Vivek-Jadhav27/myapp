
import 'package:flutter/material.dart';
import 'package:myapp/screens/budget/budget_screen.dart';
import 'package:myapp/screens/chat/chat_screen.dart';
import 'package:myapp/screens/debt_payoff_tracker/debt_payoff_tracker_screen.dart';
import 'package:myapp/screens/financial_goals/financial_goals_screen.dart';
import 'package:myapp/screens/recurring_transactions/recurring_transactions_screen.dart';
import 'package:myapp/screens/settings/manage_categories.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Manage Categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageCategoriesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Budgets'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BudgetScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.autorenew),
            title: const Text('Recurring Transactions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecurringTransactionsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Financial Goals'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinancialGoalsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Debt Payoff Tracker'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DebtPayoffTrackerScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assistant),
            title: const Text('Financial Assistant'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
