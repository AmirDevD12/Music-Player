import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dataBase/favorite_dataBase/favorite_song.dart';

class CheckFavorite{

   check(String? pathFile, BuildContext context,bool playFavorite) {
    Box favorite = Hive.box<FavoriteSong>("Favorite");
    bool check = false;
  if (!playFavorite) {
    for (int i = 0; i < favorite.length; i++) {
      final FavoriteSong favoriteSongs = favorite.getAt(i);
      if (favoriteSongs.path == pathFile) {
        context.read<FavoriteBloc>().add(FavoriteSongEvent(true));
        check = true;
        break;
      }
      if (!check) {
        context.read<FavoriteBloc>().add(FavoriteSongEvent(false));
      }
    }

  }else {
    context.read<FavoriteBloc>().add(FavoriteSongEvent(playFavorite));
  }
  }

   void deleteFavorite(String path, BuildContext context,) {
     Box favorite = Hive.box<FavoriteSong>("Favorite");
        for (int i = 0; i < favorite.length; i++) {
          final FavoriteSong favoriteSongs = favorite.getAt(i);
          if (favoriteSongs.path == path) {
            favorite.deleteAt(i);
            context.read<FavoriteBloc>().add(FavoriteSongEvent(false));
            break;
          }
        }
   }


  void add(SongModel songModel, BuildContext context) async {
     var box = await Hive.openBox<FavoriteSong>("Favorite");
     FavoriteSong favorite = FavoriteSong(
         songModel.title, songModel.data, songModel.id, songModel.artist!);
     await box.add(favorite);
     context.read<FavoriteBloc>().add(FavoriteSongEvent(true));
   }
}