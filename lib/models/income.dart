
import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  final String id;
  final String userId;
  final double amount;
  final String source;
  final DateTime date;

  Income({
    required this.id,
    required this.userId,
    required this.amount,
    required this.source,
    required this.date,
  });

  factory Income.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Income(
      id: doc.id,
      userId: data['userId'],
      amount: data['amount'],
      source: data['source'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'amount': amount,
      'source': source,
      'date': date,
    };
  }
}
