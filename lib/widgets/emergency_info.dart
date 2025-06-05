import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class EmergencyInfoDialog extends StatelessWidget {
  const EmergencyInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return FutureBuilder<Map<String, dynamic>>(
      future: _getEmergencyInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AlertDialog(
            backgroundColor:
            themeController.isDarkMode ? Colors.grey[900] : Colors.white,
            content: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final data = snapshot.data ?? {};
        final name = data['name'] ?? '-';
        final surname = data['surname'] ?? '-';
        final bloodGroup = data['bloodGroup'] ?? '-';
        final emergencyNote = data['emergencyNote'] ?? '-';
        final medicalInfo = data['medicalInfo'] ?? '-';
        final hasPet = data['hasPet'] ?? false;
        final imagePath = data['imagePath'];

        return AlertDialog(
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
                    _buildInfoRow("Ad", name, themeController),
                    _buildInfoRow("Soyad", surname, themeController),
                    _buildInfoRow("Kan Grubu", bloodGroup, themeController),
                    _buildInfoRow("Acil Not", emergencyNote, themeController),
                    _buildInfoRow("İlaç/Alerji", medicalInfo, themeController),
                    _buildInfoRow(
                      "Evcil Hayvan",
                      hasPet ? "Var" : "Yok",
                      themeController,
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
                  color: themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeController themeController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "$label: $value",
        style: TextStyle(
          color: themeController.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getEmergencyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? '-',
      'surname': prefs.getString('surname') ?? '-',
      'bloodGroup': prefs.getString('bloodGroup') ?? '-',
      'emergencyNote': prefs.getString('emergencyNote') ?? '-',
      'medicalInfo': prefs.getString('medicalInfo') ?? '-',
      'hasPet': prefs.getBool('hasPet') ?? false,
      'imagePath': prefs.getString('profileImagePath'),
    };
  }
}