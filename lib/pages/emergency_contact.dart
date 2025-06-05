import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/notifications.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

import '../widgets/bell_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/header_widget.dart';
// Veritabanı servisi için import ekleyin
// import 'package:afet_acil_durum_app/services/database_service.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  EmergencyContactState createState() => EmergencyContactState();
}

class EmergencyContactState extends State<EmergencyContact> {
  // Arama için controller
  final TextEditingController _searchController = TextEditingController();

  // Veritabanından çekilecek tüm kişiler
  List<Map<String, dynamic>> tumKisiler = [];

  // Filtrelenmiş kişiler (arama sonucu)
  List<Map<String, dynamic>> filtrelenmisKisiler = [];

  // Acil durum kişileri
  List<Map<String, dynamic>> acilDurumKisileri = [];

  final ConnectivityService _connectivityService = ConnectivityService();

  // Loading state
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Veritabanından verileri yükle
  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Burada gerçek veritabanı servisinizi kullanın
      // final dbService = DatabaseService();
      // tumKisiler = await dbService.getAllPersons();
      // acilDurumKisileri = await dbService.getEmergencyContacts();

      // Örnek veri (gerçek implementasyonda kaldırın)
      await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay
      tumKisiler = [
        {
          "id": 1,
          "isim": "Ahmet Yılmaz",
          "telefon": "0555 123 4567",
          "adres": "İstanbul, Kadıköy",
          "email": "ahmet@email.com"
        },
        {
          "id": 2,
          "isim": "Mehmet Kaya",
          "telefon": "0555 987 6543",
          "adres": "Ankara, Çankaya",
          "email": "mehmet@email.com"
        },
        {
          "id": 3,
          "isim": "Zeynep Demir",
          "telefon": "0555 345 6789",
          "adres": "İzmir, Karşıyaka",
          "email": "zeynep@email.com"
        },
        {
          "id": 4,
          "isim": "Fatma Özkan",
          "telefon": "0555 111 2233",
          "adres": "Bursa, Nilüfer",
          "email": "fatma@email.com"
        },
        {
          "id": 5,
          "isim": "Ali Çelik",
          "telefon": "0555 444 5566",
          "adres": "Antalya, Muratpaşa",
          "email": "ali@email.com"
        },
      ];

      acilDurumKisileri = [
        {
          "id": 1,
          "isim": "Ahmet Yılmaz",
          "telefon": "0555 123 4567",
          "adres": "İstanbul, Kadıköy",
          "email": "ahmet@email.com"
        },
      ];

      // Acil durum kişilerini hariç tutarak filtrelenmiş listeyi oluştur
      final acilDurumIdleri = acilDurumKisileri.map((kisi) => kisi['id']).toSet();
      filtrelenmisKisiler = tumKisiler.where((kisi) => !acilDurumIdleri.contains(kisi['id'])).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veriler yüklenirken hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Arama fonksiyonu
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // Acil durum kişilerini hariç tut
      final acilDurumIdleri = acilDurumKisileri.map((kisi) => kisi['id']).toSet();
      final acilDurumOlmayanKisiler = tumKisiler.where((kisi) => !acilDurumIdleri.contains(kisi['id'])).toList();

