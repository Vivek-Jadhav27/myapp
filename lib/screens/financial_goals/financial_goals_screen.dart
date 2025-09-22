
import 'package:flutter/material.dart';
import 'package:myapp/models/financial_goal.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:provider/provider.dart';

class FinancialGoalsScreen extends StatefulWidget {
  const FinancialGoalsScreen({super.key});

  @override
  State<FinancialGoalsScreen> createState() => _FinancialGoalsScreenState();
}

class _FinancialGoalsScreenState extends State<FinancialGoalsScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddGoalDialog(context, user!.uid);
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<FinancialGoal>>(
              stream: _firestoreService.getFinancialGoals(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final goals = snapshot.data!;

                return ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    double progress = goal.currentAmount / goal.targetAmount;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(goal.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _firestoreService.deleteFinancialGoal(goal.id);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                            ),
                            const SizedBox(height: 10),
                            Text('\$${goal.currentAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}'),
                            Text('Deadline: ${goal.deadline.toLocal().toString().split(' ')[0]}'),
                            ElevatedButton(onPressed: () => _showContributeDialog(context, goal), child: const Text("Contribute"))
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showAddGoalDialog(BuildContext context, String userId) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    double targetAmount = 0;
    DateTime deadline = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Financial Goal'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Goal Name'),
                    validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Target Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Please enter an amount' : null,
                    onChanged: (value) {
                      targetAmount = double.tryParse(value) ?? 0;
                    },
                  ),
                  // Date Picker for deadline
                ],
              ),
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
                  final goal = FinancialGoal(
                    id: '',
                    userId: userId,
                    name: name,
                    targetAmount: targetAmount,
                    currentAmount: 0,
                    deadline: deadline,
                  );
                  await _firestoreService.addFinancialGoal(goal);
                  if(mounted){
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
  
  void _showContributeDialog(BuildContext context, FinancialGoal goal) {
    final _formKey = GlobalKey<FormState>();
    double amount = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Contribute to ${goal.name}'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter an amount' : null,
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0;
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
                   final newAmount = goal.currentAmount + amount;
                  final updatedGoal = FinancialGoal(
                    id: goal.id,
                    userId: goal.userId,
                    name: goal.name,
                    targetAmount: goal.targetAmount,
                    currentAmount: newAmount > goal.targetAmount ? goal.targetAmount : newAmount,
                    deadline: goal.deadline,
                  );
                  await _firestoreService.updateFinancialGoal(updatedGoal);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Contribute'),
            ),
          ],
        );
      },
    );
  }

}
