import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'play_song_event.dart';
part 'play_song_state.dart';

class PlaySongBloc extends Bloc<PlaySongEvent, PlaySongState> {
  PlaySongBloc() : super(PlaySongInitial()) {
    on<PlaySongEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<DurationEvent>((event, emit){
      emit(DurationState(event.start,event.finish));
    });
    on<PausePlayEvent>((event, emit){
      emit(PausePlayState());
    });
    on<ShowEvent>((event, emit){
      emit(ShowNavState(event.songModel,event.play));
    });
    on<DeleteSongEvent>((event, emit){
      emit(DeleteSongState(event.path));
    });
  }
}
