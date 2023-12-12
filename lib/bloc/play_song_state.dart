part of 'play_song_bloc.dart';

@immutable
abstract class PlaySongState {}

class PlaySongInitial extends PlaySongState {}
class DurationState extends PlaySongState {
  final Duration start;
  final Duration finish;
  DurationState(this.start, this.finish);
}
class PausePlayState extends PlaySongState{}
class ShowNavState extends PlaySongState{
  SongModel songModel;
  ShowNavState(this.songModel);
}
class DeleteSongState extends PlaySongState{}
