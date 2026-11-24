class Parcel {
  final String id;
  final String name;
  final String crop;
  final double area;
  final double humidity;
  final double threshold;
  final String location;
  final double? latitude;
  final double? longitude;

  const Parcel({
    required this.id,
    required this.name,
    required this.crop,
    required this.area,
    required this.humidity,
    required this.threshold,
    required this.location,
    this.latitude,
    this.longitude,
  });

  bool get needsIrrigation => humidity < threshold;

  double get humidityPercent => humidity.clamp(0.0, 100.0);

  double get humidityRatio => (humidity / threshold).clamp(0.0, 1.5);

  // ============ AJOUT TP8 : Sérialisation JSON ============

  /// Convertit la parcelle en Map JSON (pour l'enregistrer sur l'appareil)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'crop': crop,
      'area': area,
      'humidity': humidity,
      'threshold': threshold,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Reconstruit une parcelle à partir d'un Map JSON
  factory Parcel.fromJson(Map<String, dynamic> json) {
    return Parcel(
      id: json['id'] as String,
      name: json['name'] as String,
      crop: json['crop'] as String,
      area: (json['area'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      threshold: (json['threshold'] as num).toDouble(),
      location: json['location'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  // ========================================================

  Parcel copyWith({
    String? id,
    String? name,
    String? crop,
    double? area,
    double? humidity,
    double? threshold,
    String? location,
    double? latitude,
    double? longitude,
  }) {
    return Parcel(
      id: id ?? this.id,
      name: name ?? this.name,
      crop: crop ?? this.crop,
      area: area ?? this.area,
      humidity: humidity ?? this.humidity,
      threshold: threshold ?? this.threshold,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}