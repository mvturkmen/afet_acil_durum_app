import 'package:flutter/material.dart';
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kayıt Ol"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _registerEmailController,
                decoration: InputDecoration(labelText: "Mail"),
              ),
              TextField(
                controller: _registerPasswordController,
                decoration: InputDecoration(labelText: "Şifre"),
                obscureText: true,
              ),
              TextField(
                controller: _emergencyContactController,
                decoration: InputDecoration(labelText: "Acil Kişi Numarası"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Kayıt Ol"),
              onPressed: () {
                // Kayıt işlemi yapılabilir
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Kayıt işlemi tamamlandı")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Burada giriş kontrolü yapılabilir

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
              SizedBox(height: 80),
              Image.network(
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/fkn763yn_expires_30_days.png",
                width: 80,
                height: 80,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Mail"),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Şifre"),
                obscureText: true,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _login,
                child: Text("Giriş Yap"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: _showRegisterDialog,
                child: Text("Kayıt Ol"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
