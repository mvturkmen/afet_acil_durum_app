import 'dart:io';
import 'emergency_contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();  // load previously saved user data from shared preferences on app start
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance(); // get shared preferences instance
    _nameController.text = prefs.getString('name') ?? '';  // load saved name or set empty string
    _surnameController.text = prefs.getString('surname') ?? '';  // load saved surname or empty
    _bloodGroupController.text = prefs.getString('bloodGroup') ?? '';  // load saved blood group or empty

    String? imagePath = prefs.getString('profileImagePath');  // load saved profile image path
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _imageFile = File(imagePath);  // set image file if path exists
      });
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance(); // get shared preferences instance
    await prefs.setString('name', _nameController.text);  // save name to shared preferences
    await prefs.setString('surname', _surnameController.text);  // save surname
    await prefs.setString('bloodGroup', _bloodGroupController.text);  // save blood group

    if (_imageFile != null) {
      await prefs.setString('profileImagePath', _imageFile!.path);  // save profile image path if selected
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Veriler kaydedildi."),  // show confirmation message after saving
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Kullanıcı Bilgileri",
          style: TextStyle(
            color: Color(0xFF1F1F1F),
            fontWeight: FontWeight.w700,
            fontSize: 26,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Color(0xFF1F1F1F)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red.shade400, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade200.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                      child: _imageFile == null
                          ? Icon(Icons.camera_alt, size: 50, color: Colors.red.shade400)
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildInputField(_nameController, "Ad"),
              const SizedBox(height: 20),
              _buildInputField(_surnameController, "Soyad"),
              const SizedBox(height: 20),
              _buildInputField(_bloodGroupController, "Kan Grubu"),
              const SizedBox(height: 25),
              _buildEmergencyContactButton(),
              const SizedBox(height: 45),
              Center(
                child: ElevatedButton(
                  onPressed: _saveUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 18),
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

  Widget _buildInputField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Color(0xFF1F1F1F),
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactButton() {
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
          backgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
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
          'Acil Durum İletişim Kişileri',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}