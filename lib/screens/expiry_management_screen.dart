import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expiry_product_model.dart';
import '../services/expiry_notification_service.dart';
import '../services/expiry_ocr_service.dart';

class ExpiryManagementScreen extends StatefulWidget {
  const ExpiryManagementScreen({super.key});

  @override
  State<ExpiryManagementScreen> createState() => _ExpiryManagementScreenState();
}

class _ExpiryManagementScreenState extends State<ExpiryManagementScreen> {
  final ExpiryOcrService _ocrService = ExpiryOcrService();
  final ExpiryNotificationService _notifService = ExpiryNotificationService();

  ExpiryStatus? _selectedFilter; // null = الكل
  bool _isScanning = false;

    CollectionReference<Map<String, dynamic>> get _productsRef {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'default_user';
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expiry_products');
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _scanFromSource({required bool fromCamera}) async {
    setState(() => _isScanning = true);
    try {
      final imageFile = await _ocrService.pickImage(fromCamera: fromCamera);
      if (imageFile == null || !mounted) return;

      final rawText = await _ocrService.extractRawText(imageFile);
      final detectedDate = _ocrService.parseExpiryDate(rawText);

      if (!mounted) return;
      await _showConfirmProductDialog(
        initialDate: detectedDate ?? DateTime.now().add(const Duration(days: 30)),
        rawOcrText: rawText,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur OCR : $e')),
      );
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _showConfirmProductDialog({
    required DateTime initialDate,
    String rawOcrText = '',
  }) async {
    final nameController = TextEditingController();
    String category = 'Engrais';
    DateTime pickedDate = initialDate;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Confirmer le produit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du produit',
                      hintText: 'Ex: Engrais NPK, Semences...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(
                      labelText: 'Catégorie',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Engrais', child: Text('Engrais')),
                      DropdownMenuItem(value: 'Semences', child: Text('Semences')),
                      DropdownMenuItem(
                        value: 'Produit phyto',
                        child: Text('Produit phyto'),
                      ),
                      DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => category = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today, color: Colors.green),
                    title: const Text('Date d\'expiration'),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(pickedDate)),
                    trailing: TextButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: ctx,
                          initialDate: pickedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2040),
                        );
                        if (selected != null) {
                          setModalState(() => pickedDate = selected);
                        }
                      },
                      child: const Text('Modifier'),
                    ),
                  ),
                  if (rawOcrText.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Texte détecté : ${rawOcrText.replaceAll('\n', ' ')}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Enregistrer & programmer alertes'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        final name = nameController.text.trim().isEmpty
                            ? 'Produit sans nom'
                            : nameController.text.trim();

                        final docRef = _productsRef.doc();
                        final product = ExpiryProductModel(
                          id: docRef.id,
                          name: name,
                          category: category,
                          expiryDate: pickedDate,
                          createdAt: DateTime.now(),
                        );

                        await docRef.set(product.toMap());
                        await _notifService.scheduleExpiryAlerts(
                          productId: product.id,
                          productName: product.name,
                          expiryDate: product.expiryDate,
                        );

                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(ExpiryStatus status) {
    switch (status) {
      case ExpiryStatus.valid:
        return Colors.green;
      case ExpiryStatus.expiringSoon:
        return Colors.orange;
      case ExpiryStatus.expired:
        return Colors.red;
    }
  }

  String _statusLabel(ExpiryStatus status, int days) {
    switch (status) {
      case ExpiryStatus.valid:
        return 'Valide ($days j)';
      case ExpiryStatus.expiringSoon:
        return 'Expire bientôt ($days j)';
      case ExpiryStatus.expired:
        return 'Expiré (${days.abs()} j)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Expiry Detector'),
        actions: [
          IconButton(
            tooltip: 'Importer une image',
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: _isScanning
                ? null
                : () => _scanFromSource(fromCamera: false),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        onPressed:
        _isScanning ? null : () => _scanFromSource(fromCamera: true),
        icon: _isScanning
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.document_scanner_outlined),
        label: Text(_isScanning ? 'Analyse...' : 'Scanner date'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Tous'),
                  selected: _selectedFilter == null,
                  onSelected: (_) => setState(() => _selectedFilter = null),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Valide'),
                  selected: _selectedFilter == ExpiryStatus.valid,
                  onSelected: (_) =>
                      setState(() => _selectedFilter = ExpiryStatus.valid),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Expire bientôt'),
                  selected: _selectedFilter == ExpiryStatus.expiringSoon,
                  onSelected: (_) => setState(
                        () => _selectedFilter = ExpiryStatus.expiringSoon,
                  ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Expiré'),
                  selected: _selectedFilter == ExpiryStatus.expired,
                  onSelected: (_) =>
                      setState(() => _selectedFilter = ExpiryStatus.expired),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _productsRef.orderBy('expiryDate').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              }

              final allItems = (snapshot.data?.docs ?? [])
                  .map((doc) => ExpiryProductModel.fromFirestore(doc))
                  .where((item) =>
              _selectedFilter == null || item.status == _selectedFilter)
                  .toList();

              if (allItems.isEmpty) {
                return const Center(
                  child: Text('Aucun produit enregistré pour le moment.'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: allItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = allItems[index];
                  final color = _statusColor(item.status);

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.15),
                        child: Icon(Icons.inventory_2_outlined, color: color),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${item.category} • Exp: ${item.formattedDate}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _statusLabel(item.status, item.daysRemaining),
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await _notifService.cancelExpiryAlerts(item.id);
                              await _productsRef.doc(item.id).delete();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            ),
          ),
        ],
      ),
    );
  }
}