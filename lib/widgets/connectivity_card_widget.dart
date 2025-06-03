import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';

class ConnectivityCardWidget extends StatelessWidget {
  final ConnectivityService connectivityService;

  const ConnectivityCardWidget({
    Key? key,
    required this.connectivityService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaglantiDurumu>(
      stream: connectivityService.baglantiStream,
      initialData: connectivityService.mevcutDurum,
      builder: (context, snapshot) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: connectivityService.baglantiRengi().withOpacity(0.1),
            border: Border.all(
              color: connectivityService.baglantiRengi().withOpacity(0.3),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: connectivityService.baglantiRengi().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  connectivityService.baglantiIkonu(),
                  color: connectivityService.baglantiRengi(),
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
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${connectivityService.baglantiDurumuMetni()} - ${connectivityService.baglantiTipiMetni()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: connectivityService.baglantiRengi(),
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