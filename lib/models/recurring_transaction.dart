import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { income, expense }

enum Recurrence { daily, weekly, monthly, yearly }

class RecurringTransaction {
  final String id;
  final String userId;
  final String description;
  final double amount;
  final TransactionType type;
  final Recurrence recurrence;
  final DateTime startDate;
  final DateTime? endDate;

  RecurringTransaction({
    required this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.type,
    required this.recurrence,
    required this.startDate,
    this.endDate,
  });

  factory RecurringTransaction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return RecurringTransaction(
      id: doc.id,
      userId: data['userId'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      type: TransactionType.values[data['type'] ?? 0],
      recurrence: Recurrence.values[data['recurrence'] ?? 0],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: data['endDate'] != null
          ? (data['endDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'description': description,
      'amount': amount,
      'type': type.index,
      'recurrence': recurrence.index,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
    };
  }
}
