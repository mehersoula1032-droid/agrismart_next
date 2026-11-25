import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather.dart';

// L'exception porte une CLÉ de traduction (voir app_strings.dart),
// l'écran s'occupe d'afficher le message dans la langue choisie.
class WeatherException implements Exception {
  final String messageKey;
  const WeatherException(this.messageKey);
}

class WeatherService {
  // Kébili
  static const String latitude = '33.70';
  static const String longitude = '8.97';

  Future<Weather> load() async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude,
      'longitude': longitude,
      'current': 'temperature_2m,relative_humidity_2m,wind_speed_10m',
      'daily': 'temperature_2m_max,temperature_2m_min,precipitation_sum',
      'timezone': 'auto',
      'forecast_days': '3',
    });

    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const WeatherException('weather_err_timeout');
    } catch (_) {
      throw const WeatherException('weather_err_network');
    }

    if (response.statusCode != 200) {
      throw const WeatherException('weather_err_server');
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Weather.fromJson(json);
    } catch (_) {
      throw const WeatherException('weather_err_parse');
    }
  }
}
