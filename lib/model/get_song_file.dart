import 'package:on_audio_query/on_audio_query.dart';

class GetSongFile{
  Future<List<SongModel>> getSongFile(String path) async {
    List<SongModel> songsData = await OnAudioQuery().querySongs(path: path);
    return songsData;
  }
}