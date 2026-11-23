import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/parcel_provider.dart';
import '../services/app_strings.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParcelProvider>();
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);
    const greenColor = Color(0xFF99CB92);

    final needsIrrigationCount = provider.irrigationCount;
    final totalParcels = provider.totalParcels;
    final percentage = totalParcels > 0
        ? ((needsIrrigationCount / totalParcels) * 100).toStringAsFixed(0)
        : '0';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Light Green Header with Title
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                color: greenColor,
                child: Text(
                  s.tr('nav_stats'),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Météo Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.tr('weather_kebili'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '30 °C',
                                    style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${s.tr('air_humidity_label')} : 23 %',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${s.tr('wind_label')} : 19 km/h',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 3-day Weather Rows
                          _weatherForecastRow(
                              s.tr('day_thu'), '15° / 30°', '0.0 mm'),
                          _weatherForecastRow(
                              s.tr('day_fri'), '17° / 26°', '0.0 mm'),
                          _weatherForecastRow(
                              s.tr('day_sat'), '15° / 25°', '0.0 mm'),

                          const SizedBox(height: 14),

                          // Weather Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                s.tr('no_significant_rain'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                s.tr('updated_at_1435'),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Metric summary card
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatMetric(
                            value: '$needsIrrigationCount',
                            label: s.tr('to_irrigate'),
                            color: const Color(0xFFE16A45),
                          ),
                          _StatMetric(
                            value: '${provider.healthyCount}',
                            label: s.tr('soil_ok'),
                            color: const Color(0xFF39834D),
                          ),
                          _StatMetric(
                            value:
                            '${provider.minimumHumidity.toStringAsFixed(0)}%',
                            label: s.tr('min_humidity'),
                            color: const Color(0xFF3485CC),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Subtitle status
                    Text(
                      '$needsIrrigationCount ${s.tr('zones_to_irrigate_summary')} $totalParcels ${s.tr('to_irrigate_parenthesis')} ($percentage%)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      s.tr('humidity_by_zone'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Zones humidity list
                    ...provider.parcels.map((parcel) {
                      final bool isLow = parcel.needsIrrigation;
                      final Color barColor = isLow
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF2E7D32);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  parcel.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${parcel.humidity.toStringAsFixed(0)} %',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: (parcel.humidity / 100).clamp(0.0, 1.0),
                                minHeight: 7,
                                backgroundColor: const Color(0xFFE7EDE4),
                                color: barColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weatherForecastRow(String day, String temps, String rain) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 55,
            child: Text(
              day,
              style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
            ),
          ),
          Text(
            temps,
            style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
          ),
          Row(
            children: [
              const Icon(
                Icons.water_drop_outlined,
                size: 14,
                color: Colors.black54,
              ),
              const SizedBox(width: 4),
              Text(
                rain,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatMetric extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatMetric({
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