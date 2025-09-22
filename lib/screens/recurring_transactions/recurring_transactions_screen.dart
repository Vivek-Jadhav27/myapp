
import 'package:flutter/material.dart';
import 'package:myapp/models/recurring_transaction.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:provider/provider.dart';

class RecurringTransactionsScreen extends StatefulWidget {
  const RecurringTransactionsScreen({super.key});

  @override
  State<RecurringTransactionsScreen> createState() => _RecurringTransactionsScreenState();
}

class _RecurringTransactionsScreenState extends State<RecurringTransactionsScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddTransactionDialog(context, user!.uid);
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<RecurringTransaction>>(
              stream: _firestoreService.getRecurringTransactions(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final transactions = snapshot.data!;

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return ListTile(
                      title: Text(transaction.description),
                      subtitle: Text(
                          '\$${transaction.amount.toStringAsFixed(2)} - ${transaction.recurrence.toString().split('.').last}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _firestoreService.deleteRecurringTransaction(transaction.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showAddTransactionDialog(BuildContext context, String userId) {
    final _formKey = GlobalKey<FormState>();
    String description = '';
    double amount = 0;
    TransactionType type = TransactionType.expense;
    Recurrence recurrence = Recurrence.monthly;
    DateTime startDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Recurring Transaction'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Please enter an amount' : null,
                    onChanged: (value) {
                      amount = double.tryParse(value) ?? 0;
                    },
                  ),
                  DropdownButtonFormField<TransactionType>(
                    value: type,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: TransactionType.values.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type.toString().split('.').last));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        type = value!;
                      });
                    },
                  ),
                  DropdownButtonFormField<Recurrence>(
                    value: recurrence,
                    decoration: const InputDecoration(labelText: 'Recurrence'),
                    items: Recurrence.values.map((recurrence) {
                      return DropdownMenuItem(value: recurrence, child: Text(recurrence.toString().split('.').last));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        recurrence = value!;
                      });
                    },
                  ),
                  // Start Date Picker
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
                  final transaction = RecurringTransaction(
                    id: '',
                    userId: userId,
                    description: description,
                    amount: amount,
                    type: type,
                    recurrence: recurrence,
                    startDate: startDate,
                  );
                  await _firestoreService.addRecurringTransaction(transaction);
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
}
