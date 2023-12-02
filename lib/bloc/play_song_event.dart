part of 'play_song_bloc.dart';

@immutable
abstract class PlaySongEvent {}
class DurationEvent extends PlaySongEvent{
  final double start;
  final double finish;
  DurationEvent(this.start, this.finish);
}
class PausePlayEvent extends PlaySongEvent{}
