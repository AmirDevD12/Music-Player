part of 'sort_song_bloc.dart';

@immutable
abstract class SortSongState {}

class SortSongInitial extends SortSongState {}
class SortByAddState extends SortSongState{}
class SortByTitleState extends SortSongState{}
class SortByArtistState extends SortSongState{}