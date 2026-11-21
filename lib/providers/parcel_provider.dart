
import 'package:flutter/material.dart';

import '../models/parcel.dart';
import '../services/mock_data_service.dart';

class ParcelProvider extends ChangeNotifier {
  final List<Parcel> _parcels = List.of(MockDataService.parcels);

  List<Parcel> get parcels => List.unmodifiable(_parcels);

  int get totalParcels => _parcels.length;

  int get irrigationCount =>
      _parcels.where((parcel) => parcel.needsIrrigation).length;

  int get healthyCount => totalParcels - irrigationCount;

  double get minimumHumidity {
    if (_parcels.isEmpty) return 0;

    return _parcels
        .map((parcel) => parcel.humidity)
        .reduce((a, b) => a < b ? a : b);
  }

  double get averageHumidity {
    if (_parcels.isEmpty) return 0;

    final total = _parcels.fold<double>(
      0,
          (sum, parcel) => sum + parcel.humidity,
    );

    return total / _parcels.length;
  }

  double get totalArea {
    return _parcels.fold<double>(
      0,
          (sum, parcel) => sum + parcel.area,
    );
  }

  Parcel? getParcelById(String id) {
    try {
      return _parcels.firstWhere((parcel) => parcel.id == id);
    } catch (_) {
      return null;
    }
  }

  void updateHumidity(String id, double humidity) {
    final index = _parcels.indexWhere((parcel) => parcel.id == id);

    if (index == -1) return;

    _parcels[index] = _parcels[index].copyWith(
      humidity: humidity.clamp(0.0, 100.0),
    );

    notifyListeners();
  }

  void increaseHumidity(String id, [double step = 5.0]) {
    final index = _parcels.indexWhere((parcel) => parcel.id == id);
    if (index == -1) return;

    final newHumidity = (_parcels[index].humidity + step).clamp(0.0, 100.0);
    _parcels[index] = _parcels[index].copyWith(humidity: newHumidity);
    notifyListeners();
  }

  void decreaseHumidity(String id, [double step = 5.0]) {
    final index = _parcels.indexWhere((parcel) => parcel.id == id);
    if (index == -1) return;

    final newHumidity = (_parcels[index].humidity - step).clamp(0.0, 100.0);
    _parcels[index] = _parcels[index].copyWith(humidity: newHumidity);
    notifyListeners();
  }

  void addParcel(Parcel parcel) {
    final exists = _parcels.any((p) => p.id == parcel.id);

    if (exists) return;

    _parcels.add(parcel);
    notifyListeners();
  }

  void updateParcel(Parcel updatedParcel) {
    final index = _parcels.indexWhere(
          (parcel) => parcel.id == updatedParcel.id,
    );

    if (index == -1) return;

    _parcels[index] = updatedParcel;
    notifyListeners();
  }

  void deleteParcel(String id) {
    final exists = _parcels.any((parcel) => parcel.id == id);

    if (!exists) return;

    _parcels.removeWhere((parcel) => parcel.id == id);
    notifyListeners();
  }
}
