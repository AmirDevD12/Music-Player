import 'dart:async';
import 'package:first_project/model/dataBase/delete_song_dataBase/delete_song.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';


class SongList {

  Future<List<SongModel>> getSongs(SongSortType? songSortType) async {
    List<SongModel> songs = [];
    if (!kIsWeb) {

      bool hasPermission = await OnAudioQuery().permissionsStatus();
      if (hasPermission) {
        Box delete=Hive.box<DeleteSong>("Delete Song");
        List<SongModel> songsData = await OnAudioQuery().querySongs(sortType: songSortType??SongSortType.DATE_ADDED);
        for (int i=0; i<songsData.length;i++) {
          bool check=true;
          for(int j=0; j<delete.length;j++){
            DeleteSong deleteSong =delete.getAt(j);
            if (songsData[i].data==deleteSong.pathSong) {
              check =false;
              break;
            }
          }
          if (check) {
            songs.add(songsData[i]);
          }
        }
      } else {
        await OnAudioQuery().permissionsRequest();
      }
    }
    songs=songs.reversed.toList();
    return songs;
  }

}
