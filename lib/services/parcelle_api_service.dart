import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parcel.dart';

class ParcelleApiService {
  // Android Emulator
  static const String baseUrl = 'http://10.190.65.87:8080/api/parcelles';
  // Pour téléphone physique, remplacer 10.0.2.2 par l'IP locale du PC.

  Future<List<Parcel>> getParcelles() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Parcel.fromJson(json)).toList();
    }

    throw Exception('Erreur GET: ${response.statusCode}');
  }

  Future<Parcel> addParcelle(Parcel parcel) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': parcel.name,
        'crop': parcel.crop,
        'area': parcel.area,
        'humidity': parcel.humidity,
        'threshold': parcel.threshold,
        'location': parcel.location,
        'latitude': parcel.latitude,
        'longitude': parcel.longitude,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Parcel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Erreur POST: ${response.statusCode} ${response.body}');
  }

  Future<Parcel> updateParcelle(Parcel parcel) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${parcel.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': parcel.name,
        'crop': parcel.crop,
        'area': parcel.area,
        'humidity': parcel.humidity,
        'threshold': parcel.threshold,
        'location': parcel.location,
        'latitude': parcel.latitude,
        'longitude': parcel.longitude,
      }),
    );

    if (response.statusCode == 200) {
      return Parcel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Erreur PUT: ${response.statusCode} ${response.body}');
  }

  Future<void> deleteParcelle(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erreur DELETE: ${response.statusCode}');
    }
  }
}