// Prévision pour un jour
class DayForecast {
  final DateTime date;
  final double tMax;
  final double tMin;
  final double rain; // millimètres

  const DayForecast({
    required this.date,
    required this.tMax,
    required this.tMin,
    required this.rain,
  });
}

// Météo actuelle + prévisions des prochains jours
class Weather {
  final double temperature; // °C
  final int airHumidity; // %
  final double wind; // km/h
  final List<DayForecast> forecasts;

  const Weather({
    required this.temperature,
    required this.airHumidity,
    required this.wind,
    required this.forecasts,
  });

  // Total de pluie prévue sur la période (mm)
  double get totalRain => forecasts.fold(0.0, (sum, f) => sum + f.rain);

  // Seuil à partir duquel on conseille de repousser l'irrigation
  bool get significantRain => totalRain >= 5;

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    final dates = daily['time'] as List<dynamic>;
    final tMax = daily['temperature_2m_max'] as List<dynamic>;
    final tMin = daily['temperature_2m_min'] as List<dynamic>;
    final rain = daily['precipitation_sum'] as List<dynamic>;

    final forecasts = <DayForecast>[];
    for (var i = 0; i < dates.length; i++) {
      forecasts.add(DayForecast(
        date: DateTime.parse(dates[i] as String),
        tMax: (tMax[i] as num).toDouble(),
        tMin: (tMin[i] as num).toDouble(),
        rain: ((rain[i] ?? 0) as num).toDouble(),
      ));
    }

    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      airHumidity: (current['relative_humidity_2m'] as num).round(),
      wind: (current['wind_speed_10m'] as num).toDouble(),
      forecasts: forecasts,
    );
  }
}
