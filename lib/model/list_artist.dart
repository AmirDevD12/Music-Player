import 'package:first_project/model/songs_model.dart';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListArtist {

  Future<List<SongModel>> getLisArtist(String nameArtist) async {
    List<SongModel> songsArtist = [];

    if (!kIsWeb) {
      bool hasPermission = await OnAudioQuery().permissionsStatus();

      if (hasPermission) {
        // Retrieve a list of songs.
        List<SongModel>  songs = await SongList().getSongs(SongSortType.DATE_ADDED);

        for (SongModel song in songs) {
          if (song.artist==nameArtist) {
            songsArtist.add(song);
          }

        }
      } else {
        // Request the necessary permissions.

      }
    }
    return songsArtist;
  }
}