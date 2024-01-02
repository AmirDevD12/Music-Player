part of 'play_new_song_bloc.dart';

@immutable
abstract class PlayNewSongEvent {}
class NewSongEvent extends PlayNewSongEvent{
final SongModel songModel;
final int index;
  NewSongEvent(this.songModel, this.index);
}
class PauseAnimationEvent extends PlayNewSongEvent{}
class ChangIconEvent extends PlayNewSongEvent{}