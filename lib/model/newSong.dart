import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class PlayNewSong {
  void newSong(int index, BuildContext context,ConcatenatingAudioSource? concatenatingAudioSources,bool queue) {

    Duration duration = const Duration();
    Duration position = const Duration();
    try {
      if (concatenatingAudioSources!=null) {
        if (!queue) {
          locator.get<AudioPlayer>().setAudioSource(concatenatingAudioSources, initialIndex: index, initialPosition: Duration.zero);
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

            locator.get<AudioPlayer>().setAudioSource(concatenatingAudioSources, initialIndex: index, initialPosition: Duration.zero);
            locator.get<AudioPlayer>().play();
          }

          context.read<PlaySongBloc>().add(DurationEvent(
            duration,
            position,
          ));
        });
      }
      locator.get<AudioPlayer>().durationStream.listen((event) {
        duration = event!;

        context.read<PlaySongBloc>().add(DurationEvent(
          duration,
          position,
        ));
      });
      locator.get<AudioPlayer>().positionStream.listen((event) async {
        position = event;

        context.read<PlaySongBloc>().add(DurationEvent(
          duration,
          position,
        ));
      });
    } catch(e) {print(e);}

  }
}