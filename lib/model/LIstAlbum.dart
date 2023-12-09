import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListAlbum {
  Future<List<AlbumModel>> getAlbums() async {
    List<AlbumModel> albums = [];
    if (!kIsWeb) {
      bool hasPermission = await OnAudioQuery().permissionsStatus();
      if (hasPermission) {
        // Retrieve a list of albums.
        albums = await OnAudioQuery().queryAlbums();

      } else {
        // Request the necessary permissions.
        await OnAudioQuery().permissionsRequest();
      }
    }
    return albums;
  }
}