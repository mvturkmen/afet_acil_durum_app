import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class ConnectivityCardWidget extends StatelessWidget {
  final ConnectivityService connectivityService;

  const ConnectivityCardWidget({
    Key? key,
    required this.connectivityService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeController>(context).isDarkMode;

    return StreamBuilder<BaglantiDurumu>(
      stream: connectivityService.baglantiStream,
      initialData: connectivityService.mevcutDurum,
      builder: (context, snapshot) {
        final baseColor = connectivityService.baglantiRengi();
        final bgColor = isDarkMode
            ? baseColor.withOpacity(0.15)
            : baseColor.withOpacity(0.1);
        final borderColor = isDarkMode
            ? baseColor.withOpacity(0.4)
            : baseColor.withOpacity(0.3);
        final textColor = isDarkMode ? Colors.white70 : Colors.grey[800];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: bgColor,
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: baseColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  connectivityService.baglantiIkonu(),
                  color: baseColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bağlantı Durumu',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${connectivityService.baglantiDurumuMetni()} - ${connectivityService.baglantiTipiMetni()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: baseColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}