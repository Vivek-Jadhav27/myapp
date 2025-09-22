import 'package:myapp/features/transactions/domain/entities/transaction.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.date,
    required super.category,
    required super.description,
    required super.type,
  });

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      userId: entity.userId,
      amount: entity.amount,
      date: entity.date,
      category: entity.category,
      description: entity.description,
      type: entity.type,
    );
  }

  TransactionEntity toEntity() {
    return this;
  }
}
