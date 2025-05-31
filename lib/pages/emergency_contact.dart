import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/pages/notificaiton_page.dart';
import 'package:afet_acil_durum_app/pages/user_info.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';


class EmergencyContact extends StatelessWidget {
  final List<Map<String, String>> kisiler = [
    {"isim": "Barış Alper", "telefon": "0555 123 4567", "adres": "İstanbul, Kadıköy"},
    {"isim": "Mehmet Kaya", "telefon": "0555 987 6543", "adres": "Ankara, Çankaya"},
    {"isim": "Zeynep Demir", "telefon": "0555 345 6789", "adres": "İzmir, Karşıyaka"},
  ];

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
                "ACİL DURUM KİŞİLERİ",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemCount: kisiler.length,
                  itemBuilder: (context, index) {
                    final kisi = kisiler[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Colors.grey[100],
                            title: Text(
                                kisi['isim']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                )
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.phone, color: Colors.blueGrey.shade600, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text("${kisi['telefon']}")),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on, color: Colors.blueGrey.shade600, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text("${kisi['adres']}")),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blueGrey.shade700,
                                ),
                                child: const Text("Kapat", style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade300,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.shade100.withOpacity(0.5),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kisi['isim']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4,
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    kisi['telefon']!,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              buildBigBell(context),
              buildBottomNavigationBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBigBell(BuildContext context) {
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
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Settings())),
          ),
          navIcon(
            icon: Icons.people,
            isActive: true,
            onTap: () {}, // Zaten bu sayfadayız
          ),
          navIcon(
            icon: Icons.home,
            onTap: () => Navigator.pop(context), // Anasayfaya dön
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
        decoration: isActive ? BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ) : null,
        child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.white70,
            size: 32
        ),
      ),
    );
  }
}