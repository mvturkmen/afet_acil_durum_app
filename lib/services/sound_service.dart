import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final player = AudioPlayer();

  Future<void> playSound() async {
    await player.play(AssetSource('audio/amber-alert-emergency-notification-jam-fx-1-00-12.mp3'));
  }
}