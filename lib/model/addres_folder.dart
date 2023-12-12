import 'package:on_audio_query/on_audio_query.dart';

class AddressFolder {
Future<List<String>>  location() async {
  List<String> songs = await OnAudioQuery().queryAllPath();
  if (songs.isNotEmpty) {
  print(songs);
  }
  return songs;
}
}