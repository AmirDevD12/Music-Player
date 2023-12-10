part of 'sort_song_bloc.dart';

@immutable
abstract class SortSongState {}

class SortSongInitial extends SortSongState {}
class SortByAddState extends SortSongState{
  final SongSortType songSortType;

  SortByAddState(this.songSortType);
}
