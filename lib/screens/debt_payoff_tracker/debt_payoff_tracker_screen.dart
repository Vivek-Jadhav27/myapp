
import 'package:flutter/material.dart';
import 'package:myapp/models/debt.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:provider/provider.dart';

class DebtPayoffTrackerScreen extends StatefulWidget {
  const DebtPayoffTrackerScreen({super.key});

  @override
  State<DebtPayoffTrackerScreen> createState() => _DebtPayoffTrackerScreenState();
}

class _DebtPayoffTrackerScreenState extends State<DebtPayoffTrackerScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debt Payoff Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddDebtDialog(context, user!.uid);
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Debt>>(
              stream: _firestoreService.getDebts(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final debts = snapshot.data!;

                return ListView.builder(
                  itemCount: debts.length,
                  itemBuilder: (context, index) {
                    final debt = debts[index];
                    double progress = debt.amountPaid / debt.totalAmount;

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
                                Text(debt.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _firestoreService.deleteDebt(debt.id);
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
                            Text('\$${debt.amountPaid.toStringAsFixed(2)} / \$${debt.totalAmount.toStringAsFixed(2)}'),
                            Text('Interest Rate: ${debt.interestRate}%'),
                            Text('Minimum Payment: \$${debt.minimumPayment.toStringAsFixed(2)}'),
                            ElevatedButton(onPressed: () => _showAddPaymentDialog(context, debt), child: const Text("Add Payment"))
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

  void _showAddDebtDialog(BuildContext context, String userId) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    double totalAmount = 0;
    double interestRate = 0;
    double minimumPayment = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Debt'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Debt Name'),
                    validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Total Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Please enter an amount' : null,
                    onChanged: (value) {
                      totalAmount = double.tryParse(value) ?? 0;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Interest Rate (%)'),
                    keyboardType: TextInputType.number,
                     validator: (value) => value!.isEmpty ? 'Please enter an interest rate' : null,
                    onChanged: (value) {
                      interestRate = double.tryParse(value) ?? 0;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Minimum Monthly Payment'),
                    keyboardType: TextInputType.number,
                     validator: (value) => value!.isEmpty ? 'Please enter a minimum payment' : null,
                    onChanged: (value) {
                      minimumPayment = double.tryParse(value) ?? 0;
                    },
                  ),
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
                  final debt = Debt(
                    id: '',
                    userId: userId,
                    name: name,
                    totalAmount: totalAmount,
                    amountPaid: 0,
                    interestRate: interestRate,
                    minimumPayment: minimumPayment,
                  );
                  await _firestoreService.addDebt(debt);
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

  void _showAddPaymentDialog(BuildContext context, Debt debt) {
    final _formKey = GlobalKey<FormState>();
    double amount = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Payment for ${debt.name}'),
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
                   final newAmountPaid = debt.amountPaid + amount;
                  final updatedDebt = Debt(
                    id: debt.id,
                    userId: debt.userId,
                    name: debt.name,
                    totalAmount: debt.totalAmount,
                    amountPaid: newAmountPaid > debt.totalAmount ? debt.totalAmount : newAmountPaid,
                    interestRate: debt.interestRate,
                    minimumPayment: debt.minimumPayment,
                  );
                  await _firestoreService.updateDebt(updatedDebt);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Add Payment'),
            ),
          ],
        );
      },
    );
  }
}
