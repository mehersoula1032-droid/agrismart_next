import 'package:flutter/foundation.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

// Les trois états d'un chargement réseau
enum WeatherStatus { loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service;

  WeatherProvider({WeatherService? service})
      : _service = service ?? WeatherService();

  WeatherStatus _status = WeatherStatus.loading;
  Weather? _weather;
  String _errorKey = 'weather_err_unknown';
  DateTime? _lastUpdate;

  WeatherStatus get status => _status;
  Weather? get weather => _weather;
  String get errorKey => _errorKey;
  DateTime? get lastUpdate => _lastUpdate;

  bool get hasData => _status == WeatherStatus.success && _weather != null;

  Future<void> load() async {
    _status = WeatherStatus.loading;
    notifyListeners();

    try {
      _weather = await _service.load();
      _lastUpdate = DateTime.now();
      _status = WeatherStatus.success;
    } on WeatherException catch (e) {
      _errorKey = e.messageKey;
      _status = WeatherStatus.error;
    } catch (_) {
      _errorKey = 'weather_err_unknown';
      _status = WeatherStatus.error;
    }
    notifyListeners();
  }
}
