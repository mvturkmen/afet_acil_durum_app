import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/services/notiService.dart';
import 'package:afet_acil_durum_app/services/location_service.dart';
import 'package:afet_acil_durum_app/services/connectivity_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  String textField1 = '';
  String textField2 = '';

  final NotiService _notiService = NotiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  @override
  void dispose() {
    _connectivityService.kapat();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      await _initializeNotificationService();
      _connectivityService.baslat();
      print('Servisler başarıyla başlatıldı');
    } catch (e) {
      print('Servisler başlatılırken hata: $e');
    }
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
                      "YARDIM ÇAĞIR",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildEmergencyCard(),
                    buildLocationCard(),
                    buildConnectivityCard(),
                    buildDualIconRow(),
                    const SizedBox(height: 32),
                    buildBigBell(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _showAuthorityLoginPopup();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade600, Colors.indigo.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.shade200.withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Yetkili',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

        StreamBuilder<BaglantiDurumu>(
          stream: _connectivityService.baglantiStream,
          initialData: _connectivityService.mevcutDurum,
          builder: (context, snapshot) {
            return Container(
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
            );
          },
        ),
      ],
    );
  }

  Widget buildConnectivityCard() {
    return StreamBuilder<BaglantiDurumu>(
      stream: _connectivityService.baglantiStream,
      initialData: _connectivityService.mevcutDurum,
      builder: (context, snapshot) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _connectivityService.baglantiRengi().withOpacity(0.1),
            border: Border.all(
              color: _connectivityService.baglantiRengi().withOpacity(0.3),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _connectivityService.baglantiRengi().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _connectivityService.baglantiIkonu(),
                  color: _connectivityService.baglantiRengi(),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bağlantı Durumu',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_connectivityService.baglantiDurumuMetni()} - ${_connectivityService.baglantiTipiMetni()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: _connectivityService.baglantiRengi(),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildEmergencyCard() {
    return GestureDetector(
      onTap: () async {
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
        height: 80,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.red.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade200.withOpacity(0.5),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.network(
              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/gol3gopo_expires_30_days.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Hızlı Yardım",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
        MyPosition? position = await LocationService().getCurrentLocation();
        if (position != null) {
          String address = await LocationService().getAddressFromPosition(position);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Konum Bilgisi'),
              content: Text(
                '📍 Enlem: ${position.latitude}, Boylam: ${position.longitude}\n\n📫 Adres: $address',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Konum alınamadı.")),
          );
        }
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueGrey.shade300,
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
            Image.network(
              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/8ha6n32n_expires_30_days.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Konumumu Göster",
                style: TextStyle(
                  color: Colors.white70,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDualIconRow() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await _sendFlashlightNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('El feneri bildirimi gönderildi!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                height: 80,
                margin: const EdgeInsets.only(right: 8),
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
                child: Center(
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/fp9cumfa_expires_30_days.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await _sendWhistleNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Düdük bildirimi gönderildi!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                height: 80,
                margin: const EdgeInsets.only(left: 8),
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
                child: Center(
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/vixwrgce_expires_30_days.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBigBell() {
    return Center(
      child: GestureDetector(
        onTap: () async {
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
              isActive: true,
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


  void _showAuthorityLoginPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Yetkili Girişi",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Acil durum yönetim paneline erişim için giriş yapın",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı",
                    prefixIcon: Icon(Icons.person, color: Colors.indigo.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.indigo.shade600, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    prefixIcon: Icon(Icons.lock, color: Colors.indigo.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.indigo.shade600, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                        child: Text(
                          "İptal",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Yetkili girişi yapıldı!'),
                              backgroundColor: Colors.indigo,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          "Giriş Yap",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendEmergencyNotification() async {
    bool hasConnection = await _connectivityService.acilDurumBaglantisiVar();

    if (!_notiService.isInitialized) {
      await _initializeNotificationService();
    }

    String title = '🚨 ACİL DURUM!';
    String body = hasConnection
        ? 'Acil yardım talebi gönderildi. En yakın yardım ekipleri bilgilendirildi.'
        : 'Acil yardım talebi kaydedildi. Bağlantı kurulduğunda gönderilecek.';

    await _notiService.showNotification(
      id: 1,
      title: title,
      body: body,
    );

    if (!hasConnection) {
      _saveOfflineEmergencyRequest();
    }
  }

  Future<void> _sendLocationNotification() async {
    bool hasConnection = await _connectivityService.acilDurumBaglantisiVar();

    if (!_notiService.isInitialized) {
      await _initializeNotificationService();
    }

    String body = hasConnection
        ? 'Konumunuz acil durum ekipleriyle paylaşıldı.'
        : 'Konum bilgisi kaydedildi. Bağlantı kurulduğunda paylaşılacak.';

    await _notiService.showNotification(
      id: 2,
      title: '📍 Konum Paylaşıldı',
      body: body,
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

  void _saveOfflineEmergencyRequest() {
    print('Offline acil durum kaydı yapıldı');
  }
}