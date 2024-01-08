part of 'sort_song_bloc.dart';

@immutable
abstract class SortSongEvent {}
class SortByAddEvent extends SortSongEvent{
  final SongSortType songSortType;

  SortByAddEvent(this.songSortType);
}
class SearchEvent extends SortSongEvent{}
