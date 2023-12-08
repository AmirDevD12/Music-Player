import 'package:on_audio_query/on_audio_query.dart';

class AddressFolder {
Future<List<String>>  location() async {
  List<String> songs = await OnAudioQuery().queryAllPath();
  if (songs.isNotEmpty) {
  print(songs);
  }
  return songs;
}
Future<List<SongModel>> getSongFile(String path) async {
  List<SongModel> songsData = await OnAudioQuery().queryFromFolder(path);
  return songsData;
}

// Future<List<String>> getSongs() async {
//   List<SongModel> songs = [];
//
//       List<String> songsData = await OnAudioQuery().queryAllPath();
//       return songsData;
// }
}