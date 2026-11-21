import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/parcel_provider.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _scanResult = '';
  bool _isScanning = true;
  String _selectedParcelId = 'P001';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulateScan(BuildContext context) {
    setState(() {
      _isScanning = true;
    });

    final provider = context.read<ParcelProvider>();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      final parcels = provider.parcels;
      if (parcels.isNotEmpty) {
        final randomParcel = parcels[Random().nextInt(parcels.length)];
        setState(() {
          _scanResult =
              'Capteur #${randomParcel.id}\nZone: ${randomParcel.name}\nHumidité mesurée: ${randomParcel.humidity.toStringAsFixed(1)}%';
          _isScanning = false;
        });

        if (mounted && context.mounted) {
          _showScanDialog(context, randomParcel.name, randomParcel.humidity);
        }
      } else {
        setState(() {
          _scanResult = 'Aucun capteur détecté';
          _isScanning = false;
        });
      }
    });
  }

  void _showScanDialog(
      BuildContext context, String name, double humidity) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.qr_code_2, color: Color(0xFF276738)),
            SizedBox(width: 10),
            Text('Capteur Détecté'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parcelle : $name',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Humidité transmise : ${humidity.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF276738),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Données du capteur synchronisées !'),
                  ),
                );
              }
            },
            child: const Text('Synchroniser'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF276738);
    final provider = context.watch<ParcelProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F1),
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        title: const Text(
          'Scanner & Générateur QR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.qr_code_scanner), text: 'Scanner'),
            Tab(icon: Icon(Icons.qr_code), text: 'Mon QR Code'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // SCANNER TAB
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Placez le QR code du capteur au centre du cadre',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 30),

                // Scanner Viewport
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: darkGreen, width: 3),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_2,
                        size: 130,
                        color: Colors.white24,
                      ),
                      if (_isScanning)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) {
                            return Positioned(
                              top: value * 200 + 25,
                              left: 30,
                              right: 30,
                              child: Container(
                                height: 3,
                                color: Colors.greenAccent,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: () => _simulateScan(context),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Scanner le Capteur'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                if (_scanResult.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _scanResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // GENERATOR TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Générer un QR Code pour vos parcelles',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                if (provider.parcels.isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    initialValue: provider.parcels.any((p) => p.id == _selectedParcelId)
                        ? _selectedParcelId
                        : provider.parcels.first.id,
                    decoration: InputDecoration(
                      labelText: 'Sélectionner une parcelle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: provider.parcels.map((parcel) {
                      return DropdownMenuItem(
                        value: parcel.id,
                        child: Text('${parcel.name} (${parcel.crop})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedParcelId = val;
                        });
                      }
                    },
                  ),
                ],

                const SizedBox(height: 30),

                // Rendered QR Code
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CustomPaint(
                          painter: QrPainter(data: 'AGRISMART_PARCEL_$_selectedParcelId'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ID: AGRISMART_PARCEL_$_selectedParcelId',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('QR Code prêt à être imprimé ou partagé'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Partager le QR Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for lightweight QR representation
class QrPainter extends CustomPainter {
  final String data;

  QrPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double cellWidth = size.width / 15;
    final double cellHeight = size.height / 15;

    final int hash = data.hashCode;

    for (int r = 0; r < 15; r++) {
      for (int c = 0; c < 15; c++) {
        // Corner markers
        if ((r < 4 && c < 4) ||
            (r < 4 && c >= 11) ||
            (r >= 11 && c < 4)) {
          if (r == 0 || r == 3 || c == 0 || c == 3 ||
              r == 14 || c == 14 || (r >= 11 && (r == 11 || c == 0 || c == 3))) {
            canvas.drawRect(
              Rect.fromLTWH(c * cellWidth, r * cellHeight, cellWidth, cellHeight),
              paint,
            );
          }
        } else {
          final isBitSet = ((r * 15 + c + hash) % 3) == 0;
          if (isBitSet) {
            canvas.drawRect(
              Rect.fromLTWH(c * cellWidth, r * cellHeight, cellWidth, cellHeight),
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant QrPainter oldDelegate) => oldDelegate.data != data;
}
