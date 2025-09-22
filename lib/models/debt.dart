
import 'package:cloud_firestore/cloud_firestore.dart';

class Debt {
  final String id;
  final String userId;
  final String name;
  final double totalAmount;
  final double amountPaid;
  final double interestRate;
  final double minimumPayment;

  Debt({
    required this.id,
    required this.userId,
    required this.name,
    required this.totalAmount,
    required this.amountPaid,
    required this.interestRate,
    required this.minimumPayment,
  });

  factory Debt.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Debt(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      amountPaid: (data['amountPaid'] ?? 0).toDouble(),
      interestRate: (data['interestRate'] ?? 0).toDouble(),
      minimumPayment: (data['minimumPayment'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'interestRate': interestRate,
      'minimumPayment': minimumPayment,
    };
  }
}
