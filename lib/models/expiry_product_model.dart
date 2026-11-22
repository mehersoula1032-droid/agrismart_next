import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

enum ExpiryStatus {
  valid,
  expiringSoon,
  expired,
}

class ExpiryProductModel {
  final String id;
  final String name;
  final String category; // مثال: Engrais, Semences, Produit phyto...
  final DateTime expiryDate;
  final DateTime createdAt;

  ExpiryProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.expiryDate,
    required this.createdAt,
  });

  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return target.difference(today).inDays;
  }

  ExpiryStatus get status {
    if (daysRemaining < 0) return ExpiryStatus.expired;
    if (daysRemaining <= 7) return ExpiryStatus.expiringSoon;
    return ExpiryStatus.valid;
  }

  String get formattedDate => DateFormat('dd/MM/yyyy').format(expiryDate);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ExpiryProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final expiryTs = data['expiryDate'] as Timestamp?;
    final createdTs = data['createdAt'] as Timestamp?;

    return ExpiryProductModel(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      category: (data['category'] ?? 'Général').toString(),
      expiryDate: expiryTs?.toDate() ?? DateTime.now(),
      createdAt: createdTs?.toDate() ?? DateTime.now(),
    );
  }
}