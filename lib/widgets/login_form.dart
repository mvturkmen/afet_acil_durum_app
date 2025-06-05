import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final String _baseUrl = 'https://152d-149-86-144-194.ngrok-free.app';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
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
      List<String> urlsToTry = [
        '$_baseUrl/authenticate',
        '$_baseUrl/authenticate',
        '$_baseUrl/authenticate',
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
        final userId = data['id'];

        print("\n=== LOGIN RESPONSE DATA ===");
        print("Token: $token");
        print("Role: $role");
        print("User ID: $userId");
        print("User ID Type: ${userId.runtimeType}");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', role);
        await prefs.setString('username', username);

        // userId'yi integer'a çevirip kaydediyoruz
        if (userId != null) {
          final userIdInt = int.tryParse(userId.toString());
          if (userIdInt != null) {
            await prefs.setInt('user_id', userIdInt);
            print("User ID saved as integer: $userIdInt");
          } else {
            print("ERROR: Could not convert userId to integer: $userId");
            throw Exception('User ID geçersiz format');
          }
        } else {
          print("ERROR: userId is null in API response");
          throw Exception('User ID bulunamadı');
        }

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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Giriş başarısız: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Giriş sırasında hata oluştu: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      print('Login hatası: $e');
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
    final inputFillColor =
        themeController.isDarkMode ? Colors.grey[850] : Colors.grey[200];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: "Kullanıcı Adı",
            labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
            filled: true,
            fillColor: inputFillColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                  : const Text("Giriş Yap"),
        ),
      ],
    );
  }
}
