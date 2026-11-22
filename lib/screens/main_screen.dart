import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gps_farm_mapping_screen.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'zones_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'plant_recognition_screen.dart';
import 'expiry_management_screen.dart'; // <-- 1. استيراد الشاشة الجديدة
import '../widgets/app_bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),              // 0
    ZonesScreen(),             // 1
    StatisticsScreen(),        // 2
    PlantRecognitionScreen(),  // 3
    ProfileScreen(),           // 4
    GPSFarmMappingScreen(),    // 5
    ExpiryManagementScreen(),  // 6 <-- Smart Expiry Detector
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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