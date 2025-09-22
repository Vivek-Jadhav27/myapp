import 'package:flutter/material.dart';
import 'package:myapp/features/transactions/data/models/transaction_model.dart';
import 'package:myapp/features/transactions/domain/entities/transaction.dart';
import 'package:myapp/features/transactions/presentation/provider/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final TransactionEntity? transaction;

  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late DateTime _selectedDate;
  late TransactionType _selectedType;
  bool get isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.transaction?.amount.toString());
    _descriptionController =
        TextEditingController(text: widget.transaction?.description);
    _categoryController =
        TextEditingController(text: widget.transaction?.category);
    _selectedDate = widget.transaction?.date ?? DateTime.now();
    _selectedType = widget.transaction?.type ?? TransactionType.expense;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text);
      if (amount == null) {
        // Show an error or handle it gracefully
        return;
      }

      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);

      final transaction = TransactionModel(
        id: widget.transaction?.id ?? const Uuid().v4(),
        userId: '1', // Replace with actual user ID
        amount: amount,
        description: _descriptionController.text,
        category: _categoryController.text,
        date: _selectedDate,
        type: _selectedType,
      );

      try {
        if (isEditing) {
          await transactionProvider.updateTransaction(transaction);
        } else {
          await transactionProvider.addTransaction(transaction);
        }

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save transaction: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                DropdownButtonFormField<TransactionType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: TransactionType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(isEditing ? 'Update' : 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
