import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'play_new_song_event.dart';
part 'play_new_song_state.dart';

class PlayNewSongBloc extends Bloc<PlayNewSongEvent, PlayNewSongState> {
  PlayNewSongBloc() : super(PlayNewSongInitial()) {
    on<PlayNewSongEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<NewSongEvent>((event, emit){
      emit (NewSongState(event.index,event.listSong,event.song));
    });

    on<PauseAnimationEvent>((event, emit){emit(PauseAnimationState());});
    on<ChangIconEvent>((event, emit){emit(ChangIconState());});

  }
}
