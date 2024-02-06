import 'dart:async';
import 'package:first_project/locator.dart';
import 'package:first_project/model/dataBase/delete_song_dataBase/delete_song.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';


class SongList {

  Future<List<SongModel>> getSongs(SongSortType songSortType) async {
    List<SongModel> songs = [];
    if (!kIsWeb) {

      bool hasPermission = await OnAudioQuery().permissionsStatus();
      if (hasPermission) {
        Box delete=Hive.box<DeleteSong>("Delete Song");
        List<SongModel> songsData = await OnAudioQuery().querySongs(sortType: songSortType);
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
  Future<ConcatenatingAudioSource> getAudioSource(SongSortType songSortType) async {
    List<SongModel> songs=await locator.get<SongList>().getSongs(songSortType);

    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: [
        for (int i = 0; i <songs.length; i++)
          AudioSource.uri(Uri.parse(
              songs[i].data),
              tag: MediaItem(
                id: songs[i].id.toString(),
                album: songs[i].album??"",
                title: songs[i].title,
                displaySubtitle:songs[i].displayName ,
                artUri: Uri.parse(songs[i].id.toString()),
              )),
      ],
    );
    return playlist;
  }
  Future<List<SongModel>> getSongBox(List<String> paths) async {
   List<SongModel>songs=await locator.get<SongList>().getSongs(SongSortType.DATE_ADDED);
   List<SongModel>boxSong=[];
   for(int i=0; i< paths.length;i++){
     boxSong.add(songs[i]);
   }
   for (int i=0; i< songs.length;i++) {
     for (int j=0;j< paths.length;j++) {
     if (songs[i].data==paths[j]) {
       boxSong[j]=songs[i];
     }
   }}
   return boxSong;
  }
}
