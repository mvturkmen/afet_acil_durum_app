import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Uygulama Ayarları',
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w700,
            fontSize: 25,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: themeController.isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(
          color: themeController.isDarkMode ? Colors.white : const Color(0xFF1F1F1F),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(
              themeController.isDarkMode ? 'Koyu Modda' : 'Açık Modda',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: 'Poppins',
                color: themeController.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            value: themeController.isDarkMode,
            onChanged: themeController.toggleTheme,
            secondary: Icon(
              Icons.dark_mode,
              color: themeController.isDarkMode ? Colors.yellow : Colors.grey,
            ),
          ),
        ],
      ),
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
    );
  }
}