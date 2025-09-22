import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction_uc.dart';
import '../../domain/usecases/delete_transaction_uc.dart';
import '../../domain/usecases/get_transactions_uc.dart';
import '../../domain/usecases/update_transaction_uc.dart';

class TransactionProvider extends ChangeNotifier {
  final AddTransactionUC addTransactionUC;
  final GetTransactionsUC getTransactionsUC;
  final UpdateTransactionUC updateTransactionUC;
  final DeleteTransactionUC deleteTransactionUC;

  TransactionProvider({
    required this.addTransactionUC,
    required this.getTransactionsUC,
    required this.updateTransactionUC,
    required this.deleteTransactionUC,
  });

  List<TransactionEntity> _transactions = [];
  List<TransactionEntity> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    _setLoading(true);
    final result = await addTransactionUC(transaction);
    result.fold(
      (failure) => _setError(failure.toString()),
      (_) => _setError(null),
    );
    _setLoading(false);
  }

  Future<void> getTransactions(String userId, DateTime date) async {
    _setLoading(true);
    final result = await getTransactionsUC(GetTransactionsParams(userId: userId, date: date));
    result.fold(
      (failure) => _setError(failure.toString()),
      (transactions) {
        _transactions = transactions;
        _setError(null);
      },
    );
    _setLoading(false);
  }

  Future<void> updateTransaction(TransactionEntity transaction) async {
    _setLoading(true);
    final result = await updateTransactionUC(transaction);
    result.fold(
      (failure) => _setError(failure.toString()),
      (_) => _setError(null),
    );
    _setLoading(false);
  }

  Future<void> deleteTransaction(String transactionId) async {
    _setLoading(true);
    final result = await deleteTransactionUC(transactionId);
    result.fold(
      (failure) => _setError(failure.toString()),
      (_) => _setError(null),
    );
    _setLoading(false);
  }
}
