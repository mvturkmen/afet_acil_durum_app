import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/pages/notificaiton_page.dart';
import 'package:afet_acil_durum_app/pages/user_info.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';

import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  String textField1 = '';
  String textField2 = '';

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
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hızlı Yardım butonuna tıklandı!')),
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
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konumumu Paylaş butonuna tıklandı!')),
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
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('El Feneri butonuna tıklandı!')),
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
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Düdük butonuna tıklandı!')),
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
}
