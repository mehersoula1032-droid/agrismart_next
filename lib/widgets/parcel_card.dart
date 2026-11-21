import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/parcel.dart';
import '../providers/parcel_provider.dart';
import '../screens/parcel_form_screen.dart';

class ParcelCard extends StatelessWidget {
  final Parcel parcel;
  final VoidCallback? onTap;

  const ParcelCard({
    super.key,
    required this.parcel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool needsAttention = parcel.needsIrrigation;

    return InkWell(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ParcelFormScreen(parcel: parcel),
              ),
            );
          },
      onLongPress: () => _confirmDelete(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parcel.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Culture : ${parcel.crop}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Humidité : ${parcel.humidity.toStringAsFixed(1)}% | Seuil : ${parcel.threshold.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: needsAttention
                              ? const Color(0xFFE16A45)
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Plus and Minus buttons to modify humidity quickly
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed: () {
                        context
                            .read<ParcelProvider>()
                            .decreaseHumidity(parcel.id, 5.0);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed: () {
                        context
                            .read<ParcelProvider>()
                            .increaseHumidity(parcel.id, 5.0);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text('Confirmation'),
          ],
        ),
        content: Text(
          'Voulez-vous vraiment supprimer la parcelle "${parcel.name}" ?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.read<ParcelProvider>().deleteParcel(parcel.id);
              Navigator.pop(dialogContext);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Parcelle supprimée avec succès'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
