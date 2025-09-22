import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/transaction_model.dart';

abstract class TransactionDS {
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions(String userId, DateTime date);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String transactionId);
}

class TransactionDSImpl implements TransactionDS {
  final FirebaseFirestore firestore;

  TransactionDSImpl({required this.firestore});

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await firestore.collection('transactions').add(transaction.toFirestore());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions(String userId, DateTime date) async {
    try {
      final startOfMonth = DateTime(date.year, date.month, 1);
      final endOfMonth = DateTime(date.year, date.month + 1, 0);

      final querySnapshot = await firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      return querySnapshot.docs.map((doc) => TransactionModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await firestore
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toFirestore());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await firestore.collection('transactions').doc(transactionId).delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
