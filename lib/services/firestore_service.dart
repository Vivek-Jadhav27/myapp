
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/app_user.dart';
import 'package:myapp/models/budget.dart';
import 'package:myapp/models/debt.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/financial_goal.dart';
import 'package:myapp/models/income.dart';
import 'package:myapp/models/recurring_transaction.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new user
  Future<void> addUser(AppUser user) {
    return _db.collection('users').doc(user.uid).set(user.toFirestore());
  }

  // Update a user
  Future<void> updateUser(AppUser user) {
    return _db.collection('users').doc(user.uid).update(user.toFirestore());
  }

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

  // Delete income
  Future<void> deleteIncome(String incomeId) {
    return _db.collection('incomes').doc(incomeId).delete();
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

  // Get budgets for a user
  Stream<List<Budget>> getBudgets(String userId) {
    return _db
        .collection('budgets')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Budget.fromFirestore(doc)).toList());
  }

  // Set budget
  Future<void> setBudget(Budget budget) {
    // Use a composite key for the document ID to ensure one budget per user per category
    String docId = '${budget.userId}_${budget.category}';
    return _db.collection('budgets').doc(docId).set(budget.toFirestore());
  }

  // Get recurring transactions for a user
  Stream<List<RecurringTransaction>> getRecurringTransactions(String userId) {
    return _db
        .collection('recurring_transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => RecurringTransaction.fromFirestore(doc)).toList());
  }

  // Add recurring transaction
  Future<DocumentReference> addRecurringTransaction(RecurringTransaction transaction) {
    return _db.collection('recurring_transactions').add(transaction.toFirestore());
  }

  // Delete recurring transaction
  Future<void> deleteRecurringTransaction(String transactionId) {
    return _db.collection('recurring_transactions').doc(transactionId).delete();
  }

  // Get financial goals for a user
  Stream<List<FinancialGoal>> getFinancialGoals(String userId) {
    return _db
        .collection('financial_goals')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FinancialGoal.fromFirestore(doc)).toList());
  }

  // Add financial goal
  Future<DocumentReference> addFinancialGoal(FinancialGoal goal) {
    return _db.collection('financial_goals').add(goal.toFirestore());
  }

  // Update financial goal
  Future<void> updateFinancialGoal(FinancialGoal goal) {
    return _db.collection('financial_goals').doc(goal.id).update(goal.toFirestore());
  }

  // Delete financial goal
  Future<void> deleteFinancialGoal(String goalId) {
    return _db.collection('financial_goals').doc(goalId).delete();
  }

  // Get debts for a user
  Stream<List<Debt>> getDebts(String userId) {
    return _db
        .collection('debts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Debt.fromFirestore(doc)).toList());
  }

  // Add debt
  Future<DocumentReference> addDebt(Debt debt) {
    return _db.collection('debts').add(debt.toFirestore());
  }

  // Update debt
  Future<void> updateDebt(Debt debt) {
    return _db.collection('debts').doc(debt.id).update(debt.toFirestore());
  }

  // Delete debt
  Future<void> deleteDebt(String debtId) {
    return _db.collection('debts').doc(debtId).delete();
  }
}
