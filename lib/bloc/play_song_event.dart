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
  final List<SongModel> listSong;
  bool play;
  ShowEvent(this.play, this.listSong);
}
class DeleteSongEvent extends PlaySongEvent{
  String path;

  DeleteSongEvent(this.path);
}
