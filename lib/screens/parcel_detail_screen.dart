import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/parcel.dart';
import '../providers/language_provider.dart';
import '../providers/parcel_provider.dart';
import '../providers/weather_provider.dart';
import '../services/app_strings.dart';
import 'parcel_form_screen.dart';

class ParcelDetailScreen extends StatelessWidget {
  final Parcel parcel;

  const ParcelDetailScreen({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    // On lit la parcelle dans le provider pour que les modifications se voient direct
    final provider = context.watch<ParcelProvider>();
    final weatherProvider = context.watch<WeatherProvider>();
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);
    final currentParcel = provider.getParcelById(parcel.id) ?? parcel;

    const darkGreen = Color(0xFF276738);
    final needsIrrigation = currentParcel.needsIrrigation;

    // Conseil d'irrigation selon la météo (uniquement si la parcelle a soif)
    String advice = '';
    Color adviceColor = Colors.orange;
    if (needsIrrigation && weatherProvider.hasData) {
      if (weatherProvider.weather!.significantRain) {
        advice = s.tr('advice_wait_rain');
        adviceColor = Colors.blue;
      } else {
        advice = s.tr('advice_irrigate_now');
        adviceColor = Colors.orange;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F1),
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        title: Text(currentParcel.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- En-tête (nom, culture, avatar) ---
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF3E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.agriculture, color: darkGreen, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentParcel.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentParcel.crop,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- Pourcentage d'humidité ---
            Center(
              child: Text(
                '${currentParcel.humidity.toStringAsFixed(0)} %',
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --- Barre de progression ---
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (currentParcel.humidity / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade300,
                color: needsIrrigation ? Colors.red : darkGreen,
                minHeight: 10,
              ),
            ),

            const SizedBox(height: 10),

            // --- "Sol correct" / "Besoin d'irrigation" ---
            Center(
              child: Text(
                needsIrrigation
                    ? s.tr('detail_needs_irrigation')
                    : s.tr('detail_soil_ok'),
                style: TextStyle(
                  color: needsIrrigation ? Colors.red : darkGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            // --- Conseil lié à la météo ---
            if (advice.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    advice,
                    style: TextStyle(
                      color: adviceColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // --- Tableau des détails (humidité, seuil, vanne) ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildRow(
                    s.tr('detail_current_humidity'),
                    '${currentParcel.humidity.toStringAsFixed(0)} %',
                  ),
                  const Divider(height: 1),
                  _buildRow(
                    s.tr('detail_threshold'),
                    '${currentParcel.threshold.toStringAsFixed(0)} %',
                  ),
                  const Divider(height: 1),
                  // Vanne ouverte automatiquement quand l'humidité < seuil
                  _buildRow(
                    s.tr('detail_valve'),
                    needsIrrigation
                        ? s.tr('detail_valve_open')
                        : s.tr('detail_valve_closed'),
                    valueColor: needsIrrigation ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- Bouton modifier ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Le paramètre s'appelle "parcel" (pas "parcelToEdit")
                      builder: (_) => ParcelFormScreen(parcel: currentParcel),
                    ),
                  );
                },
                child: Text(
                  s.tr('detail_edit_parcel'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
