import 'package:first_project/model/songs_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongCountArtist {
  Future<Map<String, int>> getSongCountByArtist() async {
    Map<String, int>? songCountByArtist = {};
    List<SongModel> songs = [];
    songs = await SongList().getSongs(SongSortType.TITLE);
    int sum=0;
    for (SongModel song in songs) {
      if (song.artist != null) {
        if (songCountByArtist.containsKey(song.artist!)) {

          sum++;
          songCountByArtist[song.artist!] = sum;
        } else {
          songCountByArtist[song.artist!] = 1;
          sum=1;
        }
      }
    }

    return songCountByArtist;
  }
}