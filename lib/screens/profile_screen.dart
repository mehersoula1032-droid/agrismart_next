import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../providers/parcel_provider.dart';
import '../services/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parcelProvider = context.watch<ParcelProvider>();
    final authProvider = context.watch<AuthProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final s = AppStrings.of(context);
    const darkGreen = Color(0xFF276738);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F1),
      body: SafeArea(
        child: Column(
          children: [
            // Top Green Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              color: darkGreen,
              child: Text(
                s.tr('nav_profile'),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Avatar Circle with Tractor
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF3E8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.agriculture,
                        size: 48,
                        color: darkGreen,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      authProvider.displayName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      authProvider.userEmail,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Profile Menu List
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.language,
                              color: darkGreen,
                            ),
                            title: Text(
                              s.tr('choose_language'),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: SegmentedButton<String>(
                              style: SegmentedButton.styleFrom(
                                selectedBackgroundColor: darkGreen,
                                selectedForegroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1B4332),
                                visualDensity: VisualDensity.compact,
                              ),
                              segments: const [
                                ButtonSegment<String>(
                                  value: 'ar',
                                  label: Text('العربية'),
                                ),
                                ButtonSegment<String>(
                                  value: 'fr',
                                  label: Text('FR'),
                                ),
                                ButtonSegment<String>(
                                  value: 'en',
                                  label: Text('EN'),
                                ),
                              ],
                              selected: <String>{langProvider.languageCode},
                              onSelectionChanged: (Set<String> newSelection) {
                                langProvider.setLanguage(newSelection.first);
                              },
                            ),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: const Icon(
                              Icons.grass,
                              color: darkGreen,
                            ),
                            title: Text(
                              s.tr('tracked_zones'),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Text(
                              '${parcelProvider.totalParcels}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: const Icon(
                              Icons.info_outline,
                              color: darkGreen,
                            ),
                            title: Text(
                              s.tr('about'),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              _showAboutDialog(context, s);
                            },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: Text(
                              s.tr('logout'),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () {
                              _confirmSignOut(context, authProvider, s);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppStrings s) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.agriculture, color: Color(0xFF276738)),
            const SizedBox(width: 10),
            Text(s.tr('app_name')),
          ],
        ),
        content: Text(
          s.tr('about_description'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(s.tr('close')),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(
      BuildContext context,
      AuthProvider authProvider,
      AppStrings s,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(s.tr('logout_title')),
        content: Text(
          s.tr('logout_confirm_msg'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(s.tr('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await authProvider.signOut();
            },
            child: Text(s.tr('logout')),
          ),
        ],
      ),
    );
  }
}