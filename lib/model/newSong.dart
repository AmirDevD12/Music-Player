import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class PlayNewSong {
  void newSong(String? uri,AudioPlayer audioPlayer,BuildContext context) {
    Duration duration = const Duration();
    Duration position = const Duration();

    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      audioPlayer.durationStream.listen((event) {
        duration = event!;
        BlocProvider.of<PlaySongBloc>(context).add(DurationEvent(
          duration,
          position,
        ));
      });
      audioPlayer.positionStream.listen((event) {
        position = event;
        BlocProvider.of<PlaySongBloc>(context).add(DurationEvent(
          duration,
          position,
        ));
      });
    } catch(e) {print(e);}
  }
}