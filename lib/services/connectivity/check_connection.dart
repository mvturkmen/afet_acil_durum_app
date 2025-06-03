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

class CheckConnection {
  late ConnectivityService _connectivityService = ConnectivityService();

  Future<bool> checkMobileConnection() async {
  try {
    // Bağlantı tipi mobil veri mi?
    if (ConnectivityService().mevcutTip == BaglantiTipi.mobilVeri) {
      // Çevrimiçi ya da sınırlı bağlantı varsa mobil veri var sayılır
      if (ConnectivityService().mevcutDurum == BaglantiDurumu.cevrimici ||
          ConnectivityService().mevcutDurum == BaglantiDurumu.sinirli) {
        return true;
      }

      // Anlık durumu tekrar kontrol et (internet erişimi var mı?)
      final internetVarMi = await ConnectivityService().acilDurumBaglantisiVar();
      return internetVarMi;
    }

    return false; // Mobil veri değilse
  } catch (e) {
    print('Mobil bağlantı kontrol hatası: $e');
    return false;
  }
}
}