import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/parcel.dart';
import '../providers/language_provider.dart';
import '../providers/parcel_provider.dart';
import '../services/app_strings.dart';
import 'parcel_form_screen.dart';

class GPSFarmMappingScreen extends StatefulWidget {
  const GPSFarmMappingScreen({super.key});

  static const Color green = Color(0xFF276738);

  @override
  State<GPSFarmMappingScreen> createState() => _GPSFarmMappingScreenState();
}

class _GPSFarmMappingScreenState extends State<GPSFarmMappingScreen> {
  late final MapController _mapController;
  Parcel? _selectedParcel;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _moveToParcel(Parcel parcel) {
    if (parcel.latitude != null && parcel.longitude != null) {
      setState(() {
        _selectedParcel = parcel;
      });
      _mapController.move(
        LatLng(parcel.latitude!, parcel.longitude!),
        15.0,
      );
    }
  }

  void _showParcelDetails(BuildContext context, Parcel parcel) {
    setState(() {
      _selectedParcel = parcel;
    });

    final s = AppStrings.of(context);
    final isNeedIrrigation = parcel.needsIrrigation;
    final statusColor = isNeedIrrigation
        ? const Color(0xFFE16A45)
        : const Color(0xFF276738);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: statusColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parcel.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${parcel.crop} • ${parcel.area} ha',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isNeedIrrigation
                          ? s.tr('to_irrigate')
                          : s.tr('soil_ok_short'),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _DetailStat(
                      label: s.tr('humidity_short'),
                      value: '${parcel.humidity.toStringAsFixed(1)}%',
                      icon: Icons.water_drop,
                      color: const Color(0xFF3485CC),
                    ),
                    _DetailStat(
                      label: s.tr('threshold_short'),
                      value: '${parcel.threshold.toStringAsFixed(1)}%',
                      icon: Icons.tune,
                      color: Colors.grey.shade700,
                    ),
                    _DetailStat(
                      label: s.tr('gps_short'),
                      value:
                      '${parcel.latitude?.toStringAsFixed(3)}, ${parcel.longitude?.toStringAsFixed(3)}',
                      icon: Icons.map,
                      color: GPSFarmMappingScreen.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(bottomSheetContext);
                        _moveToParcel(parcel);
                      },
                      icon: const Icon(Icons.center_focus_strong),
                      label: Text(s.tr('center_action')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: GPSFarmMappingScreen.green,
                        side: const BorderSide(
                          color: GPSFarmMappingScreen.green,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(bottomSheetContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ParcelFormScreen(parcel: parcel),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(s.tr('edit_action')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GPSFarmMappingScreen.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParcelProvider>();
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);
    final parcelsWithGps = provider.parcels
        .where((p) => p.latitude != null && p.longitude != null)
        .toList();

    final LatLng initialCenter = parcelsWithGps.isNotEmpty
        ? LatLng(parcelsWithGps.first.latitude!, parcelsWithGps.first.longitude!)
        : const LatLng(33.7050, 8.9650);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.tr('gps_map_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: GPSFarmMappingScreen.green,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt),
            tooltip: s.tr('add_parcel_gps_tooltip'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ParcelFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 13.5,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.agrismart_next',
              ),
              MarkerLayer(
                markers: parcelsWithGps.map((parcel) {
                  final isNeedIrrigation = parcel.needsIrrigation;
                  final isSelected = _selectedParcel?.id == parcel.id;
                  final markerColor = isNeedIrrigation
                      ? const Color(0xFFE16A45)
                      : const Color(0xFF276738);

                  return Marker(
                    point: LatLng(parcel.latitude!, parcel.longitude!),
                    width: 100,
                    height: 70,
                    child: GestureDetector(
                      onTap: () => _showParcelDetails(context, parcel),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? Colors.black : markerColor,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              parcel.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: markerColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: markerColor,
                            size: isSelected ? 36 : 28,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    '© OpenStreetMap contributors',
                  ),
                ],
              ),
            ],
          ),

          // Horizontal selector bar for parcels at the bottom
          Positioned(
            left: 12,
            right: 12,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (parcelsWithGps.isNotEmpty)
                  SizedBox(
                    height: 54,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: parcelsWithGps.length,
                      itemBuilder: (context, index) {
                        final parcel = parcelsWithGps[index];
                        final isSelected = _selectedParcel?.id == parcel.id;
                        final color = parcel.needsIrrigation
                            ? const Color(0xFFE16A45)
                            : const Color(0xFF276738);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            avatar: Icon(
                              Icons.location_on,
                              color: isSelected ? Colors.white : color,
                              size: 18,
                            ),
                            label: Text(
                              '${parcel.name} (${parcel.crop})',
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: GPSFarmMappingScreen.green,
                            backgroundColor: Colors.white,
                            elevation: 3,
                            onSelected: (_) => _moveToParcel(parcel),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: GPSFarmMappingScreen.green,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              s.tr('no_geolocated_parcels'),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DetailStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 13,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}