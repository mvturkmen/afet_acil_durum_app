import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/pages/user_info.dart';
import 'package:afet_acil_durum_app/pages/app_settings.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _connectivityService.baslat();
  }

  @override
  void dispose() {
    _connectivityService.kapat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: buildHeader(themeController),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(
                "AYARLAR",
                style: TextStyle(
                  color: themeController.isDarkMode ? Colors.white : Colors.grey[800],
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Expanded(
                      child: buildSettingsCard(
                        title: "Kullanıcı Bilgileri",
                        subtitle: "Kullanıcının kişisel bilgileri",
                        icon: Icons.person,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserInfo()),
                          );
                        },
                        isDarkMode: themeController.isDarkMode,
                      ),
                    ),
                    Expanded(
                      child: buildSettingsCard(
                        title: "Bildirim Ayarları",
                        subtitle: "Bildirim tercihleri",
                        icon: Icons.notifications,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bildirim Ayarları seçildi!')),
                          );
                        },
                        isDarkMode: themeController.isDarkMode,
                      ),
                    ),
                    Expanded(
                      child: buildSettingsCard(
                        title: "Gizlilik",
                        subtitle: "Gizlilik ve güvenlik ayarları",
                        icon: Icons.privacy_tip,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gizlilik seçildi!')),
                          );
                        },
                        isDarkMode: themeController.isDarkMode,
                      ),
                    ),
                    Expanded(
                      child: buildSettingsCard(
                        title: "Konum Ayarları",
                        subtitle: "Konum paylaşımı ve harita ayarları",
                        icon: Icons.location_on,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Konum Ayarları seçildi!')),
                          );
                        },
                        isDarkMode: themeController.isDarkMode,
                      ),
                    ),
                    Expanded(
                      child: buildSettingsCard(
                        title: "Uygulama Ayarları",
                        subtitle: "Genel uygulama tercihleri",
                        icon: Icons.settings,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AppSettings()),
                          );
                        },
                        isDarkMode: themeController.isDarkMode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: buildBigBell(themeController.isDarkMode),
            ),
            buildBottomNavigationBar(context, themeController.isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(ThemeController themeController) {
    return StreamBuilder<BaglantiDurumu>(
      stream: _connectivityService.baglantiStream,
      initialData: _connectivityService.mevcutDurum,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _connectivityService.baglantiRengi().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _connectivityService.baglantiRengi(),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _connectivityService.baglantiIkonu(),
                    color: _connectivityService.baglantiRengi(),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _connectivityService.baglantiTipiMetni(),
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade300,
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black54 : Colors.blueGrey.shade100.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white12 : Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBigBell(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Acil durum alarmı aktifleştirildi!')),
        );
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.red.shade900 : Colors.red.shade700,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.red.shade900.withOpacity(0.7) : Colors.red.shade300.withOpacity(0.7),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.notifications_active,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.blueGrey.shade900 : Colors.blueGrey.shade700,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
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
              isActive: true,
              onTap: () {},
              isDarkMode: isDarkMode,
            ),
            navIcon(
              icon: Icons.people,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyContact())),
              isDarkMode: isDarkMode,
            ),
            navIcon(
              icon: Icons.home,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Homepage())),
              isDarkMode: isDarkMode,
            ),
            navIcon(
              icon: Icons.notifications,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage())),
              isDarkMode: isDarkMode,
            ),
            navIcon(
              icon: Icons.map,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MapArea())),
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget navIcon({required IconData icon, required VoidCallback onTap, bool isActive = false, required bool isDarkMode}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: isActive
            ? BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.2),
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
}