      if (query.isEmpty) {
        filtrelenmisKisiler = acilDurumOlmayanKisiler;
      } else {
        filtrelenmisKisiler = acilDurumOlmayanKisiler.where((kisi) {
          final isim = kisi['isim'].toString().toLowerCase();
          final telefon = kisi['telefon'].toString().toLowerCase();
          return isim.contains(query) || telefon.contains(query);
        }).toList();
      }
    });
  }

  // Acil durum kişisi olarak ata
  Future<void> _setAsEmergencyContact(Map<String, dynamic> kisi) async {
    try {
      // Burada veritabanına kaydetme işlemi yapın
      // final dbService = DatabaseService();
      // await dbService.addEmergencyContact(kisi['id']);

      // Örnek implementasyon
      if (!acilDurumKisileri.any((item) => item['id'] == kisi['id'])) {
        setState(() {
          acilDurumKisileri.add(kisi);
          // Filtrelenmiş listeden çıkar
          filtrelenmisKisiler.removeWhere((item) => item['id'] == kisi['id']);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${kisi['isim']} acil durum kişisi olarak eklendi!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bu kişi zaten acil durum kişisi olarak ekli!'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Acil durum kişisini kaldır
  Future<void> _removeEmergencyContact(Map<String, dynamic> kisi) async {
    try {
      // final dbService = DatabaseService();
      // await dbService.removeEmergencyContact(kisi['id']);

      setState(() {
        acilDurumKisileri.removeWhere((item) => item['id'] == kisi['id']);
        // Kişiyi tüm kişiler listesine geri ekle
        if (!filtrelenmisKisiler.any((item) => item['id'] == kisi['id'])) {
          // Arama kriterine göre kontrol et
          final query = _searchController.text.toLowerCase();
          if (query.isEmpty) {
            filtrelenmisKisiler.add(kisi);
          } else {
            final isim = kisi['isim'].toString().toLowerCase();
            final telefon = kisi['telefon'].toString().toLowerCase();
            if (isim.contains(query) || telefon.contains(query)) {
              filtrelenmisKisiler.add(kisi);
            }
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${kisi['isim']} acil durum kişilerinden çıkarıldı!'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: HeaderWidget(
              connectivityService: _connectivityService,
              onAuthorityTap: () {}
            ),
          ),

            // Arama çubuğu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: buildSearchBar(isDark),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Acil Durum Kişileri Bölümü
                    if (acilDurumKisileri.isNotEmpty) ...[
                      Text(
                        "ACİL DURUM KİŞİLERİ",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.grey[800],
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildEmergencyContactsList(isDark),
                      const SizedBox(height: 32),

                      const SizedBox(height: 32),
                    ],

                    // Tüm Kişiler Bölümü
                    Text(
                      "TÜM KİŞİLER",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.grey[800],
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildAllContactsList(isDark),
                    const SizedBox(height: 24),
                    buildBigBell(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(activePage: 'contacts'),

    );
  }

  Widget buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Kişi ara...',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget buildEmergencyContactsList(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: acilDurumKisileri.length,
      itemBuilder: (context, index) {
        final kisi = acilDurumKisileri[index];
        return buildContactCard(kisi, isDark, isEmergencyContact: true);
      },
    );
  }

  Widget buildAllContactsList(bool isDark) {
    if (filtrelenmisKisiler.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aradığınız kriterlere uygun kişi bulunamadı',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtrelenmisKisiler.length,
      itemBuilder: (context, index) {
        final kisi = filtrelenmisKisiler[index];
        return buildContactCard(kisi, isDark, isEmergencyContact: false);
      },
    );
  }

  Widget buildContactCard(Map<String, dynamic> kisi, bool isDark, {bool isEmergencyContact = false}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
            title: Text(
              kisi['isim']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey[800],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone, color: isDark ? Colors.white70 : Colors.blueGrey.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text("${kisi['telefon']}", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: isDark ? Colors.white70 : Colors.blueGrey.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text("${kisi['adres']}", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87))),
                  ],
                ),
                if (kisi['email'] != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.email, color: isDark ? Colors.white70 : Colors.blueGrey.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text("${kisi['email']}", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87))),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : Colors.blueGrey.shade700,
                ),
                child: const Text("Kapat", style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isEmergencyContact
              ? (isDark ? Colors.red.shade800 : Colors.red.shade100)
              : (isDark ? Colors.blueGrey.shade700 : Colors.blueGrey.shade300),
          borderRadius: BorderRadius.circular(20),
          border: isEmergencyContact
              ? Border.all(color: Colors.red.shade400, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : Colors.blueGrey.shade100.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isEmergencyContact
                    ? Colors.red.shade600.withOpacity(0.2)
                    : (isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEmergencyContact ? Icons.priority_high : Icons.person,
                size: 30,
                color: isEmergencyContact ? Colors.red.shade300 : Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          kisi['isim']!,
                          style: TextStyle(
                            color: isEmergencyContact
                                ? (isDark ? Colors.red.shade100 : Colors.red.shade800)
                                : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black26,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isEmergencyContact)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'ACİL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kisi['telefon']!,
                    style: TextStyle(
                      color: isEmergencyContact
                          ? (isDark ? Colors.red.shade200 : Colors.red.shade700)
                          : Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Acil durum butonu
            GestureDetector(
              onTap: () {
                if (isEmergencyContact) {
                  _removeEmergencyContact(kisi);
                } else {
                  _setAsEmergencyContact(kisi);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isEmergencyContact ? Colors.orange.shade600 : Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isEmergencyContact ? Icons.remove_circle : Icons.add_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBigBell() {
    return BigBellWidget();
  }
}