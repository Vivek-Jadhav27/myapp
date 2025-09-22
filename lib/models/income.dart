import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  final String id;
  final String userId;
  final double amount;
  final String source;
  final DateTime date;
  final String? notes; // Added notes field

  Income({
    required this.id,
    required this.userId,
    required this.amount,
    required this.source,
    required this.date,
    this.notes, // Added to constructor
  });

  factory Income.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Income(
      id: doc.id,
      userId: data['userId'],
      amount: data['amount'],
      source: data['source'],
      date: (data['date'] as Timestamp).toDate(),
      notes: data['notes'], // Read from Firestore
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'amount': amount,
      'source': source,
      'date': date,
      'notes': notes, // Write to Firestore
    };
  }
}
