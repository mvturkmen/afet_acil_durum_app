import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/services/notifications/notification_service.dart';
import 'package:afet_acil_durum_app/services/location_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class ShowNotification {

  bool istrue = false;
  late ConnectivityService _connectivityService = ConnectivityService();
  late NotificationService _notificationService = NotificationService();


  void sendLocationNotification() async {


    await _notificationService.showNotification(
      id: 2,
      title: '📍 Konum Paylaşıldı',

    );
  }

  Future<void> sendFlashlightNotification(bool isTurnOn) async {

    if (isTurnOn) {
      await _notificationService.showNotification(
        id: 3,
        title: '🔦 El Feneri',
        body: 'El feneri özelliği aktif edildi.',
      );
    } else {
      await _notificationService.showNotification(
        id: 3,
        title: '🔦 El Feneri',
        body: 'El feneri özelliği kapatıldı.',
      );
    }
  }



  Future<void> sendAlarmNotification() async {


    await _notificationService.showNotification(
      id: 5,
      title: '🔔 ALARM!',
      body: 'Genel alarm sistemi aktif edildi.',
    );
  }

  Future<void> sendWhistleNotification() async {


    await _notificationService.showNotification(
      id: 4,
      title: '📢 Düdük Sesi',
      body: 'Acil durum düdük sesi çalınıyor.',
    );
  }

}