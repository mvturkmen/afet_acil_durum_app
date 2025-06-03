import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class MapArea extends StatefulWidget {
  const MapArea({super.key});

  @override
  MapAreaState createState() => MapAreaState();
}

class MapAreaState extends State<MapArea> {
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
    final isDark = themeController.isDarkMode;

    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey[100];
    final headerTextColor = isDark ? Colors.white : Colors.grey[800];
    final containerColor = isDark ? Colors.blueGrey.shade700 : Colors.blueGrey.shade300;
    final containerShadowColor = isDark ? Colors.black54 : Colors.blueGrey.shade100.withOpacity(0.5);
    final iconColor = isDark ? Colors.white70 : Colors.white;
    final labelTextColor = isDark ? Colors.white : Colors.white;
    final navBarColor = isDark ? Colors.blueGrey.shade900 : Colors.blueGrey.shade700;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: buildHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "TOPLANMA NOKTALARI",
                      style: TextStyle(
                        color: headerTextColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: containerShadowColor,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: 400,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade200,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                color: isDark ? Colors.blueGrey.shade700 : Colors.blueGrey.shade300,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.map,
                                        size: 80,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Harita Yükleniyor...",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: containerShadowColor,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildNavigationButton(
                            imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/0bwzb9ff_expires_30_days.png",
                            label: "Konum",
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Konum butonuna tıklandı!')),
                              );
                            },
                            iconBgColor: Colors.white.withOpacity(0.2),
                            labelColor: labelTextColor,
                          ),
                          buildNavigationButton(
                            imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/xwqmgudg_expires_30_days.png",
                            label: "Yönler",
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Yönler butonuna tıklandı!')),
                              );
                            },
                            iconBgColor: Colors.white.withOpacity(0.2),
                            labelColor: labelTextColor,
                          ),
                          buildNavigationButton(
                            imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/43wh7z5r_expires_30_days.png",
                            label: "Paylaş",
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Paylaş butonuna tıklandı!')),
                              );
                            },
                            iconBgColor: Colors.white.withOpacity(0.2),
                            labelColor: labelTextColor,
                          ),
                          buildNavigationButton(
                            imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/yya0iclm_expires_30_days.png",
                            label: "Yakınlaştır",
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Yakınlaştır butonuna tıklandı!')),
                              );
                            },
                            iconBgColor: Colors.white.withOpacity(0.2),
                            labelColor: labelTextColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Acil durum alarmı aktifleştirildi!'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.shade300.withOpacity(0.7),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notifications_active,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: navBarColor,
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Settings())),
                      iconColor: iconColor,
                    ),
                    navIcon(
                      icon: Icons.people,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyContact())),
                      iconColor: iconColor,
                    ),
                    navIcon(
                      icon: Icons.home,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Homepage())),
                      iconColor: iconColor,
                    ),
                    navIcon(
                      icon: Icons.notifications,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage())),
                      iconColor: iconColor,
                    ),
                    navIcon(
                      icon: Icons.map,
                      isActive: true,
                      onTap: () {},
                      iconColor: iconColor,
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

  Widget buildNavigationButton({
    required String imageUrl,
    required String label,
    required VoidCallback onTap,
    required Color iconBgColor,
    required Color labelColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.network(
                imageUrl,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 24,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget navIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
    Color? iconColor,
  }) {
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
          color: iconColor ?? (isActive ? Colors.white : Colors.white70),
          size: 28,
        ),
      ),
    );
  }

  Widget buildHeader() {
    return StreamBuilder<BaglantiDurumu>(
      stream: _connectivityService.baglantiStream,
      initialData: _connectivityService.mevcutDurum,
      builder: (context, snapshot) {
        final themeController = Provider.of<ThemeController>(context);
        final isDark = themeController.isDarkMode;
        final borderColor = _connectivityService.baglantiRengi();
        final bgColor = borderColor.withOpacity(0.1);
        final textColor = isDark ? Colors.white : borderColor;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: borderColor,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _connectivityService.baglantiIkonu(),
                    color: borderColor,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _connectivityService.baglantiTipiMetni(),
                    style: TextStyle(
                      color: textColor,
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
}