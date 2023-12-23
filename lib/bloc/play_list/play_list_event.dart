part of 'play_list_bloc.dart';

@immutable
abstract class PlayListEvent {}
class AddFromListEvent extends PlayListEvent {}
class ShowBoxEvent extends PlayListEvent {}
class SelectEvent extends PlayListEvent {
  List<String> name;
  SelectEvent(this.name);
}