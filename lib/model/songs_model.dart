import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongList {
  Future<List<SongModel>> getSongs(SongSortType? songSortType) async {
    List<SongModel> songs = [];
    if (!kIsWeb) {
      bool hasPermission = await OnAudioQuery().permissionsStatus();
      if (hasPermission) {
        List<SongModel> songsData = await OnAudioQuery().querySongs(sortType: songSortType??SongSortType.DATE_ADDED);
        for (SongModel song in songsData) {
          songs.add(song);
        }
      } else {

        await OnAudioQuery().permissionsRequest();
      }
    }
    return songs;
  }


}
