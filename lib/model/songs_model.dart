import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongList {
  Future<List<SongModel>> getSongs() async {
    List<SongModel> songs = [];

    if (!kIsWeb) {
      bool hasPermission = await OnAudioQuery().permissionsStatus();

      if (hasPermission) {
        // Retrieve a list of songs.
        List<SongModel> songsData = await OnAudioQuery().querySongs();

        for (SongModel song in songsData) {
          songs.add(song);
        }
      } else {
        // Request the necessary permissions.
        await OnAudioQuery().permissionsRequest();
      }
    }

    return songs;
  }
  Future<Map<String, int>> getSongCountByArtist() async {
    Map<String, int>? songCountByArtist = {};

    List<SongModel> songs = await OnAudioQuery().querySongs();
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
  Future<List<SongModel>> getLisArtist(String nameArtist) async {
    List<SongModel> songs = [];

    if (!kIsWeb) {
      bool hasPermission = await OnAudioQuery().permissionsStatus();

      if (hasPermission) {
        // Retrieve a list of songs.
        List<SongModel> songsData = await OnAudioQuery().querySongs();

        for (SongModel song in songsData) {
          if (song.artist==nameArtist) {
            songs.add(song);
          }

        }
      } else {
        // Request the necessary permissions.
        await OnAudioQuery().permissionsRequest();
      }
    }
    return songs;
  }
  Future<List<AlbumModel>> getAlbums() async {

    List<AlbumModel> albums = [];


    if (!kIsWeb) {

      bool hasPermission = await OnAudioQuery().permissionsStatus();


      if (hasPermission) {

        // Retrieve a list of albums.

        List<AlbumModel> albumsData = await OnAudioQuery().queryAlbums();


        for (AlbumModel album in albumsData) {

          albums.add(album);

        }

      } else {

        // Request the necessary permissions.

        await OnAudioQuery().permissionsRequest();

      }

    }


    return albums;

  }

}
