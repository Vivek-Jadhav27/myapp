import 'transaction_model.dart';
import '../../domain/entities/transaction.dart';

class IncomeModel extends TransactionModel {
  const IncomeModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.date,
    required super.category,
    required super.description,
  }) : super(type: TransactionType.income);
}
