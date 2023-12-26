part of 'play_list_bloc.dart';

@immutable
abstract class PlayListState {}

class PlayListInitial extends PlayListState {}
class AddFromListState extends PlayListState{}
class ShowBoxState extends PlayListState{}
class SelectListState extends PlayListState{}
class NewListState extends PlayListState{}

