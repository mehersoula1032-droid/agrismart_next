import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/parcel.dart';
import '../providers/auth_provider.dart';
import '../services/mock_data_service.dart';

class ParcelProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final AuthProvider _auth;
  final List<Parcel> _parcels = [];
  String? _uid; // utilisateur dont on affiche les parcelles

  ParcelProvider(this._prefs, this._auth) {
    _auth.addListener(_surChangementUtilisateur);
    _actualiser(); // charge les parcelles de l'utilisateur déjà connecté
  }

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
    return _parcels.fold<double>(0, (sum, parcel) => sum + parcel.area);
  }

  Parcel? getParcelById(String id) {
    try {
      return _parcels.firstWhere((parcel) => parcel.id == id);
    } catch (_) {
      return null;
    }
  }

  // --------- Stockage (TP8) ---------

  String _cle(String uid) => 'parcels_$uid';

  // Lit les parcelles d'un utilisateur (jeu de données au tout premier lancement)
  List<Parcel> _lire(String uid) {
    final texte = _prefs.getString(_cle(uid));
    if (texte == null) return List.of(MockDataService.parcels);
    try {
      final liste = jsonDecode(texte) as List<dynamic>;
      return liste
          .map((e) => Parcel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Données abîmées : on repart du jeu initial
      return List.of(MockDataService.parcels);
    }
  }

  Future<void> _sauvegarder() async {
    final uid = _uid;
    if (uid == null) return;
    final texte = jsonEncode(_parcels.map((p) => p.toJson()).toList());
    await _prefs.setString(_cle(uid), texte);
  }

  // Change d'utilisateur : renvoie true si la liste a changé
  bool _actualiser() {
    final uid = _auth.uid;
    if (uid == _uid) return false;
    _uid = uid;
    _parcels.clear();
    if (uid != null) _parcels.addAll(_lire(uid));
    return true;
  }

  void _surChangementUtilisateur() {
    if (_actualiser()) notifyListeners();
  }

  @override
  void dispose() {
    _auth.removeListener(_surChangementUtilisateur);
    super.dispose();
  }

  // --------- Actions ---------

  void updateHumidity(String id, double humidity) {
    final index = _parcels.indexWhere((parcel) => parcel.id == id);
    if (index == -1) return;

    _parcels[index] = _parcels[index].copyWith(
      humidity: humidity.clamp(0.0, 100.0),
    );
    _sauvegarder();
    notifyListeners();
  }

  void increaseHumidity(String id, [double step = 5.0]) {
    final index = _parcels.indexWhere((parcel) => parcel.id == id);
    if (index == -1) return;

    final newHumidity = (_parcels[index].humidity + step).clamp(0.0, 100.0);
    _parcels[index] = _parcels[index].copyWith(humidity: newHumidity);
    _sauvegarder();
    notifyListeners();
  }

  void decreaseHumidity(String id, [double step = 5.0]) {
    final index = _parcels.indexWhere((parcel) => parcel.id == id);
    if (index == -1) return;

    final newHumidity = (_parcels[index].humidity - step).clamp(0.0, 100.0);
    _parcels[index] = _parcels[index].copyWith(humidity: newHumidity);
    _sauvegarder();
    notifyListeners();
  }

  void addParcel(Parcel parcel) {
    final exists = _parcels.any((p) => p.id == parcel.id);
    if (exists) return;

    _parcels.add(parcel);
    _sauvegarder();
    notifyListeners();
  }

  void updateParcel(Parcel updatedParcel) {
    final index = _parcels.indexWhere(
          (parcel) => parcel.id == updatedParcel.id,
    );
    if (index == -1) return;

    _parcels[index] = updatedParcel;
    _sauvegarder();
    notifyListeners();
  }

  void deleteParcel(String id) {
    final exists = _parcels.any((parcel) => parcel.id == id);
    if (!exists) return;

    _parcels.removeWhere((parcel) => parcel.id == id);
    _sauvegarder();
    notifyListeners();
  }
}