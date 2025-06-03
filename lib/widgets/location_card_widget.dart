import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/services/location_service.dart';

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
    return GestureDetector(
      onTap: () async {
        MyPosition? position = await LocationService().getCurrentLocation();
        if (position != null) {
          String address = await LocationService().getAddressFromPosition(
              position);
          showDialog(
            context: context,
            builder: (_) =>
                AlertDialog(
                  title: Text('Konum Bilgisi'),
                  content: Text(
                    '📍 Enlem: ${position.latitude}, Boylam: ${position
                        .longitude}\n\n📫 Adres: $address',
                  ),
                ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Konum alınamadı.")),
          );
        }
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueGrey.shade300,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.shade100.withOpacity(0.5),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset('assets/image/location.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Konumumu Göster",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(0, 2),
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