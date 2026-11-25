import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/parcel_provider.dart';
import '../services/app_strings.dart';

class AppBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final parcelProvider = context.watch<ParcelProvider>();
    context.watch<LanguageProvider>();
    final s = AppStrings.of(context);
    final irrigationCount = parcelProvider.irrigationCount;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      backgroundColor: Theme.of(context).cardColor,
      indicatorColor: const Color(0xFFDDEBDD),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: s.tr('nav_home'),
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: irrigationCount > 0,
            label: Text('$irrigationCount'),
            backgroundColor: const Color(0xFFE16A45),
            child: const Icon(Icons.grass_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: irrigationCount > 0,
            label: Text('$irrigationCount'),
            backgroundColor: const Color(0xFFE16A45),
            child: const Icon(Icons.grass),
          ),
          label: s.tr('nav_zones'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.analytics_outlined),
          selectedIcon: const Icon(Icons.analytics),
          label: s.tr('nav_stats'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.center_focus_weak),
          selectedIcon: const Icon(Icons.center_focus_strong),
          label: s.tr('nav_plant_scan'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.map_outlined),
          selectedIcon: const Icon(Icons.map),
          label: s.tr('nav_gps_mapping'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: s.tr('nav_profile'),
        ),
      ],
    );
  }
}