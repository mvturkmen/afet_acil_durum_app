
import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/services/sound_service.dart';
import '../services/notifications/show_notification.dart';

class DualIconRowWidget extends StatelessWidget {
  bool isTorchOn = false;

  DualIconRowWidget({Key? key}) : super(key: key);

  SoundService get _soundService => SoundService();
  ShowNotification get _showNotification => ShowNotification();

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.blueGrey.shade300,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.shade100.withOpacity(0.5),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/fp9cumfa_expires_30_days.png",
                    width: 50,
                    height: 50,
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
                  color: Colors.blueGrey.shade300,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.shade100.withOpacity(0.5),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/vixwrgce_expires_30_days.png",
                    width: 50,
                    height: 50,
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
