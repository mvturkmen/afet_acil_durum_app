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
      const SnackBar(
        content: Text("Veriler kaydedildi."),
        duration: Duration(seconds: 1),
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

    final bgColor = themeController.isDarkMode ? Colors.black : const Color(0xFFF5F7FA);
    final textColor = themeController.isDarkMode ? Colors.white : const Color(0xFF1F1F1F);
    final cardColor = themeController.isDarkMode ? Colors.grey[900] : Colors.white;
    final hintColor = themeController.isDarkMode ? Colors.grey[600] : Colors.grey.shade400;
    final iconColor = themeController.isDarkMode ? Colors.red.shade200 : Colors.red.shade400;
    final shadowColor = themeController.isDarkMode ? Colors.black54 : Colors.black.withOpacity(0.1);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Kullanıcı Bilgileri",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 25,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: themeController.isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: iconColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: themeController.isDarkMode ? Colors.grey[800] : Colors.white,
                      backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                      child: _imageFile == null
                          ? Icon(Icons.camera_alt, size: 60, color: iconColor)
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildInputField(_nameController, "Ad", textColor, cardColor, hintColor, shadowColor),
              const SizedBox(height: 15),
              _buildInputField(_surnameController, "Soyad", textColor, cardColor, hintColor, shadowColor),
              const SizedBox(height: 15),
              _buildBloodGroupDropdown(textColor, cardColor, hintColor, shadowColor),
              const SizedBox(height: 15),
              _buildInputField(_emergencyNoteController, "Acil Durum Notu", textColor, cardColor, hintColor, shadowColor),
              const SizedBox(height: 15),
              _buildInputField(_medicalInfoController, "İlaç / Alerji Bilgisi", textColor, cardColor, hintColor, shadowColor),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Evcil Hayvanınız var mı?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: textColor,
                    ),
                  ),
                  Switch(
                    value: _hasPet,
                    onChanged: (value) {
                      setState(() {
                        _hasPet = value;
                      });
                    },
                    activeColor: iconColor,
                  )
                ],
              ),
              const SizedBox(height: 25),
              _buildEmergencyContactButton(themeController.isDarkMode),
              const SizedBox(height: 45),
              Center(
                child: ElevatedButton(
                  onPressed: _saveUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 6,
                    shadowColor: Colors.red.shade300.withOpacity(0.7),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  child: const Text(
                    "Kaydet",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, Color textColor, Color? bgColor, Color? hintColor, Color shadowColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
        minLines: 1,
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget _buildBloodGroupDropdown(Color textColor, Color? bgColor, Color? hintColor, Color shadowColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBloodGroup.isNotEmpty ? _selectedBloodGroup : null,
          hint: Text(
            "Kan Grubu",
            style: TextStyle(color: hintColor),
          ),
          items: _bloodGroups.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: textColor,
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
    );
  }

  Widget _buildEmergencyContactButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmergencyContact()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey.shade800,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.15),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        child: const Text(
          'Acil Durum İletişim',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}