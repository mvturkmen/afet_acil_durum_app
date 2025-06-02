import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/services/notiService.dart';
import 'package:afet_acil_durum_app/services/location_service.dart';
import 'package:afet_acil_durum_app/services/connectivity_service.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  EmergencyContactState createState() => EmergencyContactState();
}

class EmergencyContactState extends State<EmergencyContact> {
  final List<Map<String, String>> kisiler = [
    {"isim": "Ahmet Yılmaz", "telefon": "0555 123 4567", "adres": "İstanbul, Kadıköy"},
    {"isim": "Mehmet Kaya", "telefon": "0555 987 6543", "adres": "Ankara, Çankaya"},
    {"isim": "Zeynep Demir", "telefon": "0555 345 6789", "adres": "İzmir, Karşıyaka"},
  ];

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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Sabit header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: buildHeader(),
            ),

            // Kaydırılabilir içerik
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "ACİL DURUM KİŞİLERİ",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildContactsList(),
                    const SizedBox(height: 32),
                    buildBigBell(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Sabit alt navigasyon
            buildBottomNavigationBar(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
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
                      color: _connectivityService.baglantiRengi(),
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

  Widget buildContactsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade300,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100.withOpacity(0.5),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 30,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
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
    );
  }

  Widget buildBigBell(BuildContext context) {
    return Center(
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
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Settings())),
            ),
            navIcon(
              icon: Icons.people,
              isActive: true,
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
      ),
    );
  }

  Widget navIcon({required IconData icon, required VoidCallback onTap, bool isActive = false}) {
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
}