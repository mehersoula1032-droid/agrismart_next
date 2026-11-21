import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/parcel_provider.dart';
import '../widgets/parcel_card.dart';
import 'parcel_form_screen.dart';

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParcelProvider>();
    const darkGreen = Color(0xFF276738);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ParcelFormScreen(),
            ),
          );
        },
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Green Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: darkGreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AgriSmart',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Humidité moyenne : ${provider.averageHumidity.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top Summary Metrics bar (2 À irriguer | 2 Sol correct | 20% Humidité min)
            Container(
              color: const Color(0xFFF5F7F1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MetricItem(
                    value: '${provider.irrigationCount}',
                    label: 'À irriguer',
                    color: const Color(0xFFE16A45),
                  ),
                  _MetricItem(
                    value: '${provider.healthyCount}',
                    label: 'Sol correct',
                    color: const Color(0xFF39834D),
                  ),
                  _MetricItem(
                    value:
                        '${provider.minimumHumidity.toStringAsFixed(0)}%',
                    label: 'Humidité min',
                    color: const Color(0xFF3485CC),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),

            // Main List of Zones / Parcels
            Expanded(
              child: provider.parcels.isEmpty
                  ? _emptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.parcels.length,
                      itemBuilder: (context, index) {
                        final parcel = provider.parcels[index];
                        return ParcelCard(parcel: parcel);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.landscape_outlined,
              size: 65,
              color: Color(0xFF276738),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune parcelle enregistrée',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Appuyez sur le bouton + pour ajouter une nouvelle zone.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _MetricItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
