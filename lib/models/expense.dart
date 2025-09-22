
import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final DateTime date;
  final String? notes; // Added notes field

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    this.notes, // Added to constructor
  });

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      userId: data['userId'],
      amount: data['amount'],
      category: data['category'],
      date: (data['date'] as Timestamp).toDate(),
      notes: data['notes'], // Read from Firestore
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category,
      'date': date,
      'notes': notes, // Write to Firestore
    };
  }
}
