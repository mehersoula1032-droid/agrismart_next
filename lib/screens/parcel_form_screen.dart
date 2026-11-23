import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/parcel.dart';
import '../providers/language_provider.dart';
import '../providers/parcel_provider.dart';
import '../services/app_strings.dart';

class ParcelFormScreen extends StatefulWidget {
  final Parcel? parcel;

  const ParcelFormScreen({super.key, this.parcel});

  @override
  State<ParcelFormScreen> createState() => _ParcelFormScreenState();
}

class _ParcelFormScreenState extends State<ParcelFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _cropController;
  late TextEditingController _areaController;
  late TextEditingController _humidityController;
  late TextEditingController _thresholdController;
  late TextEditingController _locationController;
  late TextEditingController _latController;
  late TextEditingController _lngController;

  bool get isEditing => widget.parcel != null;

  @override
  void initState() {
    super.initState();

    final parcel = widget.parcel;

    _nameController = TextEditingController(text: parcel?.name ?? '');
    _cropController = TextEditingController(text: parcel?.crop ?? '');
    _areaController = TextEditingController(
      text: parcel?.area.toString() ?? '',
    );
    _humidityController = TextEditingController(
      text: parcel?.humidity.toString() ?? '',
    );
    _thresholdController = TextEditingController(
      text: parcel?.threshold.toString() ?? '30',
    );
    _locationController = TextEditingController(
      text: parcel?.location ?? '',
    );
    _latController = TextEditingController(
      text: parcel?.latitude != null ? parcel!.latitude.toString() : '',
    );
    _lngController = TextEditingController(
      text: parcel?.longitude != null ? parcel!.longitude.toString() : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cropController.dispose();
    _areaController.dispose();
    _humidityController.dispose();
    _thresholdController.dispose();
    _locationController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  String? _validateText(String? value, AppStrings s) {
    if (value == null || value.trim().isEmpty) {
      return s.tr('required_field');
    }
    return null;
  }

  String? _validateNumber(String? value, AppStrings s) {
    if (value == null || value.trim().isEmpty) {
      return s.tr('required_field');
    }

    final number = double.tryParse(value.replaceAll(',', '.'));

    if (number == null || number < 0) {
      return s.tr('invalid_number');
    }

    return null;
  }

  String? _validateCoordinate(String? value, AppStrings s) {
    if (value == null || value.trim().isEmpty) {
      return null; // optionnel
    }

    final number = double.tryParse(value.replaceAll(',', '.'));
    if (number == null) {
      return s.tr('invalid_coordinate');
    }

    return null;
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    String? suffix,
    bool isNumeric = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: isNumeric
          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixText: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF2E7D32),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  void _setDefaultGpsCoordinates() {
    setState(() {
      _latController.text = '33.7050';
      _lngController.text = '8.9650';
    });
  }

  void _saveParcel(AppStrings s) {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ParcelProvider>();

    final latText = _latController.text.replaceAll(',', '.').trim();
    final lngText = _lngController.text.replaceAll(',', '.').trim();

    final latitude = latText.isNotEmpty ? double.tryParse(latText) : null;
    final longitude = lngText.isNotEmpty ? double.tryParse(lngText) : null;

    final parcel = Parcel(
      id: widget.parcel?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      crop: _cropController.text.trim(),
      area: double.parse(_areaController.text.replaceAll(',', '.')),
      humidity: double.parse(_humidityController.text.replaceAll(',', '.')),
      threshold: double.parse(_thresholdController.text.replaceAll(',', '.')),
      location: _locationController.text.trim(),
      latitude: latitude,
      longitude: longitude,
    );

    if (isEditing) {
      provider.updateParcel(parcel);
    } else {
      provider.addParcel(parcel);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? s.tr('parcel_updated_success')
              : s.tr('parcel_added_success'),
        ),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);
    const green = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? s.tr('edit_parcel_title') : s.tr('new_parcel_title'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B4332),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.agriculture,
                      color: Colors.white,
                      size: 36,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.tr('parcel_management_heading'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s.tr('parcel_form_subtitle'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                s.tr('general_info'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildField(
                label: s.tr('parcel_name_label'),
                controller: _nameController,
                icon: Icons.landscape,
                hint: s.tr('parcel_name_hint'),
                validator: (v) => _validateText(v, s),
              ),
              const SizedBox(height: 16),
              _buildField(
                label: s.tr('crop_type_label'),
                controller: _cropController,
                icon: Icons.eco,
                hint: s.tr('crop_type_hint'),
                validator: (v) => _validateText(v, s),
              ),
              const SizedBox(height: 16),
              _buildField(
                label: s.tr('area_label'),
                controller: _areaController,
                icon: Icons.square_foot,
                suffix: 'ha',
                isNumeric: true,
                validator: (v) => _validateNumber(v, s),
              ),
              const SizedBox(height: 16),
              _buildField(
                label: s.tr('location_label'),
                controller: _locationController,
                icon: Icons.location_on_outlined,
                hint: s.tr('location_hint'),
                validator: (v) => _validateText(v, s),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    s.tr('gps_position_heading'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _setDefaultGpsCoordinates,
                    icon: const Icon(Icons.my_location, size: 18, color: green),
                    label: Text(
                      s.tr('ex_kebili'),
                      style: const TextStyle(color: green, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      label: s.tr('latitude_label'),
                      controller: _latController,
                      icon: Icons.map,
                      hint: 'Ex: 33.7050',
                      isNumeric: true,
                      validator: (v) => _validateCoordinate(v, s),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(
                      label: s.tr('longitude_label'),
                      controller: _lngController,
                      icon: Icons.map_outlined,
                      hint: 'Ex: 8.9650',
                      isNumeric: true,
                      validator: (v) => _validateCoordinate(v, s),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                s.tr('irrigation_data_heading'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildField(
                label: s.tr('current_humidity_label'),
                controller: _humidityController,
                icon: Icons.water_drop,
                suffix: '%',
                isNumeric: true,
                validator: (v) => _validateNumber(v, s),
              ),
              const SizedBox(height: 16),
              _buildField(
                label: s.tr('irrigation_threshold_label'),
                controller: _thresholdController,
                icon: Icons.tune,
                suffix: '%',
                isNumeric: true,
                validator: (v) => _validateNumber(v, s),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _saveParcel(s),
                  icon: Icon(
                    isEditing ? Icons.save : Icons.add,
                  ),
                  label: Text(
                    isEditing
                        ? s.tr('save_changes_btn')
                        : s.tr('add_parcel_btn'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}