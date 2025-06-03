import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

enum BaglantiDurumu {
  cevrimici,
  cevrimdisi,
  sinirli,
}

enum BaglantiTipi {
  wifi,
  mobilVeri,
  ethernet,
  bluetooth,
  vpn,
  yok,
}

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamController<BaglantiDurumu>? _baglantiController;
  StreamController<BaglantiTipi>? _baglantiTipiController;
  BaglantiDurumu _mevcutDurum = BaglantiDurumu.cevrimdisi;
  BaglantiTipi _mevcutTip = BaglantiTipi.yok;
  StreamSubscription? _connectivitySubscription;
  Timer? _periodicTimer;
  bool _ilkKontrolTamamlandi = false;

  // Getters
  Stream<BaglantiDurumu>? get baglantiStream => _baglantiController?.stream;
  Stream<BaglantiTipi>? get baglantiTipiStream => _baglantiTipiController?.stream;
  BaglantiDurumu get mevcutDurum => _mevcutDurum;
  BaglantiTipi get mevcutTip => _mevcutTip;

  void baslat() {
    // Eğer zaten başlatılmışsa önce temizle
    kapat();

    _baglantiController = StreamController<BaglantiDurumu>.broadcast();
    _baglantiTipiController = StreamController<BaglantiTipi>.broadcast();
    _ilkKontrolTamamlandi = false;

    // İlk kontrol - biraz gecikme ile
    _gecikmeliIlkKontrol();

    // Connectivity değişimlerini dinle
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _baglantiDegisti,
      onError: (error) {
        print('Connectivity stream hatası: $error');
        _durumGuncelle(BaglantiDurumu.cevrimdisi, BaglantiTipi.yok);
      },
    );

    // Periyodik kontrol (her 10 saniyede bir)
    _periodicTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _periyodikKontrol();
    });
  }

  void _gecikmeliIlkKontrol() async {
    // Kısa bir gecikme ile başlat - sistem hazır olsun diye
    await Future.delayed(Duration(milliseconds: 500));

    try {
      // Birden fazla deneme yap
      for (int i = 0; i < 3; i++) {
        try {
          final result = await _connectivity.checkConnectivity();
          print('İlk kontrol denemesi ${i + 1}: $result');

          if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
            await _baglantiDegisti(result);
            _ilkKontrolTamamlandi = true;
            break;
          }

          // Eğer sonuç boş veya none ise kısa bir bekleme
          if (i < 2) {
            await Future.delayed(Duration(milliseconds: 1000));
          }
        } catch (e) {
          print('İlk kontrol denemesi ${i + 1} hatası: $e');
          if (i < 2) {
            await Future.delayed(Duration(milliseconds: 1000));
          }
        }
      }

      // Hala başarısız olduysa varsayılan durumu ayarla
      if (!_ilkKontrolTamamlandi) {
        print('İlk kontrol başarısız, varsayılan durum ayarlanıyor');
        _durumGuncelle(BaglantiDurumu.cevrimdisi, BaglantiTipi.yok);
        _ilkKontrolTamamlandi = true;
      }
    } catch (e) {
      print('İlk kontrol genel hatası: $e');
      _durumGuncelle(BaglantiDurumu.cevrimdisi, BaglantiTipi.yok);
      _ilkKontrolTamamlandi = true;
    }
  }

  void _periyodikKontrol() async {
    try {
      final result = await _connectivity.checkConnectivity();
      await _baglantiDegisti(result);
    } catch (e) {
      print('Periyodik kontrol hatası: $e');
    }
  }

  Future<void> _baglantiDegisti(List<ConnectivityResult> result) async {
    try {
      print('Bağlantı değişikliği algılandı: $result');

      // Bağlantı yoksa
      if (result.isEmpty || result.contains(ConnectivityResult.none)) {
        _durumGuncelle(BaglantiDurumu.cevrimdisi, BaglantiTipi.yok);
        return;
      }

      // Bağlantı tipini belirle
      BaglantiTipi yeniTip = _baglantiTipiBelirle(result);

      // Internet erişimi kontrolü - ilk kontrol için daha uzun timeout
      final timeoutDuration = _ilkKontrolTamamlandi
          ? Duration(seconds: 3)
          : Duration(seconds: 5);

      final internetVar = await _hizliInternetKontrol(timeoutDuration);
      BaglantiDurumu yeniDurum;

      if (internetVar) {
        yeniDurum = BaglantiDurumu.cevrimici;
      } else {
        // Bağlantı var ama internet yok - tekrar dene
        await Future.delayed(Duration(milliseconds: 500));
        final tekrarKontrol = await _hizliInternetKontrol(Duration(seconds: 2));
        yeniDurum = tekrarKontrol ? BaglantiDurumu.cevrimici : BaglantiDurumu.sinirli;
      }

      _durumGuncelle(yeniDurum, yeniTip);
    } catch (e) {
      print('Bağlantı değişiklik hatası: $e');
      _durumGuncelle(BaglantiDurumu.cevrimdisi, BaglantiTipi.yok);
    }
  }

  BaglantiTipi _baglantiTipiBelirle(List<ConnectivityResult> result) {
    // Öncelik sırasına göre kontrol et
    if (result.contains(ConnectivityResult.wifi)) {
      return BaglantiTipi.wifi;
    } else if (result.contains(ConnectivityResult.mobile)) {
      return BaglantiTipi.mobilVeri;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return BaglantiTipi.ethernet;
    } else if (result.contains(ConnectivityResult.vpn)) {
      return BaglantiTipi.vpn;
    } else if (result.contains(ConnectivityResult.bluetooth)) {
      return BaglantiTipi.bluetooth;
    } else {
      return BaglantiTipi.yok;
    }
  }

  void _durumGuncelle(BaglantiDurumu durum, BaglantiTipi tip) {
    bool durumDegisti = _mevcutDurum != durum;
    bool tipDegisti = _mevcutTip != tip;

    _mevcutDurum = durum;
    _mevcutTip = tip;

    // Sadece değişim varsa stream'e bildir
    if (durumDegisti && _baglantiController != null && !_baglantiController!.isClosed) {
      _baglantiController!.add(durum);
    }

    if (tipDegisti && _baglantiTipiController != null && !_baglantiTipiController!.isClosed) {
      _baglantiTipiController!.add(tip);
    }

    // Debug için
    if (durumDegisti || tipDegisti) {
      print('Bağlantı güncellendi: ${baglantiDurumuMetni()} - ${baglantiTipiMetni()}');
    }
  }

  // Hızlı internet kontrolü (özelleştirilebilir timeout)
  Future<bool> _hizliInternetKontrol([Duration? timeout]) async {
    final timeoutDuration = timeout ?? Duration(seconds: 3);

    try {
      final response = await http.get(
        Uri.parse('https://www.google.com'),
      ).timeout(timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      // Google erişilemiyorsa DNS kontrol dene
      return await _dnsKontrol();
    }
  }

  // DNS kontrolü
  Future<bool> _dnsKontrol() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 2));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Acil durum için bağlantı kontrolü
  Future<bool> acilDurumBaglantisiVar() async {
    try {
      // Mevcut durumu kontrol et
      if (_mevcutDurum == BaglantiDurumu.cevrimici) {
        return true;
      }

      // Sınırlı bağlantıda da acil durum mesajı gönderilebilir
      if (_mevcutDurum == BaglantiDurumu.sinirli) {
        return true;
      }

      // Son bir kontrol daha yap
      final result = await _connectivity.checkConnectivity();
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        return await _hizliInternetKontrol();
      }

      return false;
    } catch (e) {
      print('Acil durum bağlantı kontrol hatası: $e');
      return false;
    }
  }

  // Anlık durum kontrolü
  Future<void> durumKontrolEt() async {
    try {
      final result = await _connectivity.checkConnectivity();
      await _baglantiDegisti(result);
    } catch (e) {
      print('Durum kontrol hatası: $e');
    }
  }

  String baglantiDurumuMetni() {
    switch (_mevcutDurum) {
      case BaglantiDurumu.cevrimici:
        return 'Çevrimiçi';
      case BaglantiDurumu.sinirli:
        return 'Sınırlı Bağlantı';
      case BaglantiDurumu.cevrimdisi:
        return 'Çevrimdışı';
    }
  }

  String baglantiTipiMetni() {
    switch (_mevcutTip) {
      case BaglantiTipi.wifi:
        return 'Wi-Fi';
      case BaglantiTipi.mobilVeri:
        return 'Mobil Veri';
      case BaglantiTipi.ethernet:
        return 'Ethernet';
      case BaglantiTipi.bluetooth:
        return 'Bluetooth';
      case BaglantiTipi.vpn:
        return 'VPN';
      case BaglantiTipi.yok:
        return 'Bağlantı Yok';
    }
  }

  Color baglantiRengi() {
    switch (_mevcutDurum) {
      case BaglantiDurumu.cevrimici:
        return Colors.green;
      case BaglantiDurumu.sinirli:
        return Colors.orange;
      case BaglantiDurumu.cevrimdisi:
        return Colors.red;
    }
  }

  IconData baglantiIkonu() {
    switch (_mevcutTip) {
      case BaglantiTipi.wifi:
        return Icons.wifi;
      case BaglantiTipi.mobilVeri:
        return Icons.signal_cellular_alt;
      case BaglantiTipi.ethernet:
        return Icons.desktop_windows;
      case BaglantiTipi.bluetooth:
        return Icons.bluetooth;
      case BaglantiTipi.vpn:
        return Icons.vpn_lock;
      case BaglantiTipi.yok:
        return Icons.signal_wifi_off;
    }
  }

  void kapat() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    _periodicTimer?.cancel();
    _periodicTimer = null;

    _baglantiController?.close();
    _baglantiController = null;

    _baglantiTipiController?.close();
    _baglantiTipiController = null;

    _ilkKontrolTamamlandi = false;
  }
}