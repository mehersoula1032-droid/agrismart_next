import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/parcel_provider.dart';
import '../services/app_strings.dart';

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
  bool _initializedGreeting = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedGreeting) {
      _initializedGreeting = true;
      final s = AppStrings.of(context);
      _messages.add(
        ChatMessage(
          text: s.tr('voice_greeting'),
          isUser: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text, AppStrings s) {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });

    _generateAiResponse(text, s);
  }

  void _toggleListening(AppStrings s) {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() {
          _isListening = false;
        });
        _handleSubmitted(s.tr('spoken_sample_question'), s);
      });
    }
  }

  void _generateAiResponse(String userText, AppStrings s) {
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
            ? '${s.tr('ai_parcel_alert')} (${p.humidity.toStringAsFixed(1)}%), ${s.tr('ai_under_threshold')} ${p.threshold.toStringAsFixed(1)}%. ${s.tr('ai_irrigation_recommended')}'
            : '${s.tr('ai_status_perfect')} ${p.humidity.toStringAsFixed(1)}% (${s.tr('ai_threshold_parens')} : ${p.threshold.toStringAsFixed(1)}%).';

        response =
        '📌 ${p.name} (${s.tr('crop_label')} : ${p.crop})\n• ${s.tr('ai_area_bullet')} : ${p.area} ha\n• ${s.tr('ai_location_bullet')} : ${p.location}\n$status';
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
          query.contains('besoin') ||
          query.contains('ري') ||
          query.contains('irrigate') ||
          query.contains('water')) {
        final count = provider.irrigationCount;
        if (count == 0) {
          response = s.tr('ai_all_humidity_ideal');
        } else {
          final lowParcels = provider.parcels
              .where((p) => p.needsIrrigation)
              .map((p) => '${p.name} (${p.humidity.toStringAsFixed(0)}%)')
              .join(', ');

          response =
          '${s.tr('ai_zones_below_prefix')} $count ${s.tr('ai_zones_below_mid')} ${provider.totalParcels} ${s.tr('ai_zones_below_suffix')} $lowParcels.\n${s.tr('ai_advise_irrigate')}';
        }
      }
      // 3. Weather
      else if (query.contains('météo') ||
          query.contains('meteo') ||
          query.contains('pluie') ||
          query.contains('temperature') ||
          query.contains('température') ||
          query.contains('طقس') ||
          query.contains('weather')) {
        response =
        '${s.tr('ai_weather_kebili_title')}\n• ${s.tr('ai_temp_bullet')} : 30°C\n• ${s.tr('air_humidity_label')} : 23%\n• ${s.tr('wind_label')} : 19 km/h\n• ${s.tr('ai_forecast_bullet')}';
      }
      // 4. App usage & Guide
      else if (query.contains('ajouter') ||
          query.contains('creer') ||
          query.contains('nouvelle') ||
          query.contains('إضافة') ||
          query.contains('add')) {
        response = s.tr('ai_guide_add');
      } else if (query.contains('supprimer') ||
          query.contains('effacer') ||
          query.contains('حذف') ||
          query.contains('delete')) {
        response = s.tr('ai_guide_delete');
      } else if (query.contains('qr') ||
          query.contains('scanner') ||
          query.contains('code') ||
          query.contains('مسح')) {
        response = s.tr('ai_guide_qr');
      } else if (query.contains('mot de passe') ||
          query.contains('login') ||
          query.contains('compte') ||
          query.contains('email') ||
          query.contains('كلمة المرور') ||
          query.contains('password')) {
        response = s.tr('ai_guide_password');
      }
      // 5. Agricultural tips
      else if (query.contains('conseil') ||
          query.contains('tomate') ||
          query.contains('blé') ||
          query.contains('olivier') ||
          query.contains('نصيحة') ||
          query.contains('tip')) {
        response = s.tr('ai_agri_tips');
      }
      // 6. General farm stats
      else if (query.contains('stat') ||
          query.contains('moyenne') ||
          query.contains('surface') ||
          query.contains('total') ||
          query.contains('إحصائيات') ||
          query.contains('summary')) {
        response =
        '${s.tr('ai_farm_summary_title')}\n• ${s.tr('ai_total_parcels_bullet')} : ${provider.totalParcels}\n• ${s.tr('ai_total_area_bullet')} : ${provider.totalArea.toStringAsFixed(1)} ha\n• ${s.tr('avg_humidity')} : ${provider.averageHumidity.toStringAsFixed(1)}%\n• ${s.tr('min_humidity')} : ${provider.minimumHumidity.toStringAsFixed(1)}%';
      }
      // 7. General fallback
      else {
        response = s.tr('ai_fallback_help');
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
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F1),
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        title: Text(
          s.tr('voice_assistant_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                  onTap: () => _toggleListening(s),
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
                      ? s.tr('listening_in_progress')
                      : s.tr('tap_mic_to_speak'),
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
                _chipPrompt(s.tr('chip_zones_to_irrigate'), s),
                _chipPrompt(s.tr('chip_how_delete_parcel'), s),
                _chipPrompt(s.tr('chip_north_parcel'), s),
                _chipPrompt(s.tr('chip_kebili_weather'), s),
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
                      hintText: s.tr('ask_assistant_hint'),
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
                    onSubmitted: (val) => _handleSubmitted(val, s),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: darkGreen),
                  onPressed: () => _handleSubmitted(_textController.text, s),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipPrompt(String text, AppStrings s) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(text),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF276738)),
        onPressed: () => _handleSubmitted(text, s),
      ),
    );
  }
}