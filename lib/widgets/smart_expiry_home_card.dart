import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/expiry_product_model.dart';
import '../screens/expiry_management_screen.dart';

class SmartExpiryHomeCard extends StatelessWidget {
  const SmartExpiryHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        final uid = authSnapshot.data?.uid ??
            FirebaseAuth.instance.currentUser?.uid ??
            'default_user';

        final stream = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('expiry_products')
            .snapshots();

        return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Erreur: ${snapshot.error}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            );
          }

          final items = (snapshot.data?.docs ?? [])
              .map((d) => ExpiryProductModel.fromFirestore(d))
              .toList();

          final soonCount = items
              .where((i) => i.status == ExpiryStatus.expiringSoon)
              .length;
          final expiredCount =
              items.where((i) => i.status == ExpiryStatus.expired).length;

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExpiryManagementScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(
                      Icons.event_available,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Smart Expiry Detector',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$soonCount bientôt expirés • $expiredCount expirés',
                          style: TextStyle(
                            fontSize: 12,
                            color: expiredCount > 0
                                ? Colors.red[700]
                                : soonCount > 0
                                ? Colors.orange[800]
                                : Colors.grey[600],
                            fontWeight: (expiredCount > 0 || soonCount > 0)
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          );
        },
        );
      },
    );
  }
}