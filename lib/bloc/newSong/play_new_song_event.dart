part of 'play_new_song_bloc.dart';

@immutable
abstract class PlayNewSongEvent {}
class NewSongEvent extends PlayNewSongEvent{
  final int id;
  final String name;
  final String artist;
  final int index;

  NewSongEvent(this.id, this.name, this.artist,this.index);
}
class PauseAnimationEvent extends PlayNewSongEvent{}
class ChangIconEvent extends PlayNewSongEvent{}