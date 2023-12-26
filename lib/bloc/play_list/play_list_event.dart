part of 'play_list_bloc.dart';

@immutable
abstract class PlayListEvent {}
class AddFromListEvent extends PlayListEvent {}
class ShowBoxEvent extends PlayListEvent {}
class SelectListEvent extends PlayListEvent {}
class NewListEvent extends PlayListEvent {}