part of 'sort_song_bloc.dart';

@immutable
abstract class SortSongEvent {}
class SortByAddEvent extends SortSongEvent{}
class SortByTitleEvent extends SortSongEvent{}
class SortByArtistEvent extends SortSongEvent{}