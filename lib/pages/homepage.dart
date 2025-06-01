import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/pages/notificaiton_page.dart';
import 'package:afet_acil_durum_app/pages/user_info.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/service/notiService.dart'; // Bildirim servisinizi import edin

import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  String textField1 = '';
  String textField2 = '';

  // Bildirim servisi instance'ı
  final NotiService _notiService = NotiService();

  @override
  void initState() {
    super.initState();
    // Sayfa açılırken bildirim servisini başlat
    _initializeNotificationService();
  }

  Future<void> _initializeNotificationService() async {
    try {
      await _notiService.initNotification();
      print('Bildirim servisi başarıyla başlatıldı');
    } catch (e) {
      print('Bildirim servisi başlatılırken hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Daha açık bir arka plan
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                "YARDIM ÇAĞIR",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              buildEmergencyCard(),
              buildLocationCard(),
              buildPlaceholderBox(),
              buildDualIconRow(),
              const Spacer(),
              buildBigBell(),
              const SizedBox(height: 16),
              buildBottomNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmergencyCard() {
    return GestureDetector(
      onTap: () async {
        // Bildirim gönder
        await _sendEmergencyNotification();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Acil durum bildirimi gönderildi!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.red.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade200.withOpacity(0.5),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Image.network(
              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/gol3gopo_expires_30_days.png",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Hızlı Yardım",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.black38,
                      offset: Offset(0, 2),
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

  Widget buildLocationCard() {
    return GestureDetector(
      onTap: () async {
        // Konum paylaşım bildirimi gönder
        await _sendLocationNotification();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Konum paylaşım bildirimi gönderildi!'),
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
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
        child: Row(
          children: [
            Image.network(
              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/8ha6n32n_expires_30_days.png",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Konumumu Paylaş",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 21,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceholderBox() {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.blueGrey.shade200,
          width: 1.5,
        ),
      ),
    );
  }

  Widget buildDualIconRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              // El feneri bildirimi gönder
              await _sendFlashlightNotification();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('El feneri bildirimi gönderildi!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.only(right: 12),
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
              child: Center(
                child: Image.network(
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/fp9cumfa_expires_30_days.png",
                  width: 70,
                  height: 70,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              // Düdük bildirimi gönder
              await _sendWhistleNotification();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Düdük bildirimi gönderildi!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.only(left: 12),
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
              child: Center(
                child: Image.network(
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/vixwrgce_expires_30_days.png",
                  width: 70,
                  height: 70,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBigBell() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          // Genel alarm bildirimi gönder
          await _sendAlarmNotification();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Alarm bildirimi gönderildi!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
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

  Widget buildBottomNavigationBar() {
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
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyContact())),
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

  Widget navIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 32),
    );
  }

  // Bildirim gönderme metodları
  Future<void> _sendEmergencyNotification() async {
    if (!_notiService.isInitialized) {
      await _initializeNotificationService();
    }

    await _notiService.showNotification(
      id: 1,
      title: '🚨 ACİL DURUM!',
      body: 'Acil yardım talebi gönderildi. En yakın yardım ekipleri bilgilendirildi.',
    );
  }

  Future<void> _sendLocationNotification() async {
    if (!_notiService.isInitialized) {
      await _initializeNotificationService();
    }

    await _notiService.showNotification(
      id: 2,
      title: '📍 Konum Paylaşıldı',
      body: 'Konumunuz acil durum ekipleriyle paylaşıldı.',
    );
  }

  Future<void> _sendFlashlightNotification() async {
    if (!_notiService.isInitialized) {
      await _initializeNotificationService();
    }

    await _notiService.showNotification(
      id: 3,
      title: '🔦 El Feneri',
      body: 'El feneri özelliği aktif edildi.',
    );
  }

  Future<void> _sendWhistleNotification() async {
    if (!_notiService.isInitialized) {
      await _initializeNotificationService();
    }

    await _notiService.showNotification(
      id: 4,
      title: '📢 Düdük Sesi',
      body: 'Acil durum düdük sesi çalınıyor.',
    );
  }

  Future<void> _sendAlarmNotification() async {
    if (!_notiService.isInitialized) {
      await _initializeNotificationService();
    }

    await _notiService.showNotification(
      id: 5,
      title: '🔔 ALARM!',
      body: 'Genel alarm sistemi aktif edildi.',
    );
  }
}