
import 'package:flutter/material.dart';
import 'package:myapp/models/budget.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Budget>>(
              stream: _firestoreService.getBudgets(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final budgets = snapshot.data!;

                return ListView.builder(
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    final budget = budgets.firstWhere(
                      (b) => b.category == category,
                      orElse: () => Budget(id: '', userId: user.uid, category: category, amount: 0),
                    );

                    return ListTile(
                      title: Text(category),
                      subtitle: Text('Budget: \$${budget.amount.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showBudgetDialog(context, user.uid, category, budget.amount);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showBudgetDialog(BuildContext context, String userId, String category, double currentAmount) {
    final _formKey = GlobalKey<FormState>();
    double newAmount = currentAmount;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Budget for $category'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              initialValue: currentAmount.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              validator: (value) => value!.isEmpty ? 'Please enter an amount' : null,
              onChanged: (value) {
                newAmount = double.tryParse(value) ?? 0;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final budget = Budget(id: '', userId: userId, category: category, amount: newAmount);
                  await _firestoreService.setBudget(budget);
                  if(mounted){
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }
}
