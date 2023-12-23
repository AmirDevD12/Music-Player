import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'play_list_event.dart';
part 'play_list_state.dart';

class PlayListBloc extends Bloc<PlayListEvent, PlayListState> {
  PlayListBloc() : super(PlayListInitial()) {
    on<PlayListEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AddFromListEvent>((event, emit) {
      // TODO: implement event handle
         emit(AddFromListState());
    });
    on<ShowBoxEvent>((event, emit) {
      // TODO: implement event handle
      emit(ShowBoxState());
    });
    on<SelectEvent>((event, emit) {
      // TODO: implement event handle
      emit(SelectState(event.name));
    });
  }
}
