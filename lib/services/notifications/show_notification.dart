import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/services/notifications/notification_service.dart';

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


  Future<void> sendFlashlightNotification(bool isTurchOn) async {

    if (isTurchOn) {

      await _notificationService.showNotification(
        id: 3,
        title: '🔦 El Feneri',
        body: 'El feneri özelliği kapatıldı.',
      );
    } else {
      await _notificationService.showNotification(
        id: 3,
        title: '🔦 El Feneri',
        body: 'El feneri özelliği aktif edildi.',
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