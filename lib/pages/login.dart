import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  void _showRegisterDialog() {
    final themeController = Provider.of<ThemeController>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeController.isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text("Kayıt Ol", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _registerEmailController,
              decoration: InputDecoration(
                labelText: "Mail",
                labelStyle: TextStyle(color: themeController.isDarkMode ? Colors.white70 : Colors.black54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeController.isDarkMode ? Colors.white54 : Colors.black26)),
              ),
              style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black),
            ),
            TextField(
              controller: _registerPasswordController,
              decoration: InputDecoration(
                labelText: "Şifre",
                labelStyle: TextStyle(color: themeController.isDarkMode ? Colors.white70 : Colors.black54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeController.isDarkMode ? Colors.white54 : Colors.black26)),
              ),
              obscureText: true,
              style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black),
            ),
            TextField(
              controller: _emergencyContactController,
              decoration: InputDecoration(
                labelText: "Acil Kişi Numarası",
                labelStyle: TextStyle(color: themeController.isDarkMode ? Colors.white70 : Colors.black54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeController.isDarkMode ? Colors.white54 : Colors.black26)),
              ),
              keyboardType: TextInputType.phone,
              style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("İptal", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeController.isDarkMode ? Colors.blueGrey : Colors.blue,
            ),
            child: const Text("Kayıt Ol"),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kayıt işlemi tamamlandı")),
              );
            },
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

    final themeController = Provider.of<ThemeController>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeController.isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text("Acil Durum Bilgileri", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
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
                  Text("Ad: $name", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
                  Text("Soyad: $surname", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
                  Text("Kan Grubu: $bloodGroup", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
                  Text("Acil Not: $emergencyNote", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
                  Text("İlaç/Alerji: $medicalInfo", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
                  Text("Evcil Hayvan: ${hasPet ? "Var" : "Yok"}", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Kapat", style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black)),
          ),
        ],
      ),
    );
  }

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    final textColor = themeController.isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = themeController.isDarkMode ? Colors.black : Colors.white;
    final buttonColor = themeController.isDarkMode ? Colors.blueGrey : Colors.blue;
    final inputFillColor = themeController.isDarkMode ? Colors.grey[850] : Colors.grey[200];

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
                  labelText: "Mail",
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  filled: true,
                  fillColor: inputFillColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: TextStyle(color: textColor),
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
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Giriş Yap"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: buttonColor,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _showRegisterDialog,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: buttonColor),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  "Kayıt Ol",
                  style: TextStyle(color: buttonColor),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showEmergencyInfo,
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