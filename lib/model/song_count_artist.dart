import 'package:first_project/model/songs_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongCountArtist {
  Future<Map<String, int>> getSongCountByArtist() async {
    Map<String, int> songCountByArtist = {};
    List<SongModel> songs = [];
    songs = await SongList().getSongs(SongSortType.DATE_ADDED);
    for (SongModel song in songs) {
      bool check=false;
      if (song.artist!=null) {
        if (songCountByArtist.isNotEmpty) {
          for(int i=0;i<songCountByArtist.length;i++){
            if (song.artist==songCountByArtist.keys.elementAt(i)) {
              int s=songCountByArtist.values.elementAt(i);
              s++;
              songCountByArtist[song.artist!]=s;
              check=true;
              break ;
            }
          }
          if (!check) {
            songCountByArtist[song.artist!]=1;
          }
        }else{ songCountByArtist[song.artist!]=1;}
      }
    }

    return songCountByArtist;
  }
}