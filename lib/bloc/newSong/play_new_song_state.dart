part of 'play_new_song_bloc.dart';

@immutable
abstract class PlayNewSongState {}

class PlayNewSongInitial extends PlayNewSongState {}
class NewSongState extends PlayNewSongState{

 final int index;
 final List<SongModel> listSong;
  NewSongState( this.index, this.listSong);
}
class PauseAnimationState extends PlayNewSongState{}
class ChangIconState extends PlayNewSongState{}