import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class PlayNewSong {
  void newSong(String? uri,AudioPlayer audioPlayer,BuildContext context,ConcatenatingAudioSource? concatenatingAudioSource) {

    Duration duration = const Duration();
    Duration position = const Duration();
       // if(uri==null){
       //   audioPlayer.durationStream.listen((event) {
       //     duration = event!;
       //     context.read<PlaySongBloc>().add(DurationEvent(
       //       duration,
       //       position,
       //     ));
       //   });
       //   audioPlayer.positionStream.listen((event) {
       //     position = event;
       //     context.read<PlaySongBloc>().add(DurationEvent(
       //       duration,
       //       position,
       //     ));
       //   });
       // }
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      audioPlayer.durationStream.listen((event) {
        duration = event!;
        print(event);

        context.read<PlaySongBloc>().add(DurationEvent(
          duration,
          position,
        ));
      });
      audioPlayer.positionStream.listen((event) async {
        position = event;
        print(event);
        if (duration==position) {
          await audioPlayer.setAudioSource(concatenatingAudioSource!, initialIndex: 0, initialPosition: Duration.zero);
          await audioPlayer.seekToNext();                     // Skip to the next item
          await audioPlayer.seekToPrevious();                 // Skip to the previous item
          await audioPlayer.seek(Duration.zero, index: 2);    // Skip to the start of track3.mp3
          await audioPlayer.setLoopMode(LoopMode.all);        // Set playlist to loop (off|all|one)
          await audioPlayer.setShuffleModeEnabled(true);
        }
        context.read<PlaySongBloc>().add(DurationEvent(
          duration,
          position,
        ));
      });
    } catch(e) {print(e);}

  }
  playPlayList(String? uri,AudioPlayer audioPlayers,BuildContext context,ConcatenatingAudioSource? concatenatingAudioSource) async {

    await audioPlayers.setAudioSource(concatenatingAudioSource!, initialIndex: 0, initialPosition: Duration.zero);
    audioPlayers.play();
    await audioPlayers.seekToNext();                     // Skip to the next item
    await audioPlayers.seekToPrevious();                 // Skip to the previous item
    await audioPlayers.seek(Duration.zero, index: 2);    // Skip to the start of track3.mp3
    await audioPlayers.setLoopMode(LoopMode.all);        // Set playlist to loop (off|all|one)
    await audioPlayers.setShuffleModeEnabled(true);
  }
}