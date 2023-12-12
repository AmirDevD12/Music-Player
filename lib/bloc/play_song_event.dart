part of 'play_song_bloc.dart';

@immutable
abstract class PlaySongEvent {}
class DurationEvent extends PlaySongEvent{
  final Duration start;
  final Duration finish;
  DurationEvent(this.start, this.finish);
}
class PausePlayEvent extends PlaySongEvent{}
class ShowEvent extends PlaySongEvent{
  SongModel songModel;
  ShowEvent(this.songModel);
}
class DeleteSongEvent extends PlaySongEvent{}
