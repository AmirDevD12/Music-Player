import 'package:audio_waveforms/audio_waveforms.dart';


class PlayerControllerWave {

  final PlayerController playerController = PlayerController();


  Future<void> setPath(String path) async {
    await playerController.preparePlayer(path: path);
  }

  Future<void> seek(int next) async {
    await playerController.seekTo(next);
  }

  Future<void> pause() async {
    await playerController.pausePlayer();
  }

}