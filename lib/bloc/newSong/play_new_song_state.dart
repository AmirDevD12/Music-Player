part of 'play_new_song_bloc.dart';

@immutable
abstract class PlayNewSongState {}

class PlayNewSongInitial extends PlayNewSongState {}
class NewSongState extends PlayNewSongState{
  final int id;
  final String name;
  final String artist;
  final int index;

  NewSongState(this.id, this.name, this.artist,this.index);
}
class PauseAnimationState extends PlayNewSongState{}