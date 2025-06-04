import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';
import 'package:afet_acil_durum_app/widgets/login_form.dart';
import 'package:afet_acil_durum_app/widgets/register_dialog_widget.dart';
import 'package:afet_acil_durum_app/widgets/emergency_info.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool _isLoading = false;

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) => const RegisterDialog(),
    );
  }

  void _showEmergencyInfo() {
    showDialog(
      context: context,
      builder: (context) => const EmergencyInfoDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    final textColor = themeController.isDarkMode ? Colors.white : Colors.black;
    final backgroundColor =
    themeController.isDarkMode ? Colors.black : Colors.white;
    final buttonColor =
    themeController.isDarkMode ? Colors.blueGrey : Colors.blue;

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
              const LoginForm(),
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