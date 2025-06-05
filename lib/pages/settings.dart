import 'package:afet_acil_durum_app/services/speechText_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/pages/user_info.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';
import '../widgets/bell_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/header_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final ConnectivityService _connectivityService = ConnectivityService();
  final SpeechService _speechService = SpeechService();
  String text = 'Bir şey söyleyin...';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initSpeech() async {
    bool available = await _speechService.initSpeech();
    if (!available) {
      setState(() {
        text = 'Konuşma tanıma kullanılamıyor.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text(
                "AYARLAR",
                style: TextStyle(
                  color: themeController.isDarkMode ? Colors.white : Colors.grey[800],
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),

            // Settings list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  buildSettingsCard(
                    title: "Kullanıcı Bilgileri",
                    subtitle: "Kullanıcının kişisel bilgileri",
                    icon: Icons.person,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserInfo()),
                      );
                    },
                    onDoubleTap: () {},
                    isDarkMode: themeController.isDarkMode,
                  ),

                  const SizedBox(height: 12),
                  buildThemeSwitchCard(themeController),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Bell Widget
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: buildBigBell(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(activePage: 'settings'),
    );
  }

  Widget buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onDoubleTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey.shade300,
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.blueGrey.shade700 : Colors.blueGrey.shade100.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white12 : Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildThemeSwitchCard(ThemeController themeController) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: themeController.isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey.shade300,
        boxShadow: [
          BoxShadow(
            color: themeController.isDarkMode
                ? Colors.blueGrey.shade700
                : Colors.blueGrey.shade100.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: themeController.isDarkMode
                    ? Colors.white12
                    : Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.dark_mode,
                color: themeController.isDarkMode ? Colors.yellow : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    themeController.isDarkMode ? 'Koyu Modda' : 'Açık Modda',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Tema değiştirmek için switch'i kullanın",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: themeController.isDarkMode,
              onChanged: themeController.toggleTheme,
              activeColor: Colors.white,
              activeTrackColor: Colors.green,
              inactiveThumbColor: Colors.white70,
              inactiveTrackColor: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBigBell() {
    return BigBellWidget();
  }
}
