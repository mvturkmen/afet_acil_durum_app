import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isListening = false;
  String lastWords = '';
  double confidence = 1.0;

  /// Başlatma fonksiyonu
  Future<bool> initSpeech() async {
    return await _speech.initialize(
      onStatus: (status) => print('Durum: $status'),
      onError: (error) => print('Hata: $error'),
    );
  }

  /// Dinlemeye başla
  Future<String> startListening() async {
    await _speech.listen(
      onResult: (val) {
        lastWords = val.recognizedWords;
      },
      localeId: 'tr_TR', // Türkçe
    );
    isListening = true;
    print(lastWords);
    return lastWords;
  }

  /// Dinlemeyi durdur
  void stopListening() {
    _speech.stop();
    isListening = false;
  }

  /// Dinleyip dinlemediğini kontrol et
  bool get isSpeechAvailable => _speech.isAvailable;
}