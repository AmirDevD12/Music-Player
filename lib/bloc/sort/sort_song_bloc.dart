import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'sort_song_event.dart';
part 'sort_song_state.dart';

class SortSongBloc extends Bloc<SortSongEvent, SortSongState> {
  SortSongBloc() : super(SortSongInitial()) {
    on<SortByAddEvent>((event, emit) {
        emit(SortByAddState(event.songSortType));
    });
    on<SearchEvent>((event, emit) {
      emit(SearchState());
    });

  }
}
