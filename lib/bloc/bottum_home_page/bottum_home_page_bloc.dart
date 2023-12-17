import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottum_home_page_event.dart';
part 'bottum_home_page_state.dart';

class BottumHomePageBloc extends Bloc<BottumHomePageEvent, BottumHomePageState> {
  BottumHomePageBloc() : super(BottumHomePageInitial()) {
    on<BottumHomePageEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<MoveEvent>((event, emit) {
      // TODO: implement event handle
      emit(MoveState());
    });
  }
}
