import 'transaction.dart';

class Income extends TransactionEntity {
  const Income({
    required super.id,
    required super.userId,
    required super.amount,
    required super.date,
    required super.category,
    required super.description,
  }) : super(type: TransactionType.income);
}
