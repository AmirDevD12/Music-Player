import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sort_song_event.dart';
part 'sort_song_state.dart';

class SortSongBloc extends Bloc<SortSongEvent, SortSongState> {
  SortSongBloc() : super(SortSongInitial()) {
    on<SortByAddEvent>((event, emit) {
        emit(SortByAddState());
    });
    on<SortByTitleEvent>((event, emit) {
      // TODO: implement event handler
      emit(SortByTitleState());
    });
    on<SortByArtistEvent>((event, emit) {
      // TODO: implement event handler
      emit(SortByArtistState());
    });
  }
}
