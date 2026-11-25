import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather.dart';
import '../providers/language_provider.dart';
import '../providers/weather_provider.dart';
import '../services/app_strings.dart';

String _dayLabel(AppStrings s, DateTime date) {
  const keys = [
    'day_mon',
    'day_tue',
    'day_wed',
    'day_thu',
    'day_fri',
    'day_sat',
    'day_sun',
  ];
  return s.tr(keys[date.weekday - 1]);
}

String weatherAdvice(AppStrings s, Weather w) {
  if (w.significantRain) {
    return '${s.tr('weather_rain_expected')} (${w.totalRain.toStringAsFixed(1)} mm) : ${s.tr('weather_postpone')}';
  }
  return s.tr('no_significant_rain');
}

// ---------------------------------------------------------------------------
// Carte complète (écran Statistiques) : température, humidité, vent,
// prévisions 3 jours, conseil, heure de mise à jour, états chargement/erreur.
// ---------------------------------------------------------------------------
class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);

    Widget content;
    switch (provider.status) {
      case WeatherStatus.loading:
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(s.tr('weather_loading')),
              ],
            ),
          ),
        );
        break;
      case WeatherStatus.error:
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              const Icon(Icons.cloud_off, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text(s.tr(provider.errorKey), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => context.read<WeatherProvider>().load(),
                child: Text(s.tr('weather_retry')),
              ),
            ],
          ),
        );
        break;
      case WeatherStatus.success:
        content = _WeatherContent(
          weather: provider.weather!,
          lastUpdate: provider.lastUpdate,
          s: s,
        );
        break;
    }

    return Container(
      width: double.infinity,
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
      child: content,
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final Weather weather;
  final DateTime? lastUpdate;
  final AppStrings s;

  const _WeatherContent({
    required this.weather,
    required this.lastUpdate,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final time = lastUpdate == null
        ? ''
        : '${s.tr('weather_updated_at')} ${lastUpdate!.hour.toString().padLeft(2, '0')}:${lastUpdate!.minute.toString().padLeft(2, '0')}';

    return Column(
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
                Text(
                  '${weather.temperature.toStringAsFixed(0)} °C',
                  style: const TextStyle(
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
                  '${s.tr('air_humidity_label')} : ${weather.airHumidity} %',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${s.tr('wind_label')} : ${weather.wind.toStringAsFixed(0)} km/h',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final f in weather.forecasts)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 55,
                  child: Text(
                    _dayLabel(s, f.date),
                    style:
                        TextStyle(color: Colors.grey.shade800, fontSize: 13),
                  ),
                ),
                Text(
                  '${f.tMin.toStringAsFixed(0)}° / ${f.tMax.toStringAsFixed(0)}°',
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                ),
                Row(
                  children: [
                    const Icon(Icons.water_drop_outlined,
                        size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      '${f.rain.toStringAsFixed(1)} mm',
                      style:
                          TextStyle(color: Colors.grey.shade800, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                weatherAdvice(s, weather),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Carte compacte (écran d'accueil)
// ---------------------------------------------------------------------------
class WeatherSummaryCard extends StatelessWidget {
  const WeatherSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);

    IconData icon = Icons.wb_sunny_rounded;
    Color iconColor = const Color(0xFFE5A329);
    String subtitle;
    String temp = '--';

    switch (provider.status) {
      case WeatherStatus.loading:
        icon = Icons.cloud_sync_outlined;
        iconColor = Colors.grey;
        subtitle = s.tr('weather_loading');
        break;
      case WeatherStatus.error:
        icon = Icons.cloud_off;
        iconColor = Colors.grey;
        subtitle = s.tr(provider.errorKey);
        break;
      case WeatherStatus.success:
        final w = provider.weather!;
        temp = '${w.temperature.toStringAsFixed(0)}°C';
        if (w.significantRain) {
          icon = Icons.water_drop;
          iconColor = const Color(0xFF3485CC);
        }
        subtitle = weatherAdvice(s, w);
        break;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      // Un tap sur la carte relance le chargement (utile après une erreur)
      onTap: provider.status == WeatherStatus.loading
          ? null
          : () => context.read<WeatherProvider>().load(),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 45),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.tr('weather_kebili'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
            Text(
              temp,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
