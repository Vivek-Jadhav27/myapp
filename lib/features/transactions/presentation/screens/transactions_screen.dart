import 'package:flutter/material.dart';
import 'package:myapp/features/transactions/domain/entities/transaction.dart';
import 'package:myapp/features/transactions/presentation/screens/add_edit_transaction_screen.dart';
import 'package:provider/provider.dart';
import '../provider/transaction_provider.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: RefreshIndicator(
        onRefresh: () => transactionProvider.getTransactions('1', DateTime.now()),
        child: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.error != null) {
              return Center(child: Text('Error: ${provider.error}'));
            } else if (provider.transactions.isEmpty) {
              return const Center(child: Text('No transactions yet.'));
            } else {
              return ListView.builder(
                itemCount: provider.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = provider.transactions[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(transaction.description),
                      subtitle: Text(transaction.category),
                      leading: CircleAvatar(
                        child: Text(transaction.type == TransactionType.income ? '+' : '-'),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${transaction.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: transaction.type == TransactionType.income
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await provider.deleteTransaction(transaction.id);
                              // ignore: use_build_context_synchronously
                              Provider.of<TransactionProvider>(context, listen: false).getTransactions('1', DateTime.now());
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddEditTransactionScreen(
                              transaction: transaction,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
