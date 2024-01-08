part of 'play_new_song_bloc.dart';

@immutable
abstract class PlayNewSongState {}

class PlayNewSongInitial extends PlayNewSongState {}
class NewSongState extends PlayNewSongState{

 final int index;


  NewSongState( this.index,);
}
class PauseAnimationState extends PlayNewSongState{}
class ChangIconState extends PlayNewSongState{}