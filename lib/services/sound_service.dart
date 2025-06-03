import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final player = AudioPlayer();

  Future<void> playSound() async {
    await player.play(AssetSource('audio/gel_canım.mp3'));
  }
}