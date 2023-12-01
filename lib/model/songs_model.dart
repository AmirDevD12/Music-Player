import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
}