
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/income.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add income
  Future<void> addIncome(Income income) {
    return _db.collection('incomes').add(income.toFirestore());
  }

  // Get income for a user
  Stream<List<Income>> getIncome(String userId) {
    return _db
        .collection('incomes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Income.fromFirestore(doc)).toList());
  }

  // Add expense
  Future<void> addExpense(Expense expense) {
    return _db.collection('expenses').add(expense.toFirestore());
  }

  // Get expenses for a user
  Stream<List<Expense>> getExpenses(String userId) {
    return _db
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList());
  }

  // Delete expense
  Future<void> deleteExpense(String expenseId) {
    return _db.collection('expenses').doc(expenseId).delete();
  }

  // Update expense
  Future<void> updateExpense(Expense expense) {
    return _db.collection('expenses').doc(expense.id).update(expense.toFirestore());
  }
}
