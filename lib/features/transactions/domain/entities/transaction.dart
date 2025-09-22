
import 'package:equatable/equatable.dart';

enum TransactionType {
  income,
  expense,
}

abstract class TransactionEntity extends Equatable {
  final String id;
  final String userId;
  final double amount;
  final DateTime date;
  final String category;
  final String description;
  final TransactionType type;

  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
    required this.category,
    required this.description,
    required this.type,
  });

  @override
  List<Object?> get props => [id, userId, amount, date, category, description, type];
}
