import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/notifications/show_notification.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class EmergencyCardWidget extends StatelessWidget {
  final VoidCallback onTap;

  const EmergencyCardWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  ShowNotification get _showNotification => ShowNotification();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeController>(context).isDarkMode;

    final gradientColors = isDarkMode
        ? [Colors.red.shade900, Colors.red.shade700]
        : [Colors.red.shade700, Colors.red.shade400];

    final boxShadowColor = isDarkMode
        ? Colors.red.shade900.withOpacity(0.7)
        : Colors.red.shade200.withOpacity(0.5);

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
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: boxShadowColor,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              'assets/image/sos.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
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