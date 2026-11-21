import '../models/parcel.dart';

class MockDataService {
  MockDataService._(); // prevent instantiation

  static const List<Parcel> parcels = [
    Parcel(
      id: 'P001',
      name: 'Parcelle Nord',
      crop: 'Tomate',
      area: 2.5,
      humidity: 68.0,
      threshold: 45.0,
      location: 'Kébili • Secteur A',
    ),
    Parcel(
      id: 'P002',
      name: 'Parcelle Sud',
      crop: 'Olivier',
      area: 4.0,
      humidity: 32.0,
      threshold: 40.0,
      location: 'Kébili • Secteur B',
    ),
    Parcel(
      id: 'P003',
      name: 'Parcelle Est',
      crop: 'Blé',
      area: 3.2,
      humidity: 55.0,
      threshold: 50.0,
      location: 'Kébili • Secteur C',
    ),
    Parcel(
      id: 'P004',
      name: 'Parcelle Ouest',
      crop: 'Piment',
      area: 1.8,
      humidity: 28.0,
      threshold: 45.0,
      location: 'Kébili • Secteur D',
    ),
    Parcel(
      id: 'P005',
      name: 'Parcelle Centrale',
      crop: 'Menthe',
      area: 1.2,
      humidity: 72.0,
      threshold: 55.0,
      location: 'Kébili • Secteur E',
    ),
  ];
}