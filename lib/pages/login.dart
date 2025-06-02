import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kayıt Ol"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _registerEmailController,
              decoration: const InputDecoration(labelText: "Mail"),
            ),
            TextField(
              controller: _registerPasswordController,
              decoration: const InputDecoration(labelText: "Şifre"),
              obscureText: true,
            ),
            TextField(
              controller: _emergencyContactController,
              decoration: const InputDecoration(labelText: "Acil Kişi Numarası"),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("İptal"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Acil Durum Bilgileri"),
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
                  Text("Ad: $name"),
                  Text("Soyad: $surname"),
                  Text("Kan Grubu: $bloodGroup"),
                  Text("Acil Not: $emergencyNote"),
                  Text("İlaç/Alerji: $medicalInfo"),
                  Text("Evcil Hayvan: ${hasPet ? "Var" : "Yok"}"),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Kapat"),
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                decoration: const InputDecoration(labelText: "Mail"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Şifre"),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Giriş Yap"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _showRegisterDialog,
                child: const Text("Kayıt Ol"),
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