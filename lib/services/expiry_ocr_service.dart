import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ExpiryOcrService {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _recognizer =
  TextRecognizer(script: TextRecognitionScript.latin);

  Future<File?> pickImage({bool fromCamera = true}) async {
    final XFile? picked = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  Future<String> extractRawText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await _recognizer.processImage(inputImage);
    return recognizedText.text;
  }

  DateTime? parseExpiryDate(String rawText) {
    if (rawText.trim().isEmpty) return null;

    final List<DateTime> candidates = [];

    // 1. صيغ يوم / شهر / سنة (مثال: 25/12/2026 أو 25-12-2026 أو 25.12.26)
    final fullDateRegex = RegExp(
      r'\b(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{2,4})\b',
    );
    for (final match in fullDateRegex.allMatches(rawText)) {
      final day = int.tryParse(match.group(1)!);
      final month = int.tryParse(match.group(2)!);
      int? year = int.tryParse(match.group(3)!);
      if (day == null || month == null || year == null) continue;
      if (year < 100) year += 2000;

      final dt = _tryBuildDate(year, month, day);
      if (dt != null) candidates.add(dt);
    }

    // 2. صيغة سنة - شهر - يوم (مثال: 2026-12-25)
    final isoRegex = RegExp(r'\b(\d{4})[/\-.](\d{1,2})[/\-.](\d{1,2})\b');
    for (final match in isoRegex.allMatches(rawText)) {
      final year = int.tryParse(match.group(1)!);
      final month = int.tryParse(match.group(2)!);
      final day = int.tryParse(match.group(3)!);
      if (year == null || month == null || day == null) continue;

      final dt = _tryBuildDate(year, month, day);
      if (dt != null) candidates.add(dt);
    }

    // 3. صيغة شهر / سنة (مثال: 12/2026 -> آخر يوم في الشهر)
    final monthYearRegex = RegExp(r'\b(0?[1-9]|1[0-2])[/\-](20\d{2})\b');
    for (final match in monthYearRegex.allMatches(rawText)) {
      final month = int.parse(match.group(1)!);
      final year = int.parse(match.group(2)!);
      final lastDayOfMonth = DateTime(year, month + 1, 0);
      candidates.add(lastDayOfMonth);
    }

    if (candidates.isEmpty) return null;

    // في الغالب تاريخ الصلاحية هو التاريخ الأبعد زمنياً من بين التواريخ المكتوبة
    candidates.sort((a, b) => b.compareTo(a));
    return candidates.first;
  }

  DateTime? _tryBuildDate(int year, int month, int day) {
    if (year < 2020 || year > 2040) return null;
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > 31) return null;

    final dt = DateTime(year, month, day);
    if (dt.year == year && dt.month == month && dt.day == day) {
      return dt;
    }
    return null;
  }

  void dispose() {
    _recognizer.close();
  }
}