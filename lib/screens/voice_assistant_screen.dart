import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/parcel_provider.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _messages.add(
      ChatMessage(
        text:
            'Bonjour ! Je suis votre assistant intelligent AgriSmart 🌾. Posez-moi vos questions sur vos parcelles, l\'irrigation, la météo ou le fonctionnement de l\'application !',
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });

    _generateAiResponse(text);
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() {
          _isListening = false;
        });
        const spokenText = "Quelles parcelles nécessitent une irrigation ?";
        _handleSubmitted(spokenText);
      });
    }
  }

  void _generateAiResponse(String userText) {
    final provider = context.read<ParcelProvider>();
    final query = userText.toLowerCase().trim();

    String response = '';

    // 1. Parcelle specific lookup
    bool foundParcels = false;
    for (final p in provider.parcels) {
      if (query.contains(p.name.toLowerCase()) ||
          query.contains(p.crop.toLowerCase()) ||
          query.contains(p.id.toLowerCase())) {
        final status = p.needsIrrigation
            ? '⚠️ Attention : Humidité faible (${p.humidity.toStringAsFixed(1)}%), sous le seuil de ${p.threshold.toStringAsFixed(1)}%. Irrigation recommandée !'
            : '✅ Statut parfait : Humidité de ${p.humidity.toStringAsFixed(1)}% (Seuil : ${p.threshold.toStringAsFixed(1)}%).';

        response =
            '📌 **${p.name}** (Culture : ${p.crop})\n• Surface : ${p.area} ha\n• Localisation : ${p.location}\n$status';
        foundParcels = true;
        break;
      }
    }

    if (!foundParcels) {
      // 2. Irrigation status
      if (query.contains('eau') ||
          query.contains('irriguer') ||
          query.contains('arrosage') ||
          query.contains('seuil') ||
          query.contains('besoin')) {
        final count = provider.irrigationCount;
        if (count == 0) {
          response =
              '🎉 Excellente nouvelle ! Toutes vos ${provider.totalParcels} parcelles sont à un niveau d\'humidité idéal. Aucune action d\'irrigation n\'est nécessaire actuellement.';
        } else {
          final lowParcels = provider.parcels
              .where((p) => p.needsIrrigation)
              .map((p) => '${p.name} (${p.humidity.toStringAsFixed(0)}%)')
              .join(', ');

          response =
              '💧 Vous avez $count zone(s) sur ${provider.totalParcels} sous le seuil d\'irrigation : $lowParcels.\nJe vous conseille d\'activer l\'irrigation sur ces zones.';
        }
      }
      // 3. Weather
      else if (query.contains('météo') ||
          query.contains('meteo') ||
          query.contains('pluie') ||
          query.contains('temperature') ||
          query.contains('température')) {
        response =
            '☀️ **Météo Kébili** :\n• Température : 30°C\n• Humidité de l\'air : 23%\n• Vent : 19 km/h\n• Prévisions : Pas de pluie significative prévue pour les 3 prochains jours.';
      }
      // 4. App usage & Guide
      else if (query.contains('ajouter') || query.contains('creer') || query.contains('nouvelle')) {
        response =
            '➕ Pour **ajouter une parcelle** :\n1. Allez sur l\'onglet **Zones**.\n2. Appuyez sur le bouton vert flottant **+** en bas à droite.\n3. Remplissez le nom, le type de culture, la surface et le seuil d\'irrigation.';
      } else if (query.contains('supprimer') || query.contains('effacer')) {
        response =
            '🗑️ Pour **supprimer une parcelle** :\nFaites un **appui long** (maintenez appuyé) sur la carte de la parcelle dans l\'onglet **Zones**. Une boîte de dialogue de confirmation vous permettra de valider la suppression.';
      } else if (query.contains('qr') || query.contains('scanner') || query.contains('code')) {
        response =
          '📷 Pour utiliser le **QR Code** :\nAppuyez sur l\'icône de scanner QR en haut de l\'écran d\'accueil. Vous pourrez scanner vos capteurs ou générer un QR code pour chaque parcelle.';
      } else if (query.contains('mot de passe') || query.contains('login') || query.contains('compte') || query.contains('email')) {
        response =
            '🔑 Pour la **réinitialisation du mot de passe** :\nSur l\'écran de connexion, cliquez sur *"Mot de passe oublié ?"*. Saisissez votre email et un lien sécurisé vous sera envoyé par Firebase.';
      }
      // 5. Agricultural tips
      else if (query.contains('conseil') || query.contains('tomate') || query.contains('blé') || query.contains('olivier')) {
        response =
            '🌱 **Conseil Agricole AgriSmart** :\n- **Tomate** : Nécessite un sol constamment frais, maintenir au-dessus de 35% d\'humidité.\n- **Olivier** : Arrosage modéré, résistant à la sécheresse.\n- **Heure conseillée** : Irriguez tôt le matin ou tard le soir pour limiter l\'évaporation.';
      }
      // 6. General farm stats
      else if (query.contains('stat') || query.contains('moyenne') || query.contains('surface') || query.contains('total')) {
        response =
            '📊 **Résumé de votre exploitation** :\n• Total des parcelles : ${provider.totalParcels}\n• Surface totale : ${provider.totalArea.toStringAsFixed(1)} ha\n• Humidité moyenne : ${provider.averageHumidity.toStringAsFixed(1)}%\n• Humidité minimale : ${provider.minimumHumidity.toStringAsFixed(1)}%';
      }
      // 7. General fallback
      else {
        response =
            'Je suis à votre service ! Vous pouvez me demander par exemple :\n• *"Quelles parcelles irriguer ?"*\n• *"Comment supprimer une parcelle ?"*\n• *"Donne-moi l\'état de la Parcelle Nord"*\n• *"Quelle est la météo à Kébili ?"*';
      }
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF276738);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F1),
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        title: const Text(
          'Assistant Vocal AgriSmart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Voice Mic Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            color: const Color(0xFFEAF3E8),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = _isListening
                          ? 1.0 + (_pulseController.value * 0.25)
                          : 1.0;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isListening
                                ? const Color(0xFFE16A45)
                                : darkGreen,
                            boxShadow: [
                              BoxShadow(
                                color: (_isListening
                                        ? const Color(0xFFE16A45)
                                        : darkGreen)
                                    .withValues(alpha: 0.4),
                                blurRadius: _isListening ? 20 : 8,
                                spreadRadius: _isListening ? 6 : 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isListening
                      ? 'Écoute en cours... Posez votre question'
                      : 'Appuyez sur le micro pour parler',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isListening
                        ? const Color(0xFFE16A45)
                        : darkGreen,
                  ),
                ),
              ],
            ),
          ),

          // Quick Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _chipPrompt('Zones à irriguer ?'),
                _chipPrompt('Comment supprimer une parcelle ?'),
                _chipPrompt('Parcelle Nord ?'),
                _chipPrompt('Météo Kébili'),
              ],
            ),
          ),

          const Divider(height: 1),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.82,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser ? darkGreen : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.isUser ? 16 : 0),
                        bottomRight: Radius.circular(msg.isUser ? 0 : 16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isUser ? Colors.white : Colors.black87,
                        fontSize: 14.5,
                        height: 1.35,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Text Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Posez votre question à l\'assistant...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F7F1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: darkGreen),
                  onPressed: () => _handleSubmitted(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipPrompt(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(text),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF276738)),
        onPressed: () => _handleSubmitted(text),
      ),
    );
  }
}
