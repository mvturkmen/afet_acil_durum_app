import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/notifications.dart';
import 'package:afet_acil_durum_app/pages/map.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/bell_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final String _baseUrl = 'https://4495-149-86-144-194.ngrok-free.app';

  // Form controller'ları
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _relationshipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("\n\n=== EMERGENCY CONTACT PAGE INITIALIZED ===");
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  // Veritabanından verileri yükle
  Future<void> _loadData() async {
    print("\n\n=== LOADING EMERGENCY CONTACTS DATA ===");
    setState(() {
      isLoading = true;
    });

    try {
      // SharedPreferences'dan token ve user ID'yi al
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');

      print("\n=== USER INFO ===");
      print("User ID: $userId");
      print("Token: ${token?.substring(0, 20)}...");

      if (token == null || userId == null) {
        print("ERROR: Token or User ID is null!");
        throw Exception('Token veya User ID bulunamadı');
      }

      // API çağrısı
      final emergencyUrl = '$_baseUrl/api/users/$userId/emergency-contacts';
      print("\n=== EMERGENCY CONTACTS API CALL ===");
      print("URL: $emergencyUrl");

      final response = await http.get(
        Uri.parse(emergencyUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("\n=== EMERGENCY CONTACTS RESPONSE ===");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("\n=== PARSING EMERGENCY CONTACTS ===");
        print("Raw Data: $data");

        setState(() {
          acilDurumKisileri = data.map((item) {
            print("Processing item: $item");
            return {
              'id': item['id'] ?? item['Id'] ?? item['ID'] ?? 0,
              'isim': item['name'] ?? item['Name'] ?? item['NAME'] ?? '',
              'telefon': item['phone'] ?? item['Phone'] ?? item['PHONE'] ?? '',
              'adres': item['address'] ?? item['Address'] ?? item['ADDRESS'] ?? '',
              'email': item['email'] ?? item['Email'] ?? item['EMAIL'] ?? '',
              'isDeleted': item['isDeleted'] ?? false,
            };
          }).where((item) => !(item['isDeleted'] ?? false)).toList();
        });
        print("\n=== TRANSFORMED EMERGENCY CONTACTS ===");
        print("Final List: $acilDurumKisileri");
      } else if (response.statusCode == 401) {
        print("ERROR: Unauthorized - Token expired");
        throw Exception('Oturum süresi dolmuş. Lütfen tekrar giriş yapın.');
      } else {
        print("ERROR: API returned status code ${response.statusCode}");
        throw Exception('API Hatası: ${response.statusCode}');
      }
    } catch (e) {
      print("\n=== ERROR OCCURRED ===");
      print("Error details: $e");
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
      print("\n=== DATA LOADING COMPLETED ===");
    }
  }

  // Acil durum kişisi olarak ata
  Future<void> _setAsEmergencyContact(Map<String, dynamic> kisi) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token veya User ID bulunamadı');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/api/users/$userId/emergency-contacts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'contactId': kisi['id']}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          acilDurumKisileri.add(kisi);
          filtrelenmisKisiler.removeWhere((item) => item['id'] == kisi['id']);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${kisi['isim']} acil durum kişisi olarak eklendi!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (response.statusCode == 401) {
        throw Exception('Oturum süresi dolmuş. Lütfen tekrar giriş yapın.');
      } else {
        throw Exception('API Hatası: ${response.statusCode}');
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
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token veya User ID bulunamadı');
      }

      print("\n=== REMOVING EMERGENCY CONTACT ===");
      print("User ID: $userId");
      print("Contact ID: ${kisi['id']}");

      final response = await http.delete(
        Uri.parse('$_baseUrl/api/users/$userId/emergency-contacts/${kisi['id']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          acilDurumKisileri.removeWhere((item) => item['id'] == kisi['id']);
          // Kişiyi tüm kişiler listesine geri ekle
          if (!filtrelenmisKisiler.any((item) => item['id'] == kisi['id'])) {
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
      } else if (response.statusCode == 401) {
        throw Exception('Oturum süresi dolmuş. Lütfen tekrar giriş yapın.');
      } else {
        throw Exception('API Hatası: ${response.statusCode}');
      }
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Yeni acil durum kişisi ekleme
  Future<void> _addNewEmergencyContact() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token veya User ID bulunamadı');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/api/users/$userId/emergency-contacts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': _nameController.text,
          'surname': _surnameController.text,
          'phoneNumber': _phoneController.text,
          'email': _emailController.text,
          'relationship': _relationshipController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Form alanlarını temizle
        _nameController.clear();
        _surnameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _relationshipController.clear();

        // Verileri yeniden yükle
        await _loadData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acil durum kişisi başarıyla eklendi'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('API Hatası: ${response.statusCode}');
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

  // Acil durum kişisini güncelle
  Future<void> _updateEmergencyContact(Map<String, dynamic> kisi) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token veya User ID bulunamadı');
      }

      print("\n=== UPDATING EMERGENCY CONTACT ===");
      print("User ID: $userId");
      print("Contact ID: ${kisi['id']}");
      print("Updated Data: ${json.encode({
        'name': _nameController.text,
        'surname': _surnameController.text,
        'phoneNumber': _phoneController.text,
        'email': _emailController.text,
        'relationship': _relationshipController.text,
      })}");

      final response = await http.put(
        Uri.parse('$_baseUrl/api/users/$userId/emergency-contacts/${kisi['id']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': _nameController.text,
          'surname': _surnameController.text,
          'phoneNumber': _phoneController.text,
          'email': _emailController.text,
          'relationship': _relationshipController.text,
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Form alanlarını temizle
        _nameController.clear();
        _surnameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _relationshipController.clear();

        // Verileri yeniden yükle
        await _loadData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acil durum kişisi başarıyla güncellendi'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.statusCode == 401) {
        throw Exception('Oturum süresi dolmuş. Lütfen tekrar giriş yapın.');
      } else {
        throw Exception('API Hatası: ${response.statusCode}');
      }
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Silme işlemi için onay dialog'u
  void _showDeleteConfirmationDialog(Map<String, dynamic> kisi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acil Durum Kişisini Kaldır'),
        content: Text('${kisi['isim']} isimli kişiyi acil durum kişilerinden kaldırmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _removeEmergencyContact(kisi);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
  }

  // Güncelleme dialog'u
  void _showUpdateDialog(Map<String, dynamic> kisi) {
    // Mevcut değerleri form alanlarına doldur
    _nameController.text = kisi['isim'] ?? '';
    _surnameController.text = kisi['surname'] ?? '';
    _phoneController.text = kisi['telefon'] ?? '';
    _emailController.text = kisi['email'] ?? '';
    _relationshipController.text = kisi['relationship'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acil Durum Kişisini Güncelle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Soyad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon (+90...)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _relationshipController,
                decoration: const InputDecoration(
                  labelText: 'İlişki',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Form alanlarını temizle
              _nameController.clear();
              _surnameController.clear();
              _phoneController.clear();
              _emailController.clear();
              _relationshipController.clear();
              Navigator.pop(context);
            },
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateEmergencyContact(kisi);
            },
            child: const Text('Güncelle'),
          ),
        ],
      ),
    );
  }

  // Yeni kişi ekleme dialog'u
  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Yeni Acil Durum Kişisi Ekle'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Ad',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _surnameController,
                    decoration: const InputDecoration(
                      labelText: 'Soyad',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefon (+90...)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-posta',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _relationshipController,
                    decoration: const InputDecoration(
                      labelText: 'İlişki',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _addNewEmergencyContact();
                },
                child: const Text('Ekle'),
              ),
            ],
          ),
    );
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
                onAuthorityTap: () {},
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ACİL DURUM KİŞİLERİ",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.grey[800],
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              IconButton(
                                onPressed: _showAddContactDialog,
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: isDark ? Colors.white : Colors.grey[800],
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (acilDurumKisileri.isNotEmpty)
                            buildEmergencyContactsList(isDark)
                          else
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 64,
                                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Henüz acil durum kişisi eklenmemiş',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
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

  Widget buildContactCard(
    Map<String, dynamic> kisi,
    bool isDark, {
    bool isEmergencyContact = false,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
                    Icon(
                      Icons.phone,
                      color: isDark ? Colors.white70 : Colors.blueGrey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${kisi['telefon']}",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: isDark ? Colors.white70 : Colors.blueGrey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${kisi['adres']}",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                if (kisi['email'] != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: isDark ? Colors.white70 : Colors.blueGrey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${kisi['email']}",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showUpdateDialog(kisi);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                child: const Text(
                  "Düzenle",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(kisi);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text(
                  "Kaldır",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : Colors.blueGrey.shade700,
                ),
                child: const Text(
                  "Kapat",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.red.shade800 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.shade400, width: 2),
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
                color: Colors.red.shade600.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.priority_high,
                size: 30,
                color: Colors.red.shade300,
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
                            color: isDark ? Colors.red.shade100 : Colors.red.shade800,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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
                      color: isDark ? Colors.red.shade200 : Colors.red.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showDeleteConfirmationDialog(kisi),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.remove_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget buildBigBell() {
    return BigBellWidget();
  }
}
