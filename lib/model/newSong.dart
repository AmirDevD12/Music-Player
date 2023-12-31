import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class PlayNewSong {
  void newSong(int index, BuildContext context,ConcatenatingAudioSource? concatenatingAudioSources,bool queue) {

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
      if (concatenatingAudioSources!=null) {
        if (!queue) {
          locator.get<AudioPlayer>().setAudioSource(concatenatingAudioSources!, initialIndex: index, initialPosition: Duration.zero);
        }
        locator.get<AudioPlayer>().play();
        locator.get<AudioPlayer>().durationStream.listen((event) {
          duration = event!;
          context.read<PlaySongBloc>().add(DurationEvent(
            duration,
            position,
          ));
        });
        locator.get<AudioPlayer>().positionStream.listen((event) async {
          position = event;
          if (position>=duration&&queue) {
            locator.get<AudioPlayer>().setAudioSource(concatenatingAudioSources!, initialIndex: index, initialPosition: Duration.zero);
            locator.get<AudioPlayer>().play();
          }
          context.read<PlaySongBloc>().add(DurationEvent(
            duration,
            position,
          ));
        });
      }
    } catch(e) {print(e);}

  }
  // playPlayList(String? uri,BuildContext context,ConcatenatingAudioSource? concatenatingAudioSource) async {
  //   await locator.get<AudioPlayer>().setAudioSource(concatenatingAudioSource!, initialIndex: 0, initialPosition: Duration.zero);
  //   locator.get<AudioPlayer>().play();
  //
  //   // await locator.get<AudioPlayer>().;                     // Skip to the next item
  //   await locator.get<AudioPlayer>().seekToPrevious();                 // Skip to the previous item
  //   await locator.get<AudioPlayer>().seek(Duration.zero, index: 2);    // Skip to the start of track3.mp3
  //   await locator.get<AudioPlayer>().setLoopMode(LoopMode.all);        // Set playlist to loop (off|all|one)
  //   await locator.get<AudioPlayer>().setShuffleModeEnabled(true);
  // }
}