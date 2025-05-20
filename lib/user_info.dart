import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  @override
  void initState() { // data initializing at the beginning
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async { // data loading
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _surnameController.text = prefs.getString('surname') ?? '';
    _bloodGroupController.text = prefs.getString('bloodGroup') ?? '';
    _emergencyContactController.text = prefs.getString('emergencyContact') ?? '';
  }

  Future<void> _saveUserData() async { // data storing
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('surname', _surnameController.text);
    await prefs.setString('bloodGroup', _bloodGroupController.text);
    await prefs.setString('emergencyContact', _emergencyContactController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bilgiler kaydedildi.")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kullanıcı Bilgileri")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Ad')),
            TextField(controller: _surnameController, decoration: const InputDecoration(labelText: 'Soyad')),
            TextField(controller: _bloodGroupController, decoration: const InputDecoration(labelText: 'Kan Grubu')),
            TextField(controller: _emergencyContactController, decoration: const InputDecoration(labelText: 'Acil Durum Kişisi')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
