import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../services/app_strings.dart';

class PlantRecognitionScreen extends StatefulWidget {
  const PlantRecognitionScreen({super.key});

  @override
  State<PlantRecognitionScreen> createState() => _PlantRecognitionScreenState();
}

class _PlantRecognitionScreenState extends State<PlantRecognitionScreen> {
  final ImagePicker _picker = ImagePicker();

  File? selectedImage;
  List<ImageLabel> labels = [];

  bool isLoading = false;
  String? errorMessage;

  final ImageLabeler _imageLabeler = ImageLabeler(
    options: ImageLabelerOptions(
      confidenceThreshold: 0.5,
    ),
  );

  // Camera and Gallery
  Future<void> selectImage(ImageSource source) async {
    final s = AppStrings.of(context);
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        selectedImage = File(image.path);
        labels = [];
        errorMessage = null;
        isLoading = true;
      });

      final inputImage = InputImage.fromFilePath(image.path);
      final results = await _imageLabeler.processImage(inputImage);

      if (!mounted) return;

      setState(() {
        labels = results;
        isLoading = false;

        if (results.isEmpty) {
          errorMessage = s.tr('no_result_found');
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = s.tr('image_analysis_error');
      });
    }
  }

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.tr('plant_recognition_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              s.tr('analyze_plant_heading'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF276738),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.tr('analyze_plant_subtitle'),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Image Preview
            Container(
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2E8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: selectedImage == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.eco,
                    size: 65,
                    color: Color(0xFF276738),
                  ),
                  const SizedBox(height: 12),
                  Text(s.tr('no_image_selected')),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  selectedImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Camera and Gallery Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                    isLoading ? null : () => selectImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: Text(s.tr('camera')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF276738),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => selectImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: Text(s.tr('gallery')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDDEBDD),
                      foregroundColor: const Color(0xFF276738),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Loading
            if (isLoading)
              Column(
                children: [
                  const CircularProgressIndicator(
                    color: Color(0xFF276738),
                  ),
                  const SizedBox(height: 12),
                  Text(s.tr('analyzing_image')),
                ],
              ),

            // Error
            if (errorMessage != null)
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),

            // Results
            if (labels.isNotEmpty) ...[
              Text(
                s.tr('analysis_results'),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF276738),
                ),
              ),
              const SizedBox(height: 12),
              ...labels.map(
                    (label) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.eco,
                      color: Color(0xFF276738),
                    ),
                    title: Text(
                      label.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${s.tr('confidence_label')} : '
                          '${(label.confidence * 100).toStringAsFixed(1)}%',
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 15),

            Text(
              s.tr('plant_disclaimer_note'),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}