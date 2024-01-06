part of 'play_new_song_bloc.dart';

@immutable
abstract class PlayNewSongState {}

class PlayNewSongInitial extends PlayNewSongState {}
class NewSongState extends PlayNewSongState{

 final int index;
 final List<SongModel> listSong;
 final SongModel song;
  NewSongState( this.index, this.listSong, this.song);
}
class PauseAnimationState extends PlayNewSongState{}
class ChangIconState extends PlayNewSongState{}