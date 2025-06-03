
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';


Widget navIcon(
    {required IconData icon, required VoidCallback onTap, bool isActive = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: isActive
          ? BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      )
          : null,
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.white70,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade700,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navIcon(
              icon: Icons.settings,
              isActive: activePage == 'settings',
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


