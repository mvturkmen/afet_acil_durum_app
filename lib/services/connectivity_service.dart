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
  BaglantiDurumu _mevcutDurum = BaglantiDurumu.cevrimici;
  BaglantiTipi _mevcutTip = BaglantiTipi.yok;

  Stream<BaglantiDurumu> get baglantiStream => _baglantiController!.stream;
  BaglantiDurumu get mevcutDurum => _mevcutDurum;
  BaglantiTipi get mevcutTip => _mevcutTip;

  void baslat() {
    _baglantiController = StreamController<BaglantiDurumu>.broadcast();
    _connectivity.onConnectivityChanged.listen(_baglantiDegisti);
    _ilkKontrol();
  }

  void _ilkKontrol() async {
    final result = await _connectivity.checkConnectivity();
    _baglantiDegisti(result);
  }

  void _baglantiDegisti(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.none)) {
      _durumGuncelle(BaglantiDurumu.cevrimdisi, BaglantiTipi.yok);
      return;
    }

    // Bağlantı tipini belirle
    BaglantiTipi yeniTip = _baglantiTipiBelirle(result);

    // Gerçek internet kontrolü - daha güvenli
    final internetVar = await _internetKontrolGelismis();
    BaglantiDurumu yeniDurum = internetVar
        ? BaglantiDurumu.cevrimici
        : BaglantiDurumu.sinirli;

    _durumGuncelle(yeniDurum, yeniTip);
  }

  BaglantiTipi _baglantiTipiBelirle(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi)) {
      return BaglantiTipi.wifi;
    } else if (result.contains(ConnectivityResult.mobile)) {
      return BaglantiTipi.mobilVeri;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return BaglantiTipi.ethernet;
    } else if (result.contains(ConnectivityResult.bluetooth)) {
      return BaglantiTipi.bluetooth;
    } else if (result.contains(ConnectivityResult.vpn)) {
      return BaglantiTipi.vpn;
    } else {
      return BaglantiTipi.yok;
    }
  }

  void _durumGuncelle(BaglantiDurumu durum, BaglantiTipi tip) {
    _mevcutDurum = durum;
    _mevcutTip = tip;
    _baglantiController?.add(durum);
  }

  // Gelişmiş internet kontrol metodu
  Future<bool> _internetKontrolGelismis() async {
    try {
      // Birden fazla endpoint dene
      final List<String> testUrls = [
        'https://www.google.com',
        'https://8.8.8.8', // Google DNS
        'https://1.1.1.1', // Cloudflare DNS
      ];

      for (String url in testUrls) {
        try {
          final response = await http.get(
            Uri.parse(url),
          ).timeout(const Duration(seconds: 3));

          if (response.statusCode == 200) {
            return true;
          }
        } catch (e) {
          print('URL kontrol hatası ($url): $e');
          continue; // Bir sonraki URL'yi dene
        }
      }

      return false;
    } catch (e) {
      print('Genel internet kontrol hatası: $e');
      return false;
    }
  }

  // Alternatif socket tabanlı kontrol
  Future<bool> _socketKontrol() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      print('Socket kontrol hatası: $e');
      return false;
    }
  }

  // Gelişmiş internet kontrolü (socket + http kombinasyonu)
  Future<bool> _internetKontrol() async {
    try {
      // Önce socket kontrolü yap (daha hızlı)
      bool socketResult = await _socketKontrol();
      if (!socketResult) {
        return false;
      }

      // Socket başarılıysa HTTP kontrolü yap
      return await _internetKontrolGelismis();
    } catch (e) {
      print('İnternet kontrol hatası: $e');
      return false;
    }
  }

  // Acil durum için özel kontrol
  Future<bool> acilDurumBaglantisiVar() async {
    final durum = _mevcutDurum;
    return durum == BaglantiDurumu.cevrimici || durum == BaglantiDurumu.sinirli;
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
    _baglantiController?.close();
  }
}