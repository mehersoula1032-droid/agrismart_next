import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/parcel_provider.dart';
import '../widgets/parcel_card.dart';
import '../widgets/smart_expiry_home_card.dart';
import '../widgets/summary_card.dart';
import 'qr_scanner_screen.dart';
import 'voice_assistant_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParcelProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AgriSmart',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF276738),
                    ),
                  ),
                  Text(
                    'Votre exploitation intelligente',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QrScannerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    color: const Color(0xFF276738),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VoiceAssistantScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.mic_none),
                    color: const Color(0xFF276738),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // WELCOME BANNER
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF276738),
                  Color(0xFF5A9A67),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour 👋',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Prenez soin de vos cultures avec AgriSmart.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // WEATHER CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.wb_sunny_rounded,
                  color: Color(0xFFE5A329),
                  size: 45,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Météo à Kébili',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('Soleil • Pas de pluie prévue'),
                    ],
                  ),
                ),
                Text(
                  '30°C',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // SMART EXPIRY DETECTOR CARD
          const SmartExpiryHomeCard(),

          const SizedBox(height: 24),

          // SUMMARY
          const Text(
            'Vue d’ensemble',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Parcelles',
                  value: '${provider.totalParcels}',
                  subtitle: 'Zones suivies',
                  icon: Icons.landscape_outlined,
                  color: const Color(0xFF39834D),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'À irriguer',
                  value: '${provider.irrigationCount}',
                  subtitle: 'Sous le seuil',
                  icon: Icons.water_drop_outlined,
                  color: const Color(0xFFE16A45),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Humidité moy.',
                  value: '${provider.averageHumidity.toStringAsFixed(1)}%',
                  subtitle: 'Toutes les parcelles',
                  icon: Icons.opacity,
                  color: const Color(0xFF3485CC),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Sol correct',
                  value: '${provider.healthyCount}',
                  subtitle: 'Au-dessus du seuil',
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF39834D),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // PARCELLES RECENTES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes parcelles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${provider.totalParcels} zones',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ...provider.parcels.take(3).map(
                (parcel) => ParcelCard(parcel: parcel),
          ),

          const SizedBox(height: 10),

          // QUICK ACTIONS
          const Text(
            'Accès rapide',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.qr_code_scanner,
                  title: 'Scanner QR',
                  color: const Color(0xFF276738),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QrScannerScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickAction(
                  icon: Icons.mic_none,
                  title: 'Assistant IA',
                  color: const Color(0xFF3485CC),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VoiceAssistantScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}