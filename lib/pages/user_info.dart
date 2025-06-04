import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'emergency_contact.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emergencyNoteController = TextEditingController();
  final TextEditingController _medicalInfoController = TextEditingController();
  bool _hasPet = false;
  String _selectedBloodGroup = '';
  File? _imageFile;

  final List<String> _bloodGroups = [
    '',
    'A+', 'A-',
    'B+', 'B-',
    'AB+', 'AB-',
    '0+', '0-'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _surnameController.text = prefs.getString('surname') ?? '';
    _selectedBloodGroup = prefs.getString('bloodGroup') ?? '';
    _emergencyNoteController.text = prefs.getString('emergencyNote') ?? '';
    _medicalInfoController.text = prefs.getString('medicalInfo') ?? '';
    _hasPet = prefs.getBool('hasPet') ?? false;

    String? imagePath = prefs.getString('profileImagePath');
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('surname', _surnameController.text);
    await prefs.setString('bloodGroup', _selectedBloodGroup);
    await prefs.setString('emergencyNote', _emergencyNoteController.text);
    await prefs.setString('medicalInfo', _medicalInfoController.text);
    await prefs.setBool('hasPet', _hasPet);

    if (_imageFile != null) {
      await prefs.setString('profileImagePath', _imageFile!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Veriler başarıyla kaydedildi!"),
        backgroundColor: Colors.green.shade600,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedImage.name;
      final savedImage = await File(pickedImage.path).copy('${appDir.path}/$fileName');

      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: buildHeader(isDark),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "KULLANICI BİLGİLERİ",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey[800],
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildProfileSection(isDark),
                    const SizedBox(height: 24),
                    buildUserInfoContainer(isDark),
                    const SizedBox(height: 24),
                    const SizedBox(height: 32),
                    buildSaveButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(bool isDark) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black45 : Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white70 : Colors.grey[800],
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProfileSection(bool isDark) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.shade300.withOpacity(0.7),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Colors.blueGrey.shade900 : Colors.blueGrey.shade300,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: _imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.file(
                _imageFile!,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              Icons.camera_alt,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserInfoContainer(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.blueGrey.shade900 : Colors.blueGrey.shade300,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade100).withOpacity(0.5),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "Kişisel Bilgiler",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          buildInputField(_nameController, "Ad", Icons.person_outline),
          const SizedBox(height: 16),
          buildInputField(_surnameController, "Soyad", Icons.person_outline),
          const SizedBox(height: 16),
          buildBloodGroupDropdown(),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "Sağlık Bilgileri",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildInputField(_medicalInfoController, "İlaç / Alerji Bilgisi", Icons.medical_services_outlined),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(
                Icons.emergency,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "Acil Durum",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildInputField(_emergencyNoteController, "Acil Durum Notu", Icons.note_outlined),
          const SizedBox(height: 20),
          buildPetSwitch(),
        ],
      ),
    );
  }

  Widget buildInputField(TextEditingController controller, String hint, IconData icon) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.grey[800],
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : Colors.grey[600],
          ),
          prefixIcon: Icon(
            icon,
            color: isDark ? Colors.white54 : Colors.grey[600],
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        minLines: 1,
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget buildBloodGroupDropdown() {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            Icons.bloodtype,
            color: isDark ? Colors.white54 : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBloodGroup.isNotEmpty ? _selectedBloodGroup : null,
                hint: Text(
                  "Kan Grubu",
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                ),
                items: _bloodGroups.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.grey[800],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBloodGroup = newValue ?? '';
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPetSwitch() {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            Icons.pets,
            color: isDark ? Colors.white54 : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Evcil Hayvanınız var mı?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey[800],
              ),
            ),
          ),
          Switch(
            value: _hasPet,
            onChanged: (value) {
              setState(() {
                _hasPet = value;
              });
            },
            activeColor: Colors.green.shade600,
            inactiveThumbColor: isDark ? Colors.grey[600] : Colors.grey[400],
            inactiveTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
        ],
      ),
    );
  }



  Widget buildSaveButton() {
    return Center(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade300.withOpacity(0.7),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _saveUserData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.save,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "Kaydet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}