
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'bloc/newSong/play_new_song_bloc.dart';
import 'bloc/play_song_bloc.dart';
import 'model/LIstAlbum.dart';
import 'model/addres_folder.dart';
import 'model/chengeAnimation.dart';
import 'model/delete_model.dart';
import 'model/get_song_file.dart';
import 'model/list_artist.dart';
import 'model/newSong.dart';
import 'model/path_song.dart';
import 'model/song_count_artist.dart';
import 'model/songs_model.dart';

final locator= GetIt.instance;

void setup() {
  GetIt.I.registerSingleton<AudioPlayer>(AudioPlayer());
  GetIt.I.registerSingleton<PlaySongBloc>(PlaySongBloc());
  GetIt.I.registerSingleton<SortSongBloc>(SortSongBloc());
  GetIt.I.registerSingleton<FavoriteBloc>(FavoriteBloc());

  GetIt.I.registerSingleton<PlayNewSongBloc>(PlayNewSongBloc());
  GetIt.I.registerSingleton<AddressFolder>(AddressFolder());
  GetIt.I.registerSingleton<GetSongFile>(GetSongFile());
  GetIt.I.registerSingleton<SongCountArtist>(SongCountArtist());
  GetIt.I.registerSingleton<ListArtist>(ListArtist());
  ///asdc
  GetIt.I.registerSingleton<ListAlbum>(ListAlbum());
  GetIt.I.registerSingleton<ChangeAnimation>(ChangeAnimation());
  GetIt.I.registerSingleton<PlayNewSong>(PlayNewSong());
  GetIt.I.registerSingleton<SongList>(SongList());
  GetIt.I.registerSingleton<PathSong>(PathSong());
  GetIt.I.registerSingleton<DeleteSong>(DeleteSong());
}