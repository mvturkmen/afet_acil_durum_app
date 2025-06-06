import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';
import 'package:afet_acil_durum_app/widgets/bell_widget.dart';
import 'package:afet_acil_durum_app/widgets/bottom_navigation_widget.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> {
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [

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
                        color: isDark ? Colors.white70 : Colors.grey[800],
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildNotificationContainer(isDark),
                    const SizedBox(height: 32),
                    buildBigBell(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(activePage: 'notifications'),

    );
  }


  Widget buildNotificationContainer(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.blueGrey.shade900 : Colors.blueGrey.shade300,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade100).withOpacity(0.5),
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
          ...bildirimler.map((bildirim) => buildNotificationItem(bildirim, isDark)).toList(),
        ],
      ),
    );
  }

  Widget buildNotificationItem(Map<String, dynamic> bildirim, bool isDark) {
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
            backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
            title: Row(
              children: [
                Icon(tipIcon, color: tipRengi, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bildirim['baslik'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bildirim['mesaj'],
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[800]),
                ),
                const SizedBox(height: 12),
                Text(
                  bildirim['zaman'],
                  style: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey.shade700,
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
          color: bildirim['okundu']
              ? (isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.7))
              : (isDark ? Colors.white.withOpacity(0.15) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.black12,
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
              color: isDark ? Colors.white70 : Colors.grey[800],
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
                  color: isDark ? Colors.white54 : Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                bildirim['zaman'],
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white38 : Colors.grey[500],
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

  Widget buildBigBell() {
    return BigBellWidget();
  }
 }