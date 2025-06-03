import 'package:afet_acil_durum_app/services/connectivity/check_connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/services/notifications/notification_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';
import 'package:afet_acil_durum_app/widgets/bell_widget.dart';
import 'package:afet_acil_durum_app/widgets/bottom_navigation_widget.dart';
import '../widgets/authority_login_dialog.dart';
import '../widgets/connectivity_card_widget.dart';
import '../widgets/dual_icon_row_widget.dart';
import '../widgets/emergency_card_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/location_card_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  String textField1 = '';
  String textField2 = '';

  final NotificationService _notificationService = NotificationService();
  final ConnectivityService _connectivityService = ConnectivityService();
  final CheckConnection _checkConnection = CheckConnection();

  // İlk bağlantı kontrolü tamamlandı mı?
  bool _initialConnectionCheckCompleted = false;
  bool _hasMobileConnection = false;
  bool isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _connectivityService.baslat();
  }

  Future<void> _initializeServices() async {
    // İlk olarak mobil bağlantı kontrolü yap
    _hasMobileConnection = await _checkConnection.checkMobileConnection();

    // Bağlantı servisini başlat

    // İlk kontrol tamamlandı olarak işaretle
    setState(() {
      _initialConnectionCheckCompleted = true;
    });

    // Bildirim servisini başlat
    await _initializeNotificationService();

    print('Mobil bağlantı durumu: $_hasMobileConnection');
  }

  @override
  void dispose() {
    if (_initialConnectionCheckCompleted) {
      _connectivityService.kapat();
    }
    super.dispose();
  }

  Future<void> _initializeNotificationService() async {
    try {
      await _notificationService.initNotification();
      print('Bildirim servisi başarıyla başlatıldı');
    } catch (e) {
      print('Bildirim servisi başlatılırken hata: $e');
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
            // Sabit header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child:  HeaderWidget(
                connectivityService: _connectivityService,
                onAuthorityTap: () {
                  AuthorityLoginDialog.show(context);
                },
              ),
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
                        color: themeController.isDarkMode ? Colors.white : Colors.grey[800],
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    EmergencyCardWidget(
                      onTap: () {},
                    ),
                    LocationCardWidget(),
                    ConnectivityCardWidget(connectivityService: _connectivityService),
                    DualIconRowWidget(),
                    const SizedBox(height: 32),
                    buildBigBell(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Sabit alt navigasyon
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(activePage: 'home'),

    );
  }

  Widget buildBigBell() {
    return BigBellWidget();
  }

  void _saveOfflineEmergencyRequest(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📴 Offline acil durum kaydı yapıldı'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}