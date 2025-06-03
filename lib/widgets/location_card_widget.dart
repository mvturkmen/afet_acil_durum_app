import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/location/location_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class LocationCardWidget extends StatelessWidget {
  final VoidCallback? onLocationFound;
  final VoidCallback? onLocationError;

  const LocationCardWidget({
    Key? key,
    this.onLocationFound,
    this.onLocationError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeController>(context).isDarkMode;

    final backgroundColor = isDarkMode ? Colors.blueGrey.shade800 : Colors.blueGrey.shade300;
    final shadowColor = isDarkMode ? Colors.black54 : Colors.blueGrey.shade100.withOpacity(0.5);
    final textColor = isDarkMode ? Colors.white70 : Colors.white70;

    return GestureDetector(
      onTap: () async {
        MyPosition? position = await LocationService().getCurrentLocation();
        if (position != null) {
          String address = await LocationService().getAddressFromPosition(position);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: isDarkMode ? Colors.grey[900] : null,
              title: Text('Konum Bilgisi', style: TextStyle(color: isDarkMode ? Colors.white : null)),
              content: Text(
                '📍 Enlem: ${position.latitude}, Boylam: ${position.longitude}\n\n📫 Adres: $address',
                style: TextStyle(color: isDarkMode ? Colors.white70 : null),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Kapat', style: TextStyle(color: isDarkMode ? Colors.blue[200] : null)),
                ),
              ],
            ),
          );
          if (onLocationFound != null) onLocationFound!();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Konum alınamadı.")),
          );
          if (onLocationError != null) onLocationError!();
        }
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              'assets/image/location.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              color: isDarkMode ? Colors.white70 : null,
              colorBlendMode: isDarkMode ? BlendMode.modulate : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Konumumu Göster",
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: isDarkMode ? Colors.black87 : Colors.black26,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}