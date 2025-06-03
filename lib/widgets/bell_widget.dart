import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/services/notifications/show_notification.dart';

class BigBellWidget extends StatelessWidget {
  final VoidCallback? onTap; // Opsiyonel hale getirdik

  const BigBellWidget({
    Key? key,
    this.onTap,
  }) : super(key: key);

  ShowNotification get _showNotification => ShowNotification(); // Lazy getter

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          await _showNotification.sendAlarmNotification();
          onTap?.call(); // Eğer tanımlıysa dışarıdan gelen onTap çalışsın

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Alarm bildirimi gönderildi!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.red.shade700,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade300.withOpacity(0.7),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.notifications_active,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
