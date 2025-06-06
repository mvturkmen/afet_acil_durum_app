import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afet_acil_durum_app/services/speech_to_text_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';

class VoiceMessageWidget extends StatefulWidget {
  const VoiceMessageWidget({Key? key}) : super(key: key);

  @override
  VoiceMessageWidgetState createState() => VoiceMessageWidgetState();
}

class VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  final SpeechService _speechService = SpeechService();
  String text = 'Bir şey söyleyin...';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speechService.initSpeech();
    if (!available) {
      setState(() {
        text = 'Konuşma tanıma kullanılamıyor.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeController>(context).isDarkMode;

    return GestureDetector(
      onTap: () async {
        String newText = await _speechService.startListening();
        setState(() {
          text = newText;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sesli mesaj alındı!')));
      },
      onDoubleTap: () {
        _speechService.stopListening();
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red[900] ,
          boxShadow: [
            BoxShadow(
              color:
              isDarkMode
                  ? Colors.black54
                  : Colors.blueGrey.shade100.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color:
                isDarkMode ? Colors.white12 : Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Sesli Mesaj Bırakın",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_voice, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }
}