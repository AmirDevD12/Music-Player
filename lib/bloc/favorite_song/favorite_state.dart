part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}
class FavoriteSongState extends FavoriteState {
 final bool like;
 FavoriteSongState(this.like);
}
