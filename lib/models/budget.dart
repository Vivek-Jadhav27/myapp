
import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final String id;
  final String userId;
  final String category;
  final double amount;

  Budget({required this.id, required this.userId, required this.category, required this.amount});

  factory Budget.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Budget(
      id: doc.id,
      userId: data['userId'] ?? '',
      category: data['category'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'category': category,
      'amount': amount,
    };
  }
}
