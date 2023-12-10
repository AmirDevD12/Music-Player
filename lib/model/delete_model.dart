import 'dart:io';

import 'package:first_project/model/path_song.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DeleteSong {

  getDeleteSong(SongModel song)async{
    try{
      String path=PathSong().getPathSong(song);
      var file = File(path);

      file.delete();
    }catch(e){print(e);}


  }
}