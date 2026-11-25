import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/parcel_provider.dart';
import '../services/app_strings.dart';
import '../widgets/parcel_card.dart';
import 'parcel_form_screen.dart';

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParcelProvider>();
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);
    const darkGreen = Color(0xFF276738);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  Text(
                    s.tr('app_name'),
                    style: const TextStyle(
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
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${s.tr('avg_humidity_label')} : ${provider.averageHumidity.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top Summary Metrics bar
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MetricItem(
                    value: '${provider.irrigationCount}',
                    label: s.tr('to_irrigate'),
                    color: const Color(0xFFE16A45),
                  ),
                  _MetricItem(
                    value: '${provider.healthyCount}',
                    label: s.tr('soil_ok'),
                    color: const Color(0xFF39834D),
                  ),
                  _MetricItem(
                    value: '${provider.minimumHumidity.toStringAsFixed(0)}%',
                    label: s.tr('min_humidity'),
                    color: const Color(0xFF3485CC),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),

            // Main List of Zones / Parcels
            Expanded(
              child: provider.parcels.isEmpty
                  ? _emptyState(context, s)
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

  Widget _emptyState(BuildContext context, AppStrings s) {
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
            Text(
              s.tr('no_parcels_registered'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              s.tr('add_parcel_hint'),
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