import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/services/notifications/show_notification.dart';

class EmergencyCardWidget extends StatelessWidget {
  final VoidCallback onTap;

  const EmergencyCardWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  ShowNotification get _showNotification => ShowNotification();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await _showNotification.sendAlarmNotification();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Acil durum bildirimi gönderildi!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        },
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.red.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade200.withOpacity(0.5),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.network(
              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/gol3gopo_expires_30_days.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Hızlı Yardım",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.black38,
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