import 'package:flutter/foundation.dart';
import '../models/parcel.dart';
import '../services/parcelle_api_service.dart';

class ParcelProvider extends ChangeNotifier {
  final ParcelleApiService _api = ParcelleApiService();

  final List<Parcel> _parcels = [];
  bool _isLoading = false;
  String? _error;

  ParcelProvider() {
    loadParcels();
  }

  List<Parcel> get parcels => List.unmodifiable(_parcels);

  bool get isLoading => _isLoading;
  String? get error => _error;

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
    return _parcels.fold<double>(0, (sum, parcel) => sum + parcel.area);
  }

  Parcel? getParcelById(String id) {
    try {
      return _parcels.firstWhere((parcel) => parcel.id == id);
    } catch (_) {
      return null;
    }
  }

  // -------- CHARGEMENT --------

  Future<void> loadParcels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.getParcelles();

      _parcels.clear();
      _parcels.addAll(data);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // -------- HUMIDITE --------

  Future<void> updateHumidity(String id, double humidity) async {
    final index = _parcels.indexWhere((parcel) => parcel.id == id);
    if (index == -1) return;

    final updated = _parcels[index].copyWith(
      humidity: humidity.clamp(0.0, 100.0),
    );

    await updateParcel(updated);
  }

  Future<void> increaseHumidity(String id, [double step = 5.0]) async {
    final parcel = getParcelById(id);
    if (parcel == null) return;

    final newHumidity = (parcel.humidity + step).clamp(0.0, 100.0);

    await updateHumidity(id, newHumidity);
  }

  Future<void> decreaseHumidity(String id, [double step = 5.0]) async {
    final parcel = getParcelById(id);
    if (parcel == null) return;

    final newHumidity = (parcel.humidity - step).clamp(0.0, 100.0);

    await updateHumidity(id, newHumidity);
  }

  // -------- AJOUT --------

  Future<void> addParcel(Parcel parcel) async {
    try {
      final created = await _api.addParcelle(parcel);

      _parcels.add(created);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // -------- MODIFICATION --------

  Future<void> updateParcel(Parcel updatedParcel) async {
    final index = _parcels.indexWhere(
          (parcel) => parcel.id == updatedParcel.id,
    );

    try {
      final updated = await _api.updateParcelle(updatedParcel);

      if (index != -1) {
        _parcels[index] = updated;
      }

      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // -------- SUPPRESSION --------

  Future<void> deleteParcel(String id) async {
    final index = _parcels.indexWhere((parcel) => parcel.id == id);
    if (index == -1) return;

    try {
      await _api.deleteParcelle(id);

      _parcels.removeWhere((parcel) => parcel.id == id);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}