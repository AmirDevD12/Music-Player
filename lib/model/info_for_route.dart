import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class InfoPage{

  ConcatenatingAudioSource? concatenatingAudioSource;
  int index;
 List<SongModel>? songs;
  Box? nameList;

InfoPage({required this.concatenatingAudioSource,required this.index,required this.songs,required this.nameList});

void setInfo(ConcatenatingAudioSource? concatenatingAudioSource,int index,List<SongModel>? songs,Box? nameList){
 this.concatenatingAudioSource=concatenatingAudioSource;
 this.index=index;
 this.songs=songs;
 this.nameList=nameList;
}
}