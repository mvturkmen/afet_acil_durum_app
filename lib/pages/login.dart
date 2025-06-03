import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _registerUsernameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerFirstNameController = TextEditingController();
  final _registerLastNameController = TextEditingController();
  final _registerBirthDateController = TextEditingController();
  String _selectedRole = 'DOKTOR';

  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _registerBirthDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _register() async {
    final username = _registerUsernameController.text.trim();
    final email = _registerEmailController.text.trim();
    final password = _registerPasswordController.text.trim();
    final firstName = _registerFirstNameController.text.trim();
    final lastName = _registerLastNameController.text.trim();
    final birthDate = _registerBirthDateController.text.trim();
    final role = _selectedRole;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        birthDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tüm alanları doldurmalısınız"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> urlsToTry = [
        'http://192.168.1.100:8080/register',
        'http://10.0.2.2:8080/register',
        'http://localhost:8080/register',
      ];

      http.Response? response;
      String? workingUrl;

      for (String url in urlsToTry) {
        try {
          print('Deneme URL: $url');
          response = await http
              .post(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'username': username,
                  'email': email,
                  'password': password,
                  'firstName': firstName,
                  'lastName': lastName,
                  'birthDate': birthDate,
                  'role': role,
                }),
              )
              .timeout(const Duration(seconds: 5));

          workingUrl = url;
          break;
        } catch (e) {
          print('$url başarısız: $e');
          continue;
        }
      }

      if (response == null) {
        throw Exception('Hiçbir API endpoint\'ine bağlanılamadı');
      }

      print('Başarılı URL: $workingUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kayıt başarılı! Giriş yapabilirsiniz"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Kayıt dialogunu kapat
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Kayıt başarısız: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kayıt sırasında hata oluştu: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      print('Kayıt hatası: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showRegisterDialog() {
    final themeController = Provider.of<ThemeController>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor:
                themeController.isDarkMode ? Colors.grey[900] : Colors.white,
            title: Text(
              "Kayıt Ol",
              style: TextStyle(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _registerUsernameController,
                    decoration: InputDecoration(
                      labelText: "Kullanıcı Adı",
                      labelStyle: TextStyle(
                        color:
                            themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _registerEmailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(
                        color:
                            themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _registerFirstNameController,
                    decoration: InputDecoration(
                      labelText: "Ad",
                      labelStyle: TextStyle(
                        color:
                            themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _registerLastNameController,
                    decoration: InputDecoration(
                      labelText: "Soyad",
                      labelStyle: TextStyle(
                        color:
                            themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _registerBirthDateController,
                    decoration: InputDecoration(
                      labelText: "Doğum Tarihi (YYYY-MM-DD)",
                      labelStyle: TextStyle(
                        color:
                            themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                    onTap: () => _selectDate(context),
                    readOnly: true,
                  ),
                  TextField(
                    controller: _registerPasswordController,
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      labelStyle: TextStyle(
                        color:
                            themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                        ),
                      ),
                    ),
                    obscureText: true,
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: "Rol",
                      labelStyle: TextStyle(
                        color:
                            themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                        ),
                      ),
                    ),
                    dropdownColor:
                        themeController.isDarkMode
                            ? Colors.grey[800]
                            : Colors.white,
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                    items:
                        ['DOKTOR', 'HASTA', 'ADMIN'].map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "İptal",
                  style: TextStyle(
                    color:
                        themeController.isDarkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      themeController.isDarkMode
                          ? Colors.blueGrey
                          : Colors.blue,
                ),
                child: const Text("Kayıt Ol"),
                onPressed: () => _register(),
              ),
            ],
          ),
    );
  }

  Future<void> _showEmergencyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? '-';
    String surname = prefs.getString('surname') ?? '-';
    String bloodGroup = prefs.getString('bloodGroup') ?? '-';
    String emergencyNote = prefs.getString('emergencyNote') ?? '-';
    String medicalInfo = prefs.getString('medicalInfo') ?? '-';
    bool hasPet = prefs.getBool('hasPet') ?? false;
    String? imagePath = prefs.getString('profileImagePath');

    final themeController = Provider.of<ThemeController>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor:
                themeController.isDarkMode ? Colors.grey[900] : Colors.white,
            title: Text(
              "Acil Durum Bilgileri",
              style: TextStyle(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imagePath != null && imagePath.isNotEmpty)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(File(imagePath)),
                    ),
                  const SizedBox(height: 20),
                  ListBody(
                    children: [
                      Text(
                        "Ad: $name",
                        style: TextStyle(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      Text(
                        "Soyad: $surname",
                        style: TextStyle(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      Text(
                        "Kan Grubu: $bloodGroup",
                        style: TextStyle(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      Text(
                        "Acil Not: $emergencyNote",
                        style: TextStyle(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      Text(
                        "İlaç/Alerji: $medicalInfo",
                        style: TextStyle(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      Text(
                        "Evcil Hayvan: ${hasPet ? "Var" : "Yok"}",
                        style: TextStyle(
                          color:
                              themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Kapat",
                  style: TextStyle(
                    color:
                        themeController.isDarkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _login() async {
    final username = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kullanıcı adı ve şifre boş olamaz"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Gerçek telefon için bilgisayarınızın IP adresini kullanın
      List<String> urlsToTry = [
        'http://192.168.1.100:8080/authenticate', // Bilgisayarınızın IP adresi
        'http://10.0.2.2:8080/authenticate', // Android emülatörü için
        'http://localhost:8080/authenticate', // iOS simulator için
      ];

      http.Response? response;
      String? workingUrl;

      for (String url in urlsToTry) {
        try {
          print('Deneme URL: $url'); // Debug için
          response = await http
              .post(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({'username': username, 'password': password}),
              )
              .timeout(const Duration(seconds: 5));

          workingUrl = url;
          break;
        } catch (e) {
          print('$url başarısız: $e');
          continue;
        }
      }

      if (response == null) {
        throw Exception('Hiçbir API endpoint\'ine bağlanılamadı');
      }

      print('Başarılı URL: $workingUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final role = data['role'];

        // Token'ı SharedPreferences'a kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', role);
        await prefs.setString('username', username);

        // Başarılı giriş mesajı
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Giriş başarılı! Hoş geldiniz $username"),
            backgroundColor: Colors.green,
          ),
        );

        // Ana sayfaya yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      } else if (response.statusCode == 401) {
        // Yanlış kullanıcı adı veya şifre
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kullanıcı adı veya şifre hatalı"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Diğer hatalar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Giriş yapılamadı. Hata kodu: ${response.statusCode}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Ağ hatası veya diğer hatalar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bağlantı hatası: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      print('Login hatası: $e'); // Debug için
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    final textColor = themeController.isDarkMode ? Colors.white : Colors.black;
    final backgroundColor =
        themeController.isDarkMode ? Colors.black : Colors.white;
    final buttonColor =
        themeController.isDarkMode ? Colors.blueGrey : Colors.blue;
    final inputFillColor =
        themeController.isDarkMode ? Colors.grey[850] : Colors.grey[200];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              Image.network(
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/fkn763yn_expires_30_days.png",
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Kullanıcı Adı",
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  filled: true,
                  fillColor: inputFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: textColor),
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  filled: true,
                  fillColor: inputFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
                style: TextStyle(color: textColor),
                enabled: !_isLoading,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: buttonColor,
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text("Giriş Yap"),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _isLoading ? null : _showRegisterDialog,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: buttonColor),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text("Kayıt Ol", style: TextStyle(color: buttonColor)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _showEmergencyInfo,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.red.shade600,
                ),
                child: const Text("Acil Durum Bilgilerini Görüntüle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
