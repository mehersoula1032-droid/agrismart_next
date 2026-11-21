class Parcel {
  final String id;
  final String name;
  final String crop;
  final double area;
  final double humidity;
  final double threshold;
  final String location;

  const Parcel({
    required this.id,
    required this.name,
    required this.crop,
    required this.area,
    required this.humidity,
    required this.threshold,
    required this.location,
  });

  bool get needsIrrigation => humidity < threshold;

  double get humidityPercent => humidity.clamp(0.0, 100.0);

  double get humidityRatio => (humidity / threshold).clamp(0.0, 1.5);

  Parcel copyWith({
    String? id,
    String? name,
    String? crop,
    double? area,
    double? humidity,
    double? threshold,
    String? location,
  }) {
    return Parcel(
      id: id ?? this.id,
      name: name ?? this.name,
      crop: crop ?? this.crop,
      area: area ?? this.area,
      humidity: humidity ?? this.humidity,
      threshold: threshold ?? this.threshold,
      location: location ?? this.location,
    );
  }
}