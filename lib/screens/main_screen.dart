import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/app_bottom_navigation.dart';
import 'gps_farm_mapping_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'plant_recognition_screen.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart';
import 'zones_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),              // 0: Accueil
    ZonesScreen(),             // 1: Zones
    StatisticsScreen(),        // 2: Statistiques
    PlantRecognitionScreen(),  // 3: Plant Scan
    GPSFarmMappingScreen(),    // 4: GPS Mapping
    ProfileScreen(),           // 5: Profil
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final langProvider = context.watch<LanguageProvider>();

    if (!authProvider.isAuthenticated) {
      return LoginScreen(
        onLoginSuccess: () {
          setState(() {
            selectedIndex = 0;
          });
        },
      );
    }

    return Scaffold(
      key: ValueKey(langProvider.languageCode),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}