import 'transaction.dart';

class Expense extends TransactionEntity {
  const Expense({
    required super.id,
    required super.userId,
    required super.amount,
    required super.date,
    required super.category,
    required super.description,
  }) : super(type: TransactionType.expense);
}
