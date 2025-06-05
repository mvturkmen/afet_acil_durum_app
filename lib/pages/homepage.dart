import 'package:afet_acil_durum_app/services/connectivity/check_connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/services/notifications/notification_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';
import 'package:afet_acil_durum_app/widgets/authority_login_dialog.dart';
import 'package:afet_acil_durum_app/widgets/bell_widget.dart';
import 'package:afet_acil_durum_app/widgets/bottom_navigation_widget.dart';
import 'package:afet_acil_durum_app/widgets/connectivity_card_widget.dart';
import 'package:afet_acil_durum_app/widgets/dual_icon_row_widget.dart';
import 'package:afet_acil_durum_app/widgets/emergency_card_widget.dart';
import 'package:afet_acil_durum_app/widgets/header_widget.dart';
import 'package:afet_acil_durum_app/widgets/location_card_widget.dart';

import '../widgets/voice_message_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  String textField1 = '';
  String textField2 = '';

  final NotificationService _notificationService = NotificationService();
  final CheckConnection _checkConnection = CheckConnection();

  bool _initialConnectionCheckCompleted = false;
  bool _hasMobileConnection = false;
  bool isTorchOn = false;

  late final ConnectivityService _connectivityService;

  @override
  void initState() {
    super.initState();
    _connectivityService = Provider.of<ConnectivityService>(context, listen: false);
    _initializeServices();
  }


  Future<void> _initializeServices() async {
    _hasMobileConnection = await _checkConnection.checkMobileConnection();

    setState(() {
      _initialConnectionCheckCompleted = true;
    });

    await _initializeNotificationService();

    print('Mobil bağlantı durumu: $_hasMobileConnection');
  }

  @override
  void dispose() {
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: HeaderWidget(
                connectivityService: _connectivityService,
                onAuthorityTap: () {
                  AuthorityLoginDialog.show(context);
                },
              ),
            ),
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
                    VoiceMessageWidget(),
                    LocationCardWidget(),
                    ConnectivityCardWidget(
                      connectivityService: Provider.of<ConnectivityService>(context, listen: false),
                    ),
                    DualIconRowWidget(),
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