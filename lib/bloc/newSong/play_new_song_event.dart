part of 'play_new_song_bloc.dart';

@immutable
abstract class PlayNewSongEvent {}
class NewSongEvent extends PlayNewSongEvent{
final int index;


  NewSongEvent( this.index, );
}
class PauseAnimationEvent extends PlayNewSongEvent{}
class ChangIconEvent extends PlayNewSongEvent{}