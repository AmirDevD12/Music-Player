import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class PlayNewSong {
  void newSong(String? uri,AudioPlayer audioPlayer,BuildContext context) {

    Duration duration = const Duration();
    Duration position = const Duration();
       if(uri==null){
         audioPlayer.durationStream.listen((event) {
           duration = event!;
           context.read<PlaySongBloc>().add(DurationEvent(
             duration,
             position,
           ));
         });
         audioPlayer.positionStream.listen((event) {
           position = event;
           context.read<PlaySongBloc>().add(DurationEvent(
             duration,
             position,
           ));
         });
       }
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      audioPlayer.durationStream.listen((event) {
        duration = event!;
        context.read<PlaySongBloc>().add(DurationEvent(
          duration,
          position,
        ));
      });
      audioPlayer.positionStream.listen((event) {
        position = event;
        context.read<PlaySongBloc>().add(DurationEvent(
          duration,
          position,
        ));
      });
    } catch(e) {print(e);}
  }
}