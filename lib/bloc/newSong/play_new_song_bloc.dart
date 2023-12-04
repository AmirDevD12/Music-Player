import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'play_new_song_event.dart';
part 'play_new_song_state.dart';

class PlayNewSongBloc extends Bloc<PlayNewSongEvent, PlayNewSongState> {
  PlayNewSongBloc() : super(PlayNewSongInitial()) {
    on<PlayNewSongEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<NewSongEvent>((event, emit){
      emit (NewSongState(event.id, event.name, event.artist,event.index));
    });

    on<PauseAnimationEvent>((event, emit){emit(PauseAnimationState());});

  }
}
