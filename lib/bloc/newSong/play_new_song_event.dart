part of 'play_new_song_bloc.dart';

@immutable
abstract class PlayNewSongEvent {}
class NewSongEvent extends PlayNewSongEvent{
final int index;
final List<SongModel> listSong;
  NewSongEvent( this.index, this.listSong);
}
class PauseAnimationEvent extends PlayNewSongEvent{}
class ChangIconEvent extends PlayNewSongEvent{}