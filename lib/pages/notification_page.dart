import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/services/connectivity_service.dart';

class NotificaitonPage extends StatefulWidget {
  const NotificaitonPage({super.key});

  @override
  NotificaitonPageState createState() => NotificaitonPageState();
}

class NotificaitonPageState extends State<NotificaitonPage> {
  final List<Map<String, dynamic>> bildirimler = [
    {
      "baslik": "Acil Durum Uyarısı",
      "mesaj": "Bölgenizde deprem riski tespit edildi. Hazırlıklı olun.",
      "zaman": "5 dakika önce",
      "tip": "acil",
      "okundu": false,
    },
    {
      "baslik": "Hava Durumu",
      "mesaj": "Bugün şiddetli yağmur bekleniyor. Dışarı çıkarken dikkatli olun.",
      "zaman": "2 saat önce",
      "tip": "uyari",
      "okundu": false,
    },
    {
      "baslik": "Güvenlik Bilgilendirmesi",
      "mesaj": "Acil durum çantanızı kontrol etmeyi unutmayın.",
      "zaman": "1 gün önce",
      "tip": "bilgi",
      "okundu": true,
    },
    {
      "baslik": "Toplanma Noktası",
      "mesaj": "Size en yakın toplanma noktası güncellendi.",
      "zaman": "2 gün önce",
      "tip": "bilgi",
      "okundu": true,
    },
    {
      "baslik": "Sistem Güncellemesi",
      "mesaj": "Uygulama yeni özelliklerle güncellendi.",
      "zaman": "1 hafta önce",
      "tip": "sistem",
      "okundu": true,
    },
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
                      "BİLDİRİMLER",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildNotificationContainer(),
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

  Widget buildNotificationContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade300,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.shade100.withOpacity(0.5),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "Son Bildirimler",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...bildirimler.map((bildirim) => buildNotificationItem(bildirim)).toList(),
        ],
      ),
    );
  }

  Widget buildNotificationItem(Map<String, dynamic> bildirim) {
    Color tipRengi = bildirim['tip'] == 'acil'
        ? Colors.red.shade600
        : bildirim['tip'] == 'uyari'
        ? Colors.orange.shade600
        : bildirim['tip'] == 'sistem'
        ? Colors.blue.shade600
        : Colors.green.shade600;

    IconData tipIcon = bildirim['tip'] == 'acil'
        ? Icons.warning
        : bildirim['tip'] == 'uyari'
        ? Icons.info
        : bildirim['tip'] == 'sistem'
        ? Icons.system_update
        : Icons.notifications;

    return GestureDetector(
      onTap: () {
        setState(() {
          bildirim['okundu'] = true;
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.grey[100],
            title: Row(
              children: [
                Icon(tipIcon, color: tipRengi, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bildirim['baslik'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bildirim['mesaj']),
                const SizedBox(height: 12),
                Text(
                  bildirim['zaman'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: bildirim['okundu'] ? Colors.white.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tipRengi.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              tipIcon,
              color: tipRengi,
              size: 20,
            ),
          ),
          title: Text(
            bildirim['baslik'],
            style: TextStyle(
              fontWeight: bildirim['okundu'] ? FontWeight.w500 : FontWeight.bold,
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                bildirim['mesaj'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                bildirim['zaman'],
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          trailing: !bildirim['okundu']
              ? Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: tipRengi,
              shape: BoxShape.circle,
            ),
          )
              : null,
        ),
      ),
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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyContact())),
            ),
            navIcon(
              icon: Icons.home,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Homepage())),
            ),
            navIcon(
              icon: Icons.notifications,
              isActive: true,
              onTap: () {},
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