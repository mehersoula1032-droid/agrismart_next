
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/parcel_provider.dart';

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
    final irrigationCount = parcelProvider.irrigationCount;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFDDEBDD),
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Accueil',
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
          label: 'Zones',
        ),

        const NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Statistiques',
        ),

        const NavigationDestination(
          icon: Icon(Icons.center_focus_weak),
          selectedIcon: Icon(Icons.center_focus_strong),
          label: 'Plant Scan',
        ),

        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
