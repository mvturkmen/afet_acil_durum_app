import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/pages/user_info.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                "AYARLAR",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildSettingsCard(
                        title: "Acil Durum Bilgileri",
                        subtitle: "Acil durumda lazım olacak bilgiler.",
                        icon: Icons.person,
                        height: 80,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserInfoPage()),
                          );
                        },
                      ),
                      buildSettingsCard(
                        title: "Bildirim Ayarları",
                        subtitle: "Bildirim tercihleri",
                        icon: Icons.notifications,
                        height: 80,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Bildirim Ayarlarıı seçildi!')),
                          );
                        },
                      ),
                      buildSettingsCard(
                        title: "Gizlilik",
                        subtitle: "Gizlilik ve güvenlik ayarları",
                        icon: Icons.privacy_tip,
                        height: 80,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gizlilik seçildi!')),
                          );
                        },
                      ),
                      buildSettingsCard(
                        title: "Konum Ayarları",
                        subtitle: "Konum paylaşımı ve harita ayarları",
                        icon: Icons.location_on,
                        height: 80,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Konum Settingsı seçildi!')),
                          );
                        },
                      ),
                      buildSettingsCard(
                        title: "Uygulama Ayarları",
                        subtitle: "Genel uygulama tercihleri",
                        icon: Icons.settings,
                        height: 80,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Uygulama Ayarları seçildi!')),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      buildBigBell(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              buildBottomNavigationBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required double height,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.blueGrey.shade300,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.shade100.withOpacity(0.5),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        height: height,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBigBell() {
    return Center(
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Acil durum alarmı aktifleştirildi!')),
          );
        },
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.red.shade700,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade300.withOpacity(0.7),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.notifications_active,
            color: Colors.white,
            size: 48,
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade700,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navIcon(
            icon: Icons.settings,
            isActive: true,
            onTap: () {}, // Zaten bu sayfadayız
          ),
          navIcon(
            icon: Icons.people,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyContact())),
          ),
          navIcon(
            icon: Icons.home,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Homepage())),
          ),
          navIcon(
            icon: Icons.notifications,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificaitonPage())),
          ),
          navIcon(
            icon: Icons.map,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MapArea())),
          ),
        ],
      ),
    );
  }

  Widget navIcon({required IconData icon, required VoidCallback onTap, bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: isActive
            ? BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        )
            : null,
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white70,
          size: 32,
        ),
      ),
    );
  }
}