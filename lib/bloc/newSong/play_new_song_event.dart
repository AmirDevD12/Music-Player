part of 'play_new_song_bloc.dart';

@immutable
abstract class PlayNewSongEvent {}
class NewSongEvent extends PlayNewSongEvent{
final int index;
final List<SongModel> listSong;
final SongModel song;
  NewSongEvent( this.index, this.listSong, this.song);
}
class PauseAnimationEvent extends PlayNewSongEvent{}
class ChangIconEvent extends PlayNewSongEvent{}