
import 'dart:io';
import 'package:first_project/locator.dart';
import 'package:first_project/model/path_song.dart';
import 'package:on_audio_query/on_audio_query.dart';
class DeleteSongFile {
  getDeleteSong(SongModel song)async{
    try{
      String path=locator.get<PathSong>().getPathSong(song);
      File file = File(path);
      file.deleteSync();
      if (file.existsSync()) {
        print(file.absolute);
        file.delete();
      }
      if (await file.exists()) {
        print("vogod dard");
      }
    }catch(e){
      print(e);}
  }
}