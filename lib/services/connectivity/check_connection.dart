import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';

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