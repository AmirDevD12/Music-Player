part of 'play_song_bloc.dart';

@immutable
abstract class PlaySongState {}

class PlaySongInitial extends PlaySongState {}
class DurationState extends PlaySongState {
  final double start;
  final double finish;
  DurationState(this.start, this.finish);
}
class PausePlayState extends PlaySongState{}
