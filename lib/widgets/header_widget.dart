import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class HeaderWidget extends StatelessWidget {
  final VoidCallback onAuthorityTap;
  final ConnectivityService connectivityService;

  const HeaderWidget({
    Key? key,
    required this.onAuthorityTap,
    required this.connectivityService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeController>(context).isDarkMode;

    final gradientColors = isDarkMode
        ? [Colors.indigo.shade900, Colors.indigo.shade700]
        : [Colors.indigo.shade600, Colors.indigo.shade400];

    final boxShadowColor = isDarkMode
        ? Colors.indigo.shade900.withOpacity(0.6)
        : Colors.indigo.shade200.withOpacity(0.3);

    final connectionBgColor = connectivityService.baglantiRengi().withOpacity(isDarkMode ? 0.2 : 0.1);
    final connectionBorderColor = connectivityService.baglantiRengi().withOpacity(isDarkMode ? 0.5 : 1.0);
    final connectionIconColor = connectivityService.baglantiRengi();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onAuthorityTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: boxShadowColor,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Yetkili',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<BaglantiDurumu>(
          stream: connectivityService.baglantiStream,
          initialData: connectivityService.mevcutDurum,
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: connectionBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: connectionBorderColor,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    connectivityService.baglantiIkonu(),
                    color: connectionIconColor,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    connectivityService.baglantiTipiMetni(),
                    style: TextStyle(
                      color: connectionIconColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}