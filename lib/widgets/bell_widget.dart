import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/notifications/show_notification.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class BigBellWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const BigBellWidget({
    Key? key,
    this.onTap,
  }) : super(key: key);

  ShowNotification get _showNotification => ShowNotification();

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return Center(
      child: GestureDetector(
        onTap: () async {
          await _showNotification.sendAlarmNotification();
          onTap?.call();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Alarm bildirimi gönderildi!'),
              backgroundColor: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isDarkMode ? Colors.red.shade300 : Colors.red.shade300).withOpacity(0.7),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_active,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}