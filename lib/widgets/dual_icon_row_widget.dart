import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/sound_service.dart';
import 'package:afet_acil_durum_app/services/notifications/show_notification.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class DualIconRowWidget extends StatelessWidget {
  bool isTorchOn = false;

  DualIconRowWidget({Key? key}) : super(key: key);

  SoundService get _soundService => SoundService();
  ShowNotification get _showNotification => ShowNotification();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeController>(context).isDarkMode;

    final bgColor = isDarkMode ? Colors.blueGrey.shade700 : Colors.blueGrey.shade300;
    final shadowColor = isDarkMode ? Colors.blueGrey.shade900.withOpacity(0.7) : Colors.blueGrey.shade100.withOpacity(0.5);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await _showNotification.sendFlashlightNotification(isTorchOn);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('El feneri bildirimi gönderildi!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                height: 80,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/image/flashlight.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await _soundService.playSound();
                await _showNotification.sendWhistleNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Düdük bildirimi gönderildi!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                height: 80,
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/image/whistle.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}