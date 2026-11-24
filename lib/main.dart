import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'providers/parcel_provider.dart';
import 'providers/reglages_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // TP8 : Ouvre le stockage une seule fois, au démarrage
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ReglagesProvider(prefs)),
        // Météo réelle (Open-Meteo) : chargée dès le démarrage
        ChangeNotifierProvider(create: (_) => WeatherProvider()..load()),
        ChangeNotifierProvider(
          create: (context) =>
              ParcelProvider(prefs, context.read<AuthProvider>()),
        ),
      ],
      child: const AgriSmartApp(),
    ),
  );
}

class AgriSmartApp extends StatelessWidget {
  const AgriSmartApp({super.key});

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFFF5F7F1),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF276738),
      brightness: Brightness.light,
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF276738),
      brightness: Brightness.dark,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ReglagesProvider>().themeMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriSmart Next',
      themeMode: themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      home: const MainScreen(),
    );
  }
}