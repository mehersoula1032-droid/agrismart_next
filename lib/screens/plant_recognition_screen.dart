
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class PlantRecognitionScreen extends StatefulWidget {
  const PlantRecognitionScreen({super.key});

  @override
  State<PlantRecognitionScreen> createState() =>
      _PlantRecognitionScreenState();
}

class _PlantRecognitionScreenState
    extends State<PlantRecognitionScreen> {
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

  Future<void> selectImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
      labels = [];
      errorMessage = null;
      isLoading = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final results = await _imageLabeler.processImage(inputImage);

      if (!mounted) return;

      setState(() {
        labels = results;
        isLoading = false;

        if (results.isEmpty) {
          errorMessage = 'Aucun résultat trouvé.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Erreur lors de l’analyse de l’image.';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant Recognition',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Analysez votre plante',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF276738),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choisissez une image pour identifier les éléments '
                  'présents dans votre plante.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            Container(
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2E8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: selectedImage == null
                  ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.eco,
                    size: 65,
                    color: Color(0xFF276738),
                  ),
                  SizedBox(height: 12),
                  Text('Aucune image sélectionnée'),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: isLoading ? null : selectImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choisir une image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF276738),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),

            const SizedBox(height: 24),

            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF276738),
                ),
              ),

            if (errorMessage != null)
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),

            if (labels.isNotEmpty) ...[
              const Text(
                'Résultats de l’analyse',
                style: TextStyle(
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
                    title: Text(label.label),
                    subtitle: Text(
                      'Confiance : ${(label.confidence * 100).toStringAsFixed(1)}%',
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 15),

            const Text(
              'Remarque : cette analyse identifie des éléments '
                  'généraux dans l’image. Elle ne permet pas de '
                  'diagnostiquer les maladies des plantes.',
              style: TextStyle(
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
