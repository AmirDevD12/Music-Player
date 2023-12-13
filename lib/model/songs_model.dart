import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongList {
  Future<List<SongModel>> getSongs(SongSortType? songSortType,String? path) async {
    List<SongModel> songs = [];
    if (!kIsWeb) {
      bool hasPermission = await OnAudioQuery().permissionsStatus();
      if (hasPermission) {
        List<SongModel> songsData = await OnAudioQuery().querySongs(sortType: songSortType??SongSortType.DATE_ADDED);
        for (int i=0; i<songsData.length;i++) {
          if (path != null) {
            if (songsData[i].data==path) {
              songsData.removeAt(i);
            }
          }
          songs.add(songsData[i]);
        }
      } else {

        await OnAudioQuery().permissionsRequest();
      }
    }
    return songs;
  }


}
