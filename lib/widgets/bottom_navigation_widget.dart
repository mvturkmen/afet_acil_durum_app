import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

Widget navIcon({
  required IconData icon,
  required VoidCallback onTap,
  bool isActive = false,
  required bool isDarkMode,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: isActive
          ? BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.2)
            : Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      )
          : null,
      child: Icon(
        icon,
        color: isActive
            ? (isDarkMode ? Colors.white : Colors.black)
            : (isDarkMode ? Colors.white70 : Colors.black54),
        size: 28,
      ),
    ),
  );
}

class BottomNavigationWidget extends StatelessWidget {
  final String activePage;

  const BottomNavigationWidget({
    Key? key,
    required this.activePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.blueGrey.shade700,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navIcon(
              icon: Icons.settings,
              isActive: activePage == 'settings',
              isDarkMode: isDarkMode,
              onTap: () {
                if (activePage != 'settings') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Settings()),
                  );
                }
              },
            ),
            navIcon(
              icon: Icons.people,
              isActive: activePage == 'contacts',
              isDarkMode: isDarkMode,
              onTap: () {
                if (activePage != 'contacts') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const EmergencyContact()),
                  );
                }
              },
            ),
            navIcon(
              icon: Icons.home,
              isActive: activePage == 'home',
              isDarkMode: isDarkMode,
              onTap: () {
                if (activePage != 'home') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Homepage()),
                  );
                }
              },
            ),
            navIcon(
              icon: Icons.notifications,
              isActive: activePage == 'notifications',
              isDarkMode: isDarkMode,
              onTap: () {
                if (activePage != 'notifications') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationPage()),
                  );
                }
              },
            ),
            navIcon(
              icon: Icons.map,
              isActive: activePage == 'map',
              isDarkMode: isDarkMode,
              onTap: () {
                if (activePage != 'map') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MapArea()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}