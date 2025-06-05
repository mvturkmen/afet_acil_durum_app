import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _registerUsernameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerFirstNameController = TextEditingController();
  final _registerLastNameController = TextEditingController();
  final _registerBirthDateController = TextEditingController();
  String _selectedRole = 'KULLANICI';
  bool _isLoading = false;
  final String _baseUrl = 'https://4495-149-86-144-194.ngrok-free.app';

  @override
  void dispose() {
    _registerUsernameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerFirstNameController.dispose();
    _registerLastNameController.dispose();
    _registerBirthDateController.dispose();
    super.dispose();
  }

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
        '$_baseUrl/register',
        '$_baseUrl/register',
        '$_baseUrl/register',
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

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return AlertDialog(
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
                color: themeController.isDarkMode ? Colors.white : Colors.black,
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
                color: themeController.isDarkMode ? Colors.white : Colors.black,
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
                color: themeController.isDarkMode ? Colors.white : Colors.black,
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
                color: themeController.isDarkMode ? Colors.white : Colors.black,
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
                color: themeController.isDarkMode ? Colors.white : Colors.black,
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
                color: themeController.isDarkMode ? Colors.white : Colors.black,
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
                  themeController.isDarkMode ? Colors.grey[800] : Colors.white,
              style: TextStyle(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
              ),
              items:
                  [
                    'DOKTOR',
                    'AFAD_EKIP_UYESI',
                    'KIZILAY_EKIP_UYESI',
                    'KULLANICI',
                    'ADMIN',
                  ].map((String role) {
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
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                themeController.isDarkMode ? Colors.blueGrey : Colors.blue,
          ),
          child:
              _isLoading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Text("Kayıt Ol"),
          onPressed: _isLoading ? null : _register,
        ),
      ],
    );
  }
}
