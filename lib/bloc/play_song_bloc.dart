import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

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


  }
}
