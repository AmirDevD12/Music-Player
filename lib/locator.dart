
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/model/chckFavorite.dart';
import 'package:first_project/model/info_for_route.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'bloc/newSong/play_new_song_bloc.dart';
import 'bloc/play_song_bloc.dart';
import 'core/theme/theme_mode.dart';
import 'model/LIstAlbum.dart';
import 'model/addres_folder.dart';
import 'model/chengeAnimation.dart';
import 'model/dataBase/favorite_dataBase/favorite_song.dart';
import 'model/delete_model.dart';
import 'model/get_song_file.dart';
import 'model/list_artist.dart';
import 'model/newSong.dart';
import 'model/path_song.dart';
import 'model/song_count_artist.dart';
import 'model/songs_model.dart';

final locator= GetIt.instance;

Future<void> setup() async {
  GetIt.I.registerSingleton<AudioPlayer>(AudioPlayer());
  GetIt.I.registerSingleton<PlaySongBloc>(PlaySongBloc());
  GetIt.I.registerSingleton<SortSongBloc>(SortSongBloc());
  GetIt.I.registerSingleton<FavoriteBloc>(FavoriteBloc());
  GetIt.I.registerSingleton<PlayListBloc>(PlayListBloc());
  GetIt.I.registerSingleton<PlayNewSongBloc>(PlayNewSongBloc());
  ///model division
  GetIt.I.registerSingleton<AddressFolder>(AddressFolder());
  GetIt.I.registerSingleton<GetSongFile>(GetSongFile());
  GetIt.I.registerSingleton<SongCountArtist>(SongCountArtist());
  GetIt.I.registerSingleton<ListArtist>(ListArtist());
  GetIt.I.registerSingleton<ListAlbum>(ListAlbum());
  GetIt.I.registerSingleton<SongList>(SongList());
  GetIt.I.registerSingleton<PathSong>(PathSong());
  ///futuer
  GetIt.I.registerSingleton<CheckFavorite>(CheckFavorite());
  GetIt.I.registerSingleton<ChangeAnimation>(ChangeAnimation());
  GetIt.I.registerSingleton<PlayNewSong>(PlayNewSong());
  GetIt.I.registerSingleton<DeleteSongFile>(DeleteSongFile());
  GetIt.I.registerSingleton<FavoriteSongAdapter>(FavoriteSongAdapter());
  GetIt.I.registerSingleton<MyThemes>(MyThemes());
  GetIt.I.registerSingleton<InfoPage>(InfoPage( concatenatingAudioSource: null, index: 0, songs:await SongList().getSongs(SongSortType.DATE_ADDED), nameList: null));


